-----------------------------------------------------------------------
--                               G P S                               --
--                                                                   --
--                     Copyright (C) 2001-2002                       --
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

with Ada.Text_IO;               use Ada.Text_IO;
with GNAT.OS_Lib;               use GNAT.OS_Lib;
with GNAT.Directory_Operations; use GNAT.Directory_Operations;
with Ada.Characters.Handling;   use Ada.Characters.Handling;
with Generic_List;

package body Docgen is

   -------------
   -- Compare --
   -------------

   function Compare_Elements (X, Y : Source_File_Information) return Boolean
   is
   begin
      if X.File_Name.all (X.File_Name'First .. X.File_Name'Last - 3) =
        Y.File_Name.all  (Y.File_Name'First .. Y.File_Name'Last - 3) then
         if File_Extension (X.File_Name.all) = ".adb" then
            return False;
         else
            return True;
         end if;
      else
         return X.File_Name.all < Y.File_Name.all;
      end if;
   end Compare_Elements;

   function Compare_Elements_Name
     (X, Y : Entity_List_Information) return Boolean is
   begin
      if X.Is_Private and not Y.Is_Private then
         return False;
      elsif not X.Is_Private and Y.Is_Private then
         return True;
      else
         return X.Short_Name.all < Y.Short_Name.all;
      end if;
   end Compare_Elements_Name;

   function Compare_Elements_Line
     (X, Y : Entity_List_Information) return Boolean is
   begin
      return X.Line < Y.Line;
   end Compare_Elements_Line;

   function Compare_Elements_Column
     (X, Y : Entity_List_Information) return Boolean is
   begin
      return X.Column < Y.Column;
   end Compare_Elements_Column;

   function Compare_Elements_Column
     (X, Y : Reference_List_Information) return Boolean is
   begin
      return X.Column < Y.Column;
   end Compare_Elements_Column;

   function Compare_Elements_Name
     (X, Y : Reference_List_Information) return Boolean is
   begin
      return X.Subprogram_Name.all < Y.Subprogram_Name.all;
   end Compare_Elements_Name;

   ----------
   -- Free --
   ----------

   procedure Free (X : in out Source_File_Information) is
   begin
      if X.File_Name /= null then
         Free (X.File_Name);
      end if;
      if X.Prj_File_Name /= null then
         Free (X.Prj_File_Name);
      end if;
      if X.Package_Name /= null then
         Free (X.Package_Name);
      end if;
   end Free;


   procedure Free (X : in out Entity_List_Information) is
   begin
      if X.Name /= null then
         Free (X.Name);
      end if;
      if X.Short_Name /= null then
         Free (X.Short_Name);
      end if;
      if X.File_Name /= null then
         Free (X.File_Name);
      end if;
      if not Type_Reference_List.Is_Empty (X.Calls_List) then
         Type_Reference_List.Free (X.Calls_List);
      end if;
      if not Type_Reference_List.Is_Empty (X.Called_List) then
         Type_Reference_List.Free (X.Called_List);
      end if;
   end Free;

   procedure Free (X : in out Reference_List_Information) is
   begin
      if X.File_Name /= null then
         Free (X.File_Name);
      end if;
      if X.Subprogram_Name /= null then
         Free (X.Subprogram_Name);
      end if;
   end Free;

   -----------------
   -- Count_Lines --
   -----------------

   function Count_Lines
     (Line    : String) return Natural is
      Line_Nr : Natural;
   begin
      Line_Nr := 1;
      for J in Line'First .. Line'Last loop
         if Line (J) = ASCII.LF then
            Line_Nr := Line_Nr + 1;
         end if;
      end loop;
      return Line_Nr;
   end Count_Lines;

   ----------------------
   -- Get_String_Index --
   ----------------------

   function Get_String_Index
     (Type_Str  : String;
      Index     : Natural;
      Substring : String) return Natural
   is
      L : constant Natural := Substring'Length - 1;
      New_Index : Natural;
   begin
      if Type_Str'Length = 1 then
         if Type_Str = Substring then
            return 1;
         else
            return 0;
         end if;
      end if;
      New_Index := Index;
      while New_Index + L <= Type_Str'Last
        and then Type_Str (New_Index .. New_Index + L) /= Substring
      loop
         New_Index := New_Index + 1;
      end loop;
      if New_Index + L > Type_Str'Last then return 0;
      else return New_Index;
      end if;
   end Get_String_Index;

   -----------------------
   -- Get_Doc_File_Name --
   -----------------------

   function Get_Doc_File_Name
     (Source_Filename : String;
      Source_Path     : String;
      Doc_Suffix      : String) return String is
      --  returns the complete name of the doc file
      Doc_File : constant String := Base_Name (Source_Filename);
      Extens   : constant String := File_Extension (Source_Filename);
   begin
      return Source_Path &
      Doc_File (Doc_File'First .. Doc_File'Last - 4)
      & "_"
      & Extens (Extens'First + 1 .. Extens'Last)
      & Doc_Suffix;
   end Get_Doc_File_Name;

   ------------------------------
   -- Is_Defined_In_Subprogram --
   ------------------------------

   function Is_Defined_In_Subprogram
     (Entity          : String;
      Short_Entity    : String;
      Package_Name    : String) return Boolean is
   begin
      --  check if the short name of the entity starts right
      --  after the package name followed by "."
      if not (Get_String_Index (Entity, 1, To_Lower (Package_Name)) +
                Package_Name'Length + 1
                  < Get_String_Index (Entity, 1, Short_Entity)) and
      --  and that it is really the name at the end of the
      --  entity name, followed by nothing
        Entity'Last = (Get_String_Index (Entity, 1, Short_Entity)) +
        Short_Entity'Last - 1
      then
         return False;
      else
         return True;
      end if;

   end Is_Defined_In_Subprogram;

   -------------------------
   -- Source_File_In_List --
   -------------------------

   function Source_File_In_List
     (Source_File_List : Type_Source_File_List.List;
      Name             : String) return Boolean
   is
      package TSFL renames Type_Source_File_List;

      Source_File_Node : Type_Source_File_List.List_Node;
      Found            : Boolean;
   begin
      Found := False;
      Source_File_Node := TSFL.First (Source_File_List);
      for J in 1 .. TSFL.Length (Source_File_List) loop
         if File_Name  (TSFL.Data (Source_File_Node).File_Name.all)
           = (Name) then
            Found := True;
         end if;
         Source_File_Node := TSFL.Next (Source_File_Node);
      end loop;
      return Found;
   end Source_File_In_List;

   ------------------
   -- Count_Points --
   ------------------

   function Count_Points
     (Text : String) return Natural is
      Counter : Natural;
   begin
      Counter := 0;
      for J in Text'First .. Text'Last loop
         if Text (J) = '.' then
            Counter := Counter + 1;
         end if;
      end loop;
      return Counter;
   end Count_Points;

end Docgen;
