-----------------------------------------------------------------------
--                               G P S                               --
--                                                                   --
--                     Copyright (C) 2004-2005                       --
--                            AdaCore                                --
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
-- a copy of the GNU General Public License along with this library; --
-- if not,  write to the  Free Software Foundation, Inc.,  59 Temple --
-- Place - Suite 330, Boston, MA 02111-1307, USA.                    --
-----------------------------------------------------------------------

with Gtk.Radio_Button;         use Gtk.Radio_Button;
with Glib.Object;              use Glib.Object;
with Gtk.Widget;               use Gtk.Widget;
with Gtk.Box;                  use Gtk.Box;
with Glib;                     use Glib;
with Glib.Object;              use Glib.Object;
with Gtk.Label;                use Gtk.Label;
with Gtk.Separator;            use Gtk.Separator;

with Ada.Exceptions;           use Ada.Exceptions;
with GPS.Intl;                 use GPS.Intl;
with Creation_Wizard.Full;     use Creation_Wizard.Full;
with Creation_Wizard.Adp;      use Creation_Wizard.Adp;
with Creation_Wizard.Simple;   use Creation_Wizard.Simple;
with GPS.Kernel;               use GPS.Kernel;
with GPS.Kernel.Project;       use GPS.Kernel.Project;
with Traces;                   use Traces;
with Wizards;                  use Wizards;
with Creation_Wizard;          use Creation_Wizard;

package body Creation_Wizard.Selector is

   From_Sources_Label : constant String := "From existing Ada sources";
   From_Scratch_Label : constant String := "From scratch";
   From_Adp_Label     : constant String := "From .adp file";

   type Wizard_Selector_Page is new Project_Wizard_Page_Record with record
      Last_Selected : Integer := -1;
      Name_And_Loc  : Name_And_Location_Page_Access;
      From_Scratch  : Gtk_Radio_Button;
      From_Existing : Gtk_Radio_Button;
      From_Adp      : Gtk_Radio_Button;
   end record;
   type Wizard_Selector_Page_Access is access all Wizard_Selector_Page'Class;
   function Create_Content
     (Page : access Wizard_Selector_Page;
      Wiz  : access Wizard_Record'Class) return Gtk.Widget.Gtk_Widget;
   procedure Generate_Project
     (Page    : access Wizard_Selector_Page;
      Kernel  : access GPS.Kernel.Kernel_Handle_Record'Class;
      Scenario_Variables : Projects.Scenario_Variable_Array;
      Project : in out Projects.Project_Type;
      Changed : in out Boolean);
   function Next_Page
     (Page : access Wizard_Selector_Page;
      Wiz  : access Wizard_Record'Class) return Wizard_Page;
   --  See inherited documentation

   ---------------
   -- Next_Page --
   ---------------

   function Next_Page
     (Page : access Wizard_Selector_Page;
      Wiz  : access Wizard_Record'Class) return Wizard_Page
   is
      Selected : Integer;
   begin
      if Get_Active (Page.From_Existing) then
         Selected := 1;
      elsif Get_Active (Page.From_Adp) then
         Selected := 2;
      else
         Selected := 3;
      end if;

      if Page.Last_Selected /= Selected then
         Page.Last_Selected := Selected;
         Remove_Pages (Wiz, After => Page.Name_And_Loc);
         case Selected is
            when 1 => Add_Simple_Wizard_Pages (Project_Wizard (Wiz));
            when 2 => Add_Adp_Wizard_Pages (Project_Wizard (Wiz));
            when others => Add_Full_Wizard_Pages
                 (Project_Wizard (Wiz), Page.Name_And_Loc);
         end case;
      end if;

      return null;
   end Next_Page;

   ----------------------
   -- Generate_Project --
   ----------------------

   procedure Generate_Project
     (Page    : access Wizard_Selector_Page;
      Kernel  : access GPS.Kernel.Kernel_Handle_Record'Class;
      Scenario_Variables : Projects.Scenario_Variable_Array;
      Project : in out Projects.Project_Type;
      Changed : in out Boolean)
   is
      pragma Unreferenced (Page, Kernel, Scenario_Variables, Project, Changed);
   begin
      null;
   end Generate_Project;

   ------------------------
   -- Create_New_Project --
   ------------------------

   function Create_New_Project
     (Kernel : access GPS.Kernel.Kernel_Handle_Record'Class) return Boolean
   is
      Wiz  : Project_Wizard;
      P    : Wizard_Selector_Page_Access;
   begin
      Gtk_New (Wiz, Kernel);
      P := new Wizard_Selector_Page;
      Add_Page (Wiz,
                Page        => P,
                Description => -"Select the type of project to create",
                Toc         => -"Project type");

      P.Name_And_Loc := Add_Name_And_Location_Page (Wiz);

      declare
         Name : constant String := Run (Wiz);
      begin
         if Name /= "" then
            Load_Project (Kernel, Name);
            return True;
         end if;
      end;

      return False;

   exception
      when E : others =>
         Trace (Exception_Handle,
                "Unexpected exception " & Exception_Information (E));
         return False;
   end Create_New_Project;

   --------------------
   -- Create_Content --
   --------------------

   function Create_Content
     (Page : access Wizard_Selector_Page;
      Wiz  : access Wizard_Record'Class) return Gtk.Widget.Gtk_Widget
   is
      pragma Unreferenced (Wiz);
      Button    : Gtk_Widget;
      Box       : Gtk_Box;
      Separator : Gtk_Separator;
      Label     : Gtk_Label;
      pragma Unreferenced (Button);
   begin
      Gtk_New_Vbox (Box, Homogeneous => False);

      Gtk_New (Page.From_Existing, Label => -From_Sources_Label);
      Pack_Start (Box, Page.From_Existing, Expand => False);
      Gtk_New
        (Label,
         -("Create a new set of projects given a set of source directories"
           & ASCII.LF
           & "and a set of object directories. GPS will try to create"
           & ASCII.LF
           & "projects so as to be able to get the same location for"
           & ASCII.LF
           & "object files when your application is build using project"
           & ASCII.LF
           & "files as it was when you build it previously."));
      Set_Padding (Label, 20, 5);
      Set_Alignment (Label, 0.0, 0.5);
      Pack_Start (Box, Label, Expand => False);
      Gtk_New_Hseparator (Separator);
      Pack_Start (Box, Separator, Expand => False);

      Gtk_New (Page.From_Scratch, Get_Group (Page.From_Existing),
               -From_Scratch_Label);
      Pack_Start (Box, Page.From_Scratch, Expand => False);
      Gtk_New
        (Label,
         -("Create a new project file, where you can specify each of its"
           & ASCII.LF
           & "properties, like the set of source directories, its object"
           & ASCII.LF
           & "directory, compiler switches,..."));
      Set_Padding (Label, 20, 5);
      Set_Alignment (Label, 0.0, 0.5);
      Pack_Start (Box, Label, Expand => False);
      Gtk_New_Hseparator (Separator);
      Pack_Start (Box, Separator, Expand => False);

      Gtk_New (Page.From_Adp, Get_Group (Page.From_Existing),
               -From_Adp_Label);
      Pack_Start (Box, Page.From_Adp, Expand => False);
      Gtk_New
        (Label,
         -(".adp files are the project files used in the AdaCore's Glide"
           & ASCII.LF
           & "environment, based on Emacs. It is a very simple project."
           & ASCII.LF
           & "This wizard will allow you to easily convert such a file to"
           & ASCII.LF
           & "GPS's own format"));
      Set_Padding (Label, 20, 5);
      Set_Alignment (Label, 0.0, 0.5);
      Pack_Start (Box, Label, Expand => False);

      Set_Active (Page.From_Scratch, True);
      return Gtk_Widget (Box);
   end Create_Content;

   --------------------
   -- On_New_Project --
   --------------------

   procedure On_New_Project
     (Widget : access Glib.Object.GObject_Record'Class;
      Kernel : GPS.Kernel.Kernel_Handle)
   is
      Tmp : Boolean;
      pragma Unreferenced (Widget, Tmp);
   begin
      Tmp := Create_New_Project (Kernel);
   end On_New_Project;

end Creation_Wizard.Selector;
