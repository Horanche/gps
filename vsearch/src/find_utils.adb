-----------------------------------------------------------------------
--                              G P S                                --
--                                                                   --
--                     Copyright (C) 2001-2004                       --
--                            ACT-Europe                             --
--                                                                   --
-- GPS is free  software;  you can redistribute it and/or modify  it --
-- under the terms of the GNU General Public License as published by --
-- the Free Software Foundation; either version 2 of the License, or --
-- (at your option) any later version.                               --
--                                                                   --
-- This program is  distributed in the hope that it will be  useful, --
-- but  WITHOUT ANY WARRANTY;  without even the  implied warranty of --
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU --
-- General Public License for more details. You should have received --
-- a copy of the GNU General Public License along with this program; --
-- if not,  write to the  Free Software Foundation, Inc.,  59 Temple --
-- Place - Suite 330, Boston, MA 02111-1307, USA.                    --
-----------------------------------------------------------------------

with Ada.Unchecked_Deallocation;
with Ada.Characters.Handling;   use Ada.Characters.Handling;
with Ada.Exceptions;            use Ada.Exceptions;
with Glib.Unicode;              use Glib.Unicode;
with Boyer_Moore;               use Boyer_Moore;
with Glide_Kernel;              use Glide_Kernel;
with Traces;                    use Traces;
with GNAT.Regpat;               use GNAT.Regpat;
with GNAT.OS_Lib;               use GNAT.OS_Lib;
with Gtk.Widget;                use Gtk.Widget;
with Vsearch_Ext;               use Vsearch_Ext;
with Glide_Kernel.Hooks;        use Glide_Kernel.Hooks;

package body Find_Utils is

   Me : constant Debug_Handle := Create ("Find_Utils");

   procedure Free_Pattern_Matcher is new Ada.Unchecked_Deallocation
     (Pattern_Matcher, Pattern_Matcher_Access);

   procedure Free_Match_Array is new Ada.Unchecked_Deallocation
     (Match_Array, Match_Array_Access);

   function Is_Word_Delimiter (C : Character) return Boolean;
   pragma Inline (Is_Word_Delimiter);
   --  Return True if C is a character which can't be in a word.

   function End_Of_Line (Buffer : String; Pos : Natural) return Integer;
   pragma Inline (End_Of_Line);
   --  Return the index for the end of the line containing Pos

   procedure Register_Search_Function
     (Kernel : access Glide_Kernel.Kernel_Handle_Record'Class;
      Data   : Search_Module_Data)
      renames Vsearch_Ext.Register_Search_Function;

   function Search_Context_From_Module
     (Id : access Glide_Kernel.Module_ID_Record'Class)
      return Find_Utils.Search_Module_Data
      renames Vsearch_Ext.Search_Context_From_Module;

   -----------------------
   -- Is_Word_Delimiter --
   -----------------------

   function Is_Word_Delimiter (C : Character) return Boolean is
   begin
      return not (Is_Alphanumeric (C) or else C = '_');
   end Is_Word_Delimiter;

   -----------------
   -- End_Of_Line --
   -----------------

   function End_Of_Line (Buffer : String; Pos : Natural) return Integer is
      J : Integer := Pos;
   begin
      while J < Buffer'Last loop
         if Buffer (J) = ASCII.LF
           or else Buffer (J) = ASCII.CR
         then
            return J - 1;
         end if;

         J := J + 1;
      end loop;

      return Buffer'Last;
   end End_Of_Line;

   -----------
   -- Match --
   -----------

   function Match
     (Context     : access Root_Search_Context;
      Buffer      : String;
      Start_Index : Integer := -1;
      End_Index   : Positive := Positive'Last) return Integer
   is
      Result : Integer := -1;

      function Callback (Match : Match_Result) return Boolean;
      --  Simple callback for the search algorithm

      --------------
      -- Callback --
      --------------

      function Callback (Match : Match_Result) return Boolean is
      begin
         Result := Match.Index;
         return False;
      end Callback;

      Index : Integer := Buffer'First;
      Line, Column : Integer := 0;
      Was_Partial : Boolean;
      Start : constant Integer := Integer'Max (Start_Index, Buffer'First);
      Last  : constant Integer := Integer'Min (End_Index, Buffer'Last);
   begin
      Scan_Buffer_No_Scope
        (Context, Buffer, Start, Last, Callback'Unrestricted_Access,
         Index, Line, Column, Was_Partial);
      return Result;
   end Match;

   --------------------------
   -- Scan_Buffer_No_Scope --
   --------------------------

   procedure Scan_Buffer_No_Scope
     (Context     : access Root_Search_Context;
      Buffer      : String;
      Start_Index : Natural;
      End_Index   : Natural;
      Callback    : Scan_Callback;
      Ref_Index   : in out Integer;
      Ref_Line    : in out Integer;
      Ref_Column  : in out Integer;
      Was_Partial : out Boolean)
   is
      Last_Line_Start : Natural := Start_Index;

      procedure Re_Search;
      --  Handle the search for a regular expression

      procedure BM_Search;
      --  Handle the search for a constant string

      ---------------
      -- Re_Search --
      ---------------

      procedure Re_Search is
         RE  : constant Pattern_Matcher := Context_As_Regexp (Context);
         Pos : Natural := Start_Index;
      begin
         --  Special case here: If we have an empty section, do nothing. In
         --  fact, End_Index might be 0 in the following case: we search in
         --  one of the GPS source files for "all but comments". The first
         --  section is empty, and End_Index is 0. However, it is
         --  legitimate, if inefficient, to have an empty section

         if End_Index = 0 then
            return;
         end if;

         loop
            Match (RE, Buffer, Context.Sub_Matches.all, Pos, End_Index);

            --  The second test below works around an apparent bug in
            --  GNAT.Regpat
            exit when Context.Sub_Matches (0) = No_Match
              or else Context.Sub_Matches (0).First > Buffer'Last;

            Pos := Context.Sub_Matches (0).First;
            To_Line_Column
              (Buffer (Ref_Index .. Buffer'Last),
               Pos, Ref_Line, Ref_Column, Last_Line_Start);
            Ref_Index := Pos;

            declare
               Line : String renames
                 Buffer (Last_Line_Start .. End_Of_Line (Buffer, Pos));
            begin
               if not Callback (Match_Result'
                 (Length     => Line'Length,
                  Index      => Pos,
                  Line       => Ref_Line,
                  Column     => Ref_Column,
                  End_Column => Ref_Column +
                    Integer (UTF8_Strlen
                      (Buffer (Context.Sub_Matches (0).First ..
                                 Context.Sub_Matches (0).Last))),
                  Text       => Line))
               then
                  Was_Partial := True;
                  return;
               end if;
            end;

            Pos := Pos + 1;
         end loop;

         Was_Partial := False;
      end Re_Search;

      ---------------
      -- BM_Search --
      ---------------

      procedure BM_Search is
         BM  : Boyer_Moore.Pattern;
         Pos : Integer := Start_Index;
      begin
         Context_As_Boyer_Moore (Context, BM);

         --  The loop is optimized so that the search is as efficient as
         --  possible (we scan the whole buffer, instead of line-by-line
         --  search). We then pay a small price to actually compute the
         --  buffer coordinates, but this algorithm is much faster for files
         --  that don't match.

         loop
            Pos := Search (BM, Buffer (Pos .. End_Index));
            exit when Pos = -1;

            if not Context.Options.Whole_Word
              or else
              ((Pos = Start_Index
                or else Is_Word_Delimiter (Buffer (Pos - 1)))
               and then
                 (Pos + Context.Look_For'Length - 1 = End_Index
                  or else Is_Word_Delimiter
                    (Buffer (Pos + Context.Look_For'Length))))
            then
               To_Line_Column
                 (Buffer (Ref_Index .. Buffer'Last),
                  Pos, Ref_Line, Ref_Column, Last_Line_Start);
               Ref_Index := Pos;

               declare
                  Line : constant String :=
                    Buffer (Last_Line_Start .. End_Of_Line (Buffer, Pos));
               begin
                  if not Callback (Match_Result'
                    (Length     => Line'Length,
                     Index      => Pos,
                     Line       => Ref_Line,
                     Column     => Ref_Column,
                     End_Column => Ref_Column + Context.Look_For'Length,
                     Text       => Line))
                  then
                     Was_Partial := True;
                     return;
                  end if;
               end;
            end if;

            Pos := Pos + 1;
         end loop;
         Was_Partial := False;
      end BM_Search;

   begin
      Was_Partial := False;

      --  ??? Would be nice to handle backward search, which is extremely hard
      --  with regular expressions

      if Context.Options.Regexp then
         Re_Search;
      else
         BM_Search;
      end if;

   exception
      when Invalid_Context =>
         null;
   end Scan_Buffer_No_Scope;

   --------------------
   -- To_Line_Column --
   --------------------

   procedure To_Line_Column
     (Buffer       : Glib.UTF8_String;
      Pos          : Natural;
      Line, Column : in out Natural;
      Line_Start   : in out Natural)
   is
      J         : Natural := Buffer'First;
      Tab_Width : constant Natural := Get_Tab_Width;
   begin
      loop
         exit when J > Pos - 1;

         if Buffer (J) = ASCII.LF
           or else (Buffer (J) = ASCII.CR
                    and then Buffer (J + 1) /= ASCII.LF)
         then
            Line        := Line + 1;
            Column      := 1;
            Line_Start := J + 1;
         else
            if Buffer (J) = ASCII.HT then
               Column := Column + Tab_Width - (Column mod Tab_Width) + 1;
            else
               Column := Column + 1;
            end if;
         end if;

         J := UTF8_Next_Char (Buffer, J);
      end loop;
   end To_Line_Column;

   ----------------------
   -- Context_Look_For --
   ----------------------

   function Context_Look_For
     (Context : access Root_Search_Context) return String is
   begin
      if Context.Look_For = null then
         return "";
      else
         return Context.Look_For.all;
      end if;
   end Context_Look_For;

   -----------------------
   -- Context_As_String --
   -----------------------

   function Context_As_String
     (Context : access Root_Search_Context) return String is
   begin
      if Context.Look_For = null or else Context.Options.Regexp then
         raise Invalid_Context;
      end if;

      return Context.Look_For.all;
   end Context_As_String;

   -----------------------
   -- Context_As_Regexp --
   -----------------------

   function Context_As_Regexp
     (Context : access Root_Search_Context)
      return GNAT.Regpat.Pattern_Matcher
   is
      Flags : Regexp_Flags := Multiple_Lines;
      WD    : constant String := "\b";  -- Word_Delimiter
   begin
      if Context.RE_Matcher = null then
         if not Context.Options.Regexp or else Context.Look_For = null then
            raise Invalid_Context;
         end if;

         if not Context.Options.Case_Sensitive then
            Flags := Flags or Case_Insensitive;
         end if;

         if Context.Options.Whole_Word then
            Context.RE_Matcher := new Pattern_Matcher'
              (Compile (WD & Context.Look_For.all & WD, Flags));
         else
            Context.RE_Matcher := new Pattern_Matcher'
              (Compile (Context.Look_For.all, Flags));
         end if;

         Context.Sub_Matches :=
           new Match_Array (0 .. Paren_Count (Context.RE_Matcher.all));
      end if;

      return Context.RE_Matcher.all;

   exception
      when Expression_Error =>
         Trace (Me, "Invalid regexp: " & Context.Look_For.all);
         raise Invalid_Context;
   end Context_As_Regexp;

   ----------------------------
   -- Context_As_Boyer_Moore --
   ----------------------------

   procedure Context_As_Boyer_Moore
     (Context : access Root_Search_Context;
      Matcher : out Boyer_Moore.Pattern) is
   begin
      if not Context.BM_Initialized then
         if Context.Options.Regexp or else Context.Look_For = null then
            raise Invalid_Context;
         end if;

         Context.BM_Initialized := True;
         Compile (Context.BM_Matcher, Context.Look_For.all,
                  Context.Options.Case_Sensitive);
         Context.Sub_Matches := new Match_Array'(0 => No_Match);
      end if;

      Matcher := Context.BM_Matcher;
   end Context_As_Boyer_Moore;

   -----------------
   -- Set_Context --
   -----------------

   procedure Set_Context
     (Context  : access Root_Search_Context'Class;
      Look_For : String;
      Options  : Search_Options) is
   begin
      Free (Root_Search_Context (Context.all));
      Context.Look_For       := new String'(Look_For);
      Context.Options        := Options;
      Context.BM_Initialized := False;
   end Set_Context;

   ----------
   -- Free --
   ----------

   procedure Free (Context : in out Root_Search_Context) is
   begin
      Free (Context.Look_For);
      Free_Pattern_Matcher (Context.RE_Matcher);
      Free (Context.BM_Matcher);
      Free_Match_Array (Context.Sub_Matches);
   end Free;

   procedure Free (Context : in out Search_Context_Access) is
      procedure Unchecked_Free is new Ada.Unchecked_Deallocation
        (Search_Context'Class, Search_Context_Access);
   begin
      if Context /= null then
         Free (Context.all);
         Unchecked_Free (Context);
      end if;
   end Free;

   -------------
   -- Replace --
   -------------

   function Replace
     (Context         : access Search_Context;
      Kernel          : access Glide_Kernel.Kernel_Handle_Record'Class;
      Replace_String  : String;
      Search_Backward : Boolean) return Boolean
   is
      pragma Unreferenced
        (Context, Kernel, Replace_String, Search_Backward);
   begin
      return False;
   end Replace;

   ------------------
   -- Reset_Search --
   ------------------

   procedure Reset_Search
     (Object : access Glib.Object.GObject_Record'Class;
      Kernel : Glide_Kernel.Kernel_Handle)
   is
      pragma Unreferenced (Object);
   begin
      Run_Hook (Kernel, Search_Reset_Hook);

   exception
      when E : others =>
         Trace (Exception_Handle,
                "Unexpected exception: " & Exception_Information (E));
   end Reset_Search;

   -----------------
   -- Get_Options --
   -----------------

   function Get_Options
     (Context : access Root_Search_Context) return Search_Options is
   begin
      return Context.Options;
   end Get_Options;

   --------------------------
   -- Get_Current_Progress --
   --------------------------

   function Get_Current_Progress
     (Context : access Search_Context) return Integer
   is
      pragma Unreferenced (Context);
   begin
      return 0;
   end Get_Current_Progress;

   ------------------------
   -- Get_Total_Progress --
   ------------------------

   function Get_Total_Progress
     (Context : access Search_Context) return Integer
   is
      pragma Unreferenced (Context);
   begin
      return 1;
   end Get_Total_Progress;

end Find_Utils;
