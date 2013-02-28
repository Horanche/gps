------------------------------------------------------------------------------
--                                  G P S                                   --
--                                                                          --
--                        Copyright (C) 2013, AdaCore                       --
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

with GNATCOLL.Projects;       use GNATCOLL.Projects;

with GPS.Core_Kernels;        use GPS.Core_Kernels;
with GPS.Intl;                use GPS.Intl;
with GPS.Scripts.Files;

package body GPS.Scripts.Projects is

   type Project_Properties_Record is new Instance_Property_Record with record
      Project : Project_Type;
   end record;

   Project_Class_Name       : constant String := "Project";

   Name_Cst       : aliased constant String := "name";
   Recursive_Cst  : aliased constant String := "recursive";

   Project_Cmd_Parameters   : constant Cst_Argument_List :=
                                (1 => Name_Cst'Access);

   procedure Project_Command_Handler
     (Data : in out Callback_Data'Class; Command : String);

   procedure Set_Data
     (Instance : Class_Instance; Project  : Project_Type);

   --------------------
   -- Create_Project --
   --------------------

   function Create_Project
     (Script  : access Scripting_Language_Record'Class;
      Project : GNATCOLL.Projects.Project_Type)
      return Class_Instance
   is
      Instance : Class_Instance := No_Class_Instance;
   begin
      if Project /= No_Project then
         Instance := New_Instance
           (Script, New_Class (Get_Repository (Script), Project_Class_Name));
         Set_Data (Instance, Project);
      end if;

      return Instance;
   end Create_Project;

   --------------
   -- Get_Data --
   --------------

   function Get_Data
     (Data : Callback_Data'Class;
      N : Positive)
      return GNATCOLL.Projects.Project_Type
   is
      Class : constant Class_Type := Get_Project_Class (Get_Kernel (Data));
      Inst  : constant Class_Instance :=
        Nth_Arg (Data, N, Class, Allow_Null => True);
      Value : Instance_Property;

   begin
      if Inst = No_Class_Instance then
         return No_Project;
      end if;

      Value := Get_Data (Inst, Project_Class_Name);
      if Value = null then
         return No_Project;
      else
         return Project_Properties_Record (Value.all).Project;
      end if;
   end Get_Data;

   -----------------------
   -- Get_Project_Class --
   -----------------------

   function Get_Project_Class
     (Kernel : access GPS.Core_Kernels.Core_Kernel_Record'Class)
      return Class_Type is
   begin
      return New_Class (Kernel.Scripts, Project_Class_Name);
   end Get_Project_Class;

   -----------------------------
   -- Project_Command_Handler --
   -----------------------------

   procedure Project_Command_Handler
     (Data : in out Callback_Data'Class; Command : String)
   is
      Kernel   : constant Core_Kernel := Get_Kernel (Data);
      Instance : Class_Instance;
      Project  : Project_Type;
   begin
      if Command = Constructor_Method then
         Name_Parameters (Data, Project_Cmd_Parameters);
         Project  := Kernel.Registry.Tree.Project_From_Name
           (Nth_Arg (Data, 2));

         if Project = No_Project then
            Set_Error_Msg (Data, -"No such project: " & Nth_Arg (Data, 2));
         else
            Instance := Nth_Arg (Data, 1, Get_Project_Class (Kernel));
            Set_Data (Instance, Project);
         end if;

      elsif Command = "root" then
         Set_Return_Value
           (Data, Create_Project (Get_Script (Data),
                                  Kernel.Registry.Tree.Root_Project));

      elsif Command = "name" then
         Project := Get_Data (Data, 1);
         Set_Return_Value (Data, Project.Name);

      elsif Command = "file" then
         Project := Get_Data (Data, 1);
         Set_Return_Value
           (Data,
            GPS.Scripts.Files.Create_File
              (Get_Script (Data), Project_Path (Project)));

      elsif Command = "ancestor_deps" then
         declare
            Iter : Project_Iterator;
            P    : Project_Type;
         begin
            Project := Get_Data (Data, 1);
            Set_Return_Value_As_List (Data);
            Iter := Find_All_Projects_Importing
              (Project, Include_Self => True);

            loop
               P := Current (Iter);
               exit when P = No_Project;
               Set_Return_Value
                 (Data, Create_Project (Get_Script (Data), P));
               Next (Iter);
            end loop;
         end;

      elsif Command = "dependencies" then
         Name_Parameters (Data, (1 => Recursive_Cst'Access));
         declare
            Recursive : constant Boolean := Nth_Arg (Data, 2, False);
            Iter : Project_Iterator;
            P    : Project_Type;
         begin
            Project := Get_Data (Data, 1);
            Set_Return_Value_As_List (Data);
            Iter := Start
              (Project, Recursive => True, Direct_Only => not Recursive);

            loop
               P := Current (Iter);
               exit when P = No_Project;
               Set_Return_Value
                 (Data, Create_Project (Get_Script (Data), P));
               Next (Iter);
            end loop;
         end;

      end if;
   end Project_Command_Handler;

   -----------------------
   -- Register_Commands --
   -----------------------

   procedure Register_Commands
     (Kernel : access GPS.Core_Kernels.Core_Kernel_Record'Class)
   is
   begin
      Register_Command
        (Kernel.Scripts, Constructor_Method,
         Minimum_Args => 1,
         Maximum_Args => 1,
         Class        => Get_Project_Class (Kernel),
         Handler      => Project_Command_Handler'Access);
      Register_Command
        (Kernel.Scripts, "root",
         Class         => Get_Project_Class (Kernel),
         Static_Method => True,
         Handler       => Project_Command_Handler'Access);
      Register_Command
        (Kernel.Scripts, "name",
         Class        => Get_Project_Class (Kernel),
         Handler      => Project_Command_Handler'Access);
      Register_Command
        (Kernel.Scripts, "file",
         Class        => Get_Project_Class (Kernel),
         Handler      => Project_Command_Handler'Access);
      Register_Command
        (Kernel.Scripts, "ancestor_deps",
         Class        => Get_Project_Class (Kernel),
         Handler      => Project_Command_Handler'Access);
      Register_Command
        (Kernel.Scripts, "dependencies",
         Class        => Get_Project_Class (Kernel),
         Minimum_Args => 0,
         Maximum_Args => 1,
         Handler      => Project_Command_Handler'Access);
   end Register_Commands;

   --------------
   -- Set_Data --
   --------------

   procedure Set_Data
     (Instance : Class_Instance; Project  : Project_Type) is
   begin
      if not Is_Subclass (Instance, Project_Class_Name) then
         raise Invalid_Data;
      end if;

      Set_Data
        (Instance, Project_Class_Name,
         Project_Properties_Record'(Project => Project));
   end Set_Data;

end GPS.Scripts.Projects;