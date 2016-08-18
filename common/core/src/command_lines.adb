------------------------------------------------------------------------------
--                                  G P S                                   --
--                                                                          --
--                     Copyright (C) 2016, AdaCore                          --
--                                                                          --
-- This is free software;  you can redistribute it  and/or modify it  under --
-- terms of the  GNU General Public License as published  by the Free Soft- --
-- ware  Foundation;  either version 3,  or (at your option) any later ver- --
-- sion.  This software is distributed in the hope  that it will be useful, --
-- but WITHOUT ANY WARRANTY;  without even the implied warranty of MERCHAN- --
-- TABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public --
-- License for  more details.  You should have  received  a copy of the GNU --
-- General  Public  License  distributed  with  this  software;   see  file --
-- COPYING3.  If not, go to http://www.gnu.org/licenses for a complete copy --
-- of the license.                                                          --
------------------------------------------------------------------------------

with GNAT.OS_Lib;

package body Command_Lines is

   procedure Make_Default_Section (Config : in out Command_Line_Configuration);
   --  Make sure that there is a section with empty name in Config

   procedure Check_Initialized (Cmd : in out Command_Line);
   --  Check if Cmd is initialized and initialize it otherwise

   function Starts_With (Value, Prefix : Unbounded_String) return Boolean;
   --  Check if Value starts with given prefix

   function Find_Prefix
     (Conf   : Configuration_References.Element_Access;
      Switch : Unbounded_String) return Unbounded_String;
   --  Look for prefix matching Switch in Configuration

   procedure Append
     (Cmd         : in out Command_Line;
      Item        : Switch;
      Add_Before  : Boolean   := False);
   --  Append given Switch to command line. Keep Cmd unexpanded

   --------------------
   -- Define_Section --
   --------------------

   procedure Define_Section
     (Config  : in out Command_Line_Configuration;
      Section : String)
   is
      Name : constant Unbounded_String := To_Unbounded_String (Section);
   begin
      Make_Default_Section (Config);

      if not Config.Get.Sections.Contains (Name) then
         Config.Get.Sections.Insert (Name, (Name, others => <>));
      end if;
   end Define_Section;

   ------------------
   -- Define_Alias --
   ------------------

   procedure Define_Alias
     (Config   : in out Command_Line_Configuration;
      Switch   : String;
      Expanded : String;
      Section  : String := "")
   is
      Short : constant Unbounded_String := To_Unbounded_String (Switch);
      Long  : constant Unbounded_String := To_Unbounded_String (Expanded);
      Name  : constant Unbounded_String := To_Unbounded_String (Section);
      Conf  : Configuration_References.Element_Access;
   begin
      Make_Default_Section (Config);
      Conf := Config.Unchecked_Get;

      if not Conf.Sections.Contains (Name) then
         raise Invalid_Section;
      end if;

      declare
         Value : Section_Configuration renames Conf.Sections (Name);
      begin
         if not Value.Aliases.Contains (Short)
           and then not Value.Extended.Contains (Long)
         then
            Value.Aliases.Append (Short);
            Value.Extended.Append (Long);
         end if;
      end;
   end Define_Alias;

   -------------------
   -- Define_Prefix --
   -------------------

   procedure Define_Prefix
     (Config : in out Command_Line_Configuration;
      Prefix : String)
   is
      Value : constant Unbounded_String := To_Unbounded_String (Prefix);
   begin
      Make_Default_Section (Config);

      if not Config.Get.Prefixes.Contains (Value) then
         Config.Get.Prefixes.Append (Value);
      end if;
   end Define_Prefix;

   -------------------
   -- Define_Switch --
   -------------------

   procedure Define_Switch
     (Config      : in out Command_Line_Configuration;
      Switch      : String;
      Section     : String := "")
   is
      Key   : constant Unbounded_String := To_Unbounded_String (Switch);
      Name  : constant Unbounded_String := To_Unbounded_String (Section);
      Conf  : Configuration_References.Element_Access;
   begin
      Make_Default_Section (Config);
      Conf := Config.Unchecked_Get;

      if not Conf.Sections.Contains (Name) then
         raise Invalid_Section;
      end if;

      declare
         Value : Section_Configuration renames Conf.Sections (Name);
      begin
         if not Value.Switches.Contains (Key) then
            Value.Switches.Insert
              (Key,
               (Switch    => Key,
                Parameter => (Is_Set => False)));
         end if;
      end;
   end Define_Switch;

   ----------------------------------
   -- Define_Switch_With_Parameter --
   ----------------------------------

   procedure Define_Switch_With_Parameter
     (Config      : in out Command_Line_Configuration;
      Switch      : String;
      Section     : String := "";
      Optional    : Boolean := False)
   is
      Key   : constant Unbounded_String := To_Unbounded_String (Switch);
      Name  : constant Unbounded_String := To_Unbounded_String (Section);
      Conf  : Configuration_References.Element_Access;
   begin
      Make_Default_Section (Config);
      Conf := Config.Unchecked_Get;

      if not Conf.Sections.Contains (Name) then
         raise Invalid_Section;
      end if;

      declare
         Value : Section_Configuration renames Conf.Sections (Name);
      begin
         if not Value.Switches.Contains (Key) then
            Value.Switches.Insert
              (Key,
               (Switch    => Key,
                Parameter => (Is_Set => True,
                              Optional => Optional,
                              Separator => (Is_Set => False))));
         end if;
      end;
   end Define_Switch_With_Parameter;

   ----------------------------------
   -- Define_Switch_With_Parameter --
   ----------------------------------

   procedure Define_Switch_With_Parameter
     (Config      : in out Command_Line_Configuration;
      Switch      : String;
      Section     : String := "";
      Separator   : Character;
      Optional    : Boolean := False)
   is
      Key   : constant Unbounded_String := To_Unbounded_String (Switch);
      Name  : constant Unbounded_String := To_Unbounded_String (Section);
      Conf  : Configuration_References.Element_Access;
   begin
      Make_Default_Section (Config);
      Conf := Config.Unchecked_Get;

      if not Conf.Sections.Contains (Name) then
         raise Invalid_Section;
      end if;

      declare
         Value : Section_Configuration renames Conf.Sections (Name);
      begin
         if not Value.Switches.Contains (Key) then
            Value.Switches.Insert
              (Key,
               (Switch    => Key,
                Parameter => (Is_Set => True,
                              Optional => Optional,
                              Separator => (Is_Set => True,
                                            Value  => Separator))));
         end if;
      end;
   end Define_Switch_With_Parameter;

   ----------
   -- Free --
   ----------

   procedure Free (Config : in out Command_Line_Configuration) is
   begin
      Config := (Configuration_References.Null_Ref with null record);
   end Free;

   --------------------------
   -- Make_Default_Section --
   --------------------------

   procedure Make_Default_Section (Config : in out Command_Line_Configuration)
   is
   begin
      if Config.Is_Null then
         Config.Set (Configuration'(others => <>));

         Config.Get.Sections.Insert
           (Null_Unbounded_String, (Null_Unbounded_String, others => <>));
      end if;
   end Make_Default_Section;

   -----------------------
   -- Check_Initialized --
   -----------------------

   procedure Check_Initialized (Cmd : in out Command_Line) is
   begin
      if Cmd.Switches.Is_Null then
         Cmd.Switches.Set (Switch_Vectors.Empty_Vector);
      end if;
   end Check_Initialized;

   -----------------------
   -- Set_Configuration --
   -----------------------

   procedure Set_Configuration
     (Cmd    : in out Command_Line;
      Config : Command_Line_Configuration) is
   begin
      Cmd.Configuration := Config;
      Make_Default_Section (Cmd.Configuration);
      Check_Initialized (Cmd);
   end Set_Configuration;

   -----------------------
   -- Get_Configuration --
   -----------------------

   function Get_Configuration
     (Cmd : Command_Line)
      return Command_Line_Configuration is
   begin
      return Cmd.Configuration;
   end Get_Configuration;

   ----------------------
   -- Set_Command_Line --
   ----------------------

   procedure Set_Command_Line
     (Cmd                : in out Command_Line;
      Switches           : String;
      Switch_Char        : Character := '-')
   is
      pragma Unreferenced (Switch_Char);
      use GNAT.OS_Lib;

      function Is_Section (Name : String) return Boolean;
      --  Search for section with given Name

      procedure Find_Switch
        (Arg     : String;
         Section : Unbounded_String;
         Result  : out Switch_Configuration;
         Found   : out Boolean);
      --  Search for section with given Name

      Conf : Configuration_References.Element_Access;

      ----------------
      -- Is_Section --
      ----------------

      function Is_Section (Name : String) return Boolean is
         Section : constant Unbounded_String := To_Unbounded_String (Name);
      begin
         return Conf.Sections.Contains (Section);
      end Is_Section;

      -----------------
      -- Find_Switch --
      -----------------

      procedure Find_Switch
        (Arg     : String;
         Section : Unbounded_String;
         Result  : out Switch_Configuration;
         Found   : out Boolean)
      is
         Value  : Section_Configuration renames Conf.Sections (Section);
         Pos    : Switch_Configuration_Maps.Cursor := Value.Switches.First;
         Length : Natural;  --  Length of current switch
      begin
         while Switch_Configuration_Maps.Has_Element (Pos) loop
            Result := Switch_Configuration_Maps.Element (Pos);
            Length := Ada.Strings.Unbounded.Length (Result.Switch);

            --  Check if argument exectly matches switch
            if Result.Switch = Arg then
               Found := True;
               return;

            --  Otherwise check if switch has parameter embeded in argument
            elsif Result.Parameter.Is_Set
              and then Arg'Length > Length
              and then Arg (Arg'First .. Arg'First + Length - 1)
                         = Result.Switch
              and then (not Result.Parameter.Separator.Is_Set
                        or else Result.Parameter.Separator.Value
                                  = Arg (Arg'First + Length))
            then
               Found := True;
               return;
            end if;

            Switch_Configuration_Maps.Next (Pos);
         end loop;

         Found := False;
      end Find_Switch;

      List    : Argument_List_Access := Argument_String_To_List (Switches);
      Last    : Natural := 0;

      Switch_Conf  : Switch_Configuration;
      Section      : Unbounded_String;
      Found        : Boolean;
      Is_Parameter : Boolean := False;
      --  Next argument in list is a parameter of current switch

   begin
      Check_Initialized (Cmd);
      Cmd.Switches.Get.Clear;
      Make_Default_Section (Cmd.Configuration);
      Conf := Cmd.Configuration.Unchecked_Get;

      for Arg of List.all loop
         if Is_Parameter then
            Is_Parameter := False;

            Cmd.Switches.Get.Reference (Last).Parameter :=
              (Is_Set    => True,
               Separator => (Is_Set => True, Value  => ' '),
               Value     => To_Unbounded_String (Arg.all));

         elsif Is_Section (Arg.all) then
            Section := To_Unbounded_String (Arg.all);

         else
            declare
               Item : Switch;
            begin
               Find_Switch (Arg.all, Section, Switch_Conf, Found);

               --  Check if next argument is parameter
               Is_Parameter :=
                 (Found
                  and then Switch_Conf.Parameter.Is_Set
                  and then Switch_Conf.Parameter.Separator.Is_Set
                  and then Switch_Conf.Parameter.Separator.Value = ' ');

               if not Found then
                  Item.Switch := To_Unbounded_String (Arg.all);

               elsif Length (Switch_Conf.Switch) = Arg'Length then
                  Item.Switch := Switch_Conf.Switch;

               elsif Switch_Conf.Parameter.Separator.Is_Set then
                  Item.Switch := Switch_Conf.Switch;
                  Item.Parameter :=
                    (Is_Set    => True,
                     Separator => Switch_Conf.Parameter.Separator,
                     Value     => To_Unbounded_String
                       (Arg (Arg'First + Length (Item.Switch) + 1
                             .. Arg'Last)));

               else
                  Item.Switch := Switch_Conf.Switch;
                  Item.Parameter :=
                    (Is_Set    => True,
                     Separator => (Is_Set => False),
                     Value     => To_Unbounded_String
                       (Arg (Arg'First + Length (Item.Switch) .. Arg'Last)));

               end if;

               Item.Section := Section;
               Append (Cmd, Item);
               Last := Last + 1;
            end;
         end if;
      end loop;

      Free (List);
   end Set_Command_Line;

   -----------------
   -- Starts_With --
   -----------------

   function Starts_With (Value, Prefix : Unbounded_String) return Boolean is
   begin
      return Length (Prefix) < Length (Value)
        and then Prefix = Head (Value, Length (Prefix));
   end Starts_With;

   -----------------
   -- Find_Prefix --
   -----------------

   function Find_Prefix
     (Conf   : Configuration_References.Element_Access;
      Switch : Unbounded_String) return Unbounded_String is
   begin
      for J of Conf.Prefixes loop
         if Starts_With (Switch, J) then
            return J;
         end if;
      end loop;

      return Null_Unbounded_String;
   end Find_Prefix;

   ------------
   -- Append --
   ------------

   procedure Append
     (Cmd         : in out Command_Line;
      Item        : Switch;
      Add_Before  : Boolean   := False)
   is
      Conf : constant Configuration_References.Element_Access :=
        Cmd.Configuration.Unchecked_Get;

      Section    : Section_Configuration renames Conf.Sections (Item.Section);
      Prefix     : Unbounded_String;
   begin
      if not Item.Parameter.Is_Set then
         Prefix := Find_Prefix (Conf, Item.Switch);
      end if;

      --  Expand prefixed switches if found matched prefix
      if Prefix /= "" and then Length (Item.Switch) > Length (Prefix) + 1 then
         for J in Length (Prefix) + 1 .. Length (Item.Switch) loop
            Append
              (Cmd,
               (Switch    => Prefix & Element (Item.Switch, J),
                Section   => Item.Section,
                Parameter => Item.Parameter),
               Add_Before);
         end loop;

         return;
      end if;

      --  Shrink aliases if found
      declare
         Index : constant Natural := Section.Extended.Find_Index (Item.Switch);
      begin
         if Index > 0 then
            Append
              (Cmd,
               (Switch    => Section.Aliases (Index),
                Section   => Item.Section,
                Parameter => Item.Parameter),
               Add_Before);

            return;
         end if;
      end;

      if Prefix /= "" then
         --  Try to merge switches with common prefix
         for J of Cmd.Switches.Unchecked_Get.all loop
            if J.Section = Item.Section
              and then Starts_With (J.Switch, Prefix)
            then
               Append
                 (J.Switch,
                  Slice
                    (Item.Switch,
                     Length (Prefix) + 1,
                     Length (Item.Switch)));

               return;
            end if;
         end loop;
      end if;

      if Add_Before then
         --  Look for first switch in the section
         for J in Cmd.Switches.Get.Iterate loop
            if Switch_Vectors.Element (J).Section = Item.Section then
               Cmd.Switches.Get.Insert
                 (Before   => J,
                  New_Item => Item);

               return;
            end if;
         end loop;

         --  No such section in command line yet
         if Item.Section = "" then
            Cmd.Switches.Get.Prepend (Item);
         else
            Cmd.Switches.Get.Append (Item);
         end if;
      else  --  Add_Before = False
         if Item.Section = ""
           and then not Cmd.Switches.Get.Is_Empty
           and then Cmd.Switches.Get.First_Element.Section /= ""
         then
            --  Add at the beggining of the command line
            Cmd.Switches.Get.Prepend (Item);

            return;
         end if;

         declare
            Found : Boolean := False;  --  If we have found the section
         begin
            for J in Cmd.Switches.Get.Iterate loop
               if not Found
                 and then Switch_Vectors.Element (J).Section = Item.Section
               then
                  Found := True;

               elsif Found
                 and then Switch_Vectors.Element (J).Section /= Item.Section
               then
                  Cmd.Switches.Get.Insert
                    (Before   => J,
                     New_Item => Item);

                  return;
               end if;
            end loop;

            --  Append to the end
            Cmd.Switches.Get.Append (Item);
         end;
      end if;
   end Append;

   ----------------
   -- Add_Switch --
   ----------------

   procedure Add_Switch
     (Cmd        : in out Command_Line;
      Switch     : String;
      Parameter  : String    := "";
      Separator  : Character := ASCII.NUL;
      Section    : String    := "";
      Add_Before : Boolean   := False)
   is
      Success : Boolean;
   begin
      Add_Switch
        (Cmd, Switch, Parameter, Separator, Section, Add_Before, Success);
   end Add_Switch;

   ----------------
   -- Add_Switch --
   ----------------

   procedure Add_Switch
     (Cmd        : in out Command_Line;
      Switch     : String;
      Parameter  : String    := "";
      Separator  : Character := ASCII.NUL;
      Section    : String    := "";
      Add_Before : Boolean   := False;
      Success    : out Boolean)
   is
      Item : Command_Lines.Switch;
   begin
      Check_Initialized (Cmd);
      Item.Switch := To_Unbounded_String (Switch);
      Item.Section := To_Unbounded_String (Section);

      if Parameter /= "" then
         Item.Parameter :=
           (Is_Set    => True,
            Separator => (Is_Set => False),
            Value     => To_Unbounded_String (Parameter));

         if Separator /= ASCII.NUL then
            Item.Parameter.Separator := (Is_Set => True, Value => Separator);
         end if;
      end if;

      Append (Cmd, Item, Add_Before);
      Success := True;
   end Add_Switch;

   -------------------
   -- Remove_Switch --
   -------------------

   procedure Remove_Switch
     (Cmd           : in out Command_Line;
      Switch        : String;
      Has_Parameter : Boolean := False;
      Section       : String  := "")
   is
      Success : Boolean;
   begin
      Remove_Switch (Cmd, Switch, Has_Parameter, Section, Success);
   end Remove_Switch;

   -------------------
   -- Remove_Switch --
   -------------------

   procedure Remove_Switch
     (Cmd           : in out Command_Line;
      Switch        : String;
      Has_Parameter : Boolean := False;
      Section       : String  := "";
      Success       : out Boolean)
   is
      Pos : Switch_Vectors.Cursor;
   begin
      Check_Initialized (Cmd);
      Pos := Cmd.Switches.Get.First;

      while Switch_Vectors.Has_Element (Pos) loop
         declare
            Item : constant Command_Lines.Switch :=
              Switch_Vectors.Element (Pos);
         begin
            if Item.Switch = Switch
              and then Item.Section = Section
              and then Item.Parameter.Is_Set = Has_Parameter
            then
               Cmd.Switches.Get.Delete (Pos);
               Success := True;
               return;
            end if;

            Switch_Vectors.Next (Pos);
         end;
      end loop;

      Success := False;
   end Remove_Switch;

   ----------------
   -- Has_Switch --
   ----------------

   function Has_Switch
     (Cmd     : Command_Line;
      Switch  : String;
      Section : String  := "") return Boolean
   is
      Pos : Switch_Vectors.Cursor;
   begin
      if Cmd.Switches.Is_Null then
         return False;
      end if;

      Pos := Cmd.Switches.Get.First;

      while Switch_Vectors.Has_Element (Pos) loop
         declare
            Item : constant Command_Lines.Switch :=
              Switch_Vectors.Element (Pos);
         begin
            if Item.Switch = Switch
              and then Item.Section = Section
            then
               return True;
            end if;

            Switch_Vectors.Next (Pos);
         end;
      end loop;

      return False;
   end Has_Switch;

   -----------
   -- Start --
   -----------

   procedure Start
     (Cmd      : in out Command_Line;
      Iter     : in out Command_Line_Iterator;
      Expanded : Boolean := False)
   is
   begin
      Check_Initialized (Cmd);

      if Expanded then
         Iter :=
           (Expanded       => True,
            Line           => Cmd,
            Switch_Index   => 1,
            Char_Index     => 1,
            Prefix         => 0,
            Is_New_Section => False);

         if Has_More (Iter) then
            declare
               Next   : constant Switch := Cmd.Switches.Get.First_Element;
               Prefix : constant Unbounded_String :=
                 Find_Prefix (Cmd.Configuration.Unchecked_Get, Next.Switch);
            begin
               if Prefix = "" then
                  Iter.Char_Index := Length (Next.Switch);
               else
                  Iter.Char_Index := Length (Prefix) + 1;
               end if;

               Iter.Prefix := Length (Prefix);
            end;
         end if;
      else
         Iter :=
           (Expanded       => False,
            Line           => Cmd,
            Switch_Index   => 1,
            Is_New_Section => False);
      end if;
   end Start;

   --------------------
   -- Current_Switch --
   --------------------

   function Current_Switch (Iter : Command_Line_Iterator) return String is
      Switch : constant Command_Lines.Switch :=
        Iter.Line.Switches.Get.Reference (Iter.Switch_Index);
      Result : Unbounded_String := Switch.Switch;
   begin
      if Iter.Expanded then
         declare
            Conf : constant Configuration_References.Element_Access :=
              Iter.Line.Configuration.Unchecked_Get;

            Section : Section_Configuration renames
              Conf.Sections (Switch.Section);

            Index : Natural;

         begin
            --  Try to expand prefixed switches
            if Iter.Prefix > 0 then
               Result := Head (Result, Iter.Prefix) &
                 Element (Result, Iter.Char_Index);
            end if;

            --  Try to expand aliases
            Index := Section.Extended.Find_Index (Result);
            if Index > 0 then
               Result := Section.Aliases (Index);
            end if;
         end;
      end if;

      return To_String (Result);
   end Current_Switch;

   --------------------
   -- Is_New_Section --
   --------------------

   function Is_New_Section (Iter : Command_Line_Iterator) return Boolean is
   begin
      return Iter.Is_New_Section;
   end Is_New_Section;

   ---------------------
   -- Current_Section --
   ---------------------

   function Current_Section (Iter : Command_Line_Iterator) return String is
   begin
      return To_String
        (Iter.Line.Switches.Get.Reference (Iter.Switch_Index).Section);
   end Current_Section;

   -----------------------
   -- Current_Separator --
   -----------------------

   function Current_Separator (Iter : Command_Line_Iterator) return String is
      Parameter : constant Argument :=
        Iter.Line.Switches.Get.Reference (Iter.Switch_Index).Parameter;
   begin
      if Parameter.Is_Set
        and then Parameter.Separator.Is_Set
      then
         return (1 => Parameter.Separator.Value);
      else
         return "";
      end if;
   end Current_Separator;

   -----------------------
   -- Current_Parameter --
   -----------------------

   function Current_Parameter (Iter : Command_Line_Iterator) return String is
      Parameter : constant Argument :=
        Iter.Line.Switches.Get.Reference (Iter.Switch_Index).Parameter;
   begin
      if Parameter.Is_Set then
         return To_String (Parameter.Value);
      else
         return "";
      end if;
   end Current_Parameter;

   --------------
   -- Has_More --
   --------------

   function Has_More (Iter : Command_Line_Iterator) return Boolean is
   begin
      return Iter.Switch_Index <= Iter.Line.Switches.Get.Last_Index;
   end Has_More;

   ----------
   -- Next --
   ----------

   procedure Next (Iter : in out Command_Line_Iterator) is
      Switch : constant Command_Lines.Switch :=
        Iter.Line.Switches.Get.Reference (Iter.Switch_Index);
   begin
      if Has_More (Iter) then
         if Iter.Expanded then
            if Iter.Char_Index < Length (Switch.Switch) then
               Iter.Char_Index := Iter.Char_Index + 1;
               return;
            end if;

            Iter.Switch_Index := Iter.Switch_Index + 1;

         else
            Iter.Switch_Index := Iter.Switch_Index + 1;
         end if;

         if Has_More (Iter) then
            if Iter.Expanded then
               declare
                  Next  : constant Command_Lines.Switch :=
                    Iter.Line.Switches.Get.Reference (Iter.Switch_Index);
                  Prefix : constant Unbounded_String :=
                    Find_Prefix (Iter.Line.Configuration.Unchecked_Get,
                                 Next.Switch);
               begin
                  if Prefix = "" then
                     Iter.Char_Index := Length (Next.Switch);
                  else
                     Iter.Char_Index := Length (Prefix) + 1;
                  end if;

                  Iter.Prefix := Length (Prefix);
               end;
            end if;

            Iter.Is_New_Section := Switch.Section /=
              Iter.Line.Switches.Get.Reference (Iter.Switch_Index).Section;
         end if;
      end if;
   end Next;

end Command_Lines;