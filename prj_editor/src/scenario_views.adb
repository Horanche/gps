-----------------------------------------------------------------------
--                               GPS                                 --
--                                                                   --
--                      Copyright (C) 2001-2004                      --
--                            ACT-Europe                             --
--                                                                   --
-- GPS is  free software;  you can redistribute it and/or modify  it --
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

with Glib;            use Glib;
with Glib.Convert;    use Glib.Convert;
with Glib.Object;     use Glib.Object;
with Gtk.Button;      use Gtk.Button;
with Gtk.Dialog;      use Gtk.Dialog;
with Gtk.Enums;       use Gtk.Enums;
with Gtk.GEntry;      use Gtk.GEntry;
with Gtk.Image;       use Gtk.Image;
with Gtk.Label;       use Gtk.Label;
with Gtk.List;        use Gtk.List;
with Gtk.List_Item;   use Gtk.List_Item;
with Gtk.Handlers;
with Gtk.Stock;       use Gtk.Stock;
with Gtk.Table;       use Gtk.Table;
with Gtk.Tooltips;    use Gtk.Tooltips;
with Gtk.Handlers;    use Gtk.Handlers;
with Gtk.Widget;      use Gtk.Widget;
with Gtkada.Combo;    use Gtkada.Combo;
with Gtkada.Dialogs;  use Gtkada.Dialogs;

with Projects.Editor;      use Projects, Projects.Editor;
with Glide_Kernel;         use Glide_Kernel;
with Glide_Kernel.Hooks;   use Glide_Kernel.Hooks;
with Glide_Kernel.Project; use Glide_Kernel.Project;
with Variable_Editors;     use Variable_Editors;
with Glide_Intl;           use Glide_Intl;

with Namet;    use Namet;
with Traces;   use Traces;

package body Scenario_Views is

   Me : constant Debug_Handle := Create ("Scenario_Views");

   procedure Add_Possible_Values
     (List : access Gtk_List_Record'Class;
      Var  : Scenario_Variable);
   --  Add all the possible values for type Typ into the List.

   type Variable_User_Data is record
      View : Scenario_View;
      Var  : Scenario_Variable;
   end record;

   procedure Variable_Value_Changed
     (Combo : access Gtk_Widget_Record'Class;
      User  : Variable_User_Data);
   --  Called when the value of one of the variables has changed.
   --  This recomputes the scenario view, so that changes are reflected in
   --  other parts of Glide.

   procedure Edit_Variable
     (Button : access Gtk_Widget_Record'Class; Data : Variable_User_Data);
   --  Called when editing a variable (name and possible values)

   procedure Delete_Variable
     (Button : access Gtk_Widget_Record'Class; Data : Variable_User_Data);
   --  Called when removing a variable

   procedure Setup (Data : Variable_User_Data; Id : Handler_Id);
   package View_Callback is new Gtk.Handlers.User_Callback_With_Setup
     (Gtk_Widget_Record, Variable_User_Data, Setup);

   type Refresh_Hook_Record is new Hook_No_Args_Record with record
      View : Scenario_View;
   end record;
   type Refresh_Hook is access all Refresh_Hook_Record'Class;
   procedure Execute
     (Hook : Refresh_Hook_Record; Kernel : access Kernel_Handle_Record'Class);
   --  Callback when some aspect of the project has changed, to refresh the
   --  view.

   -----------
   -- Setup --
   -----------

   procedure Setup (Data : Variable_User_Data; Id : Handler_Id) is
   begin
      Add_Watch (Id, Data.View);
   end Setup;

   -------------
   -- Gtk_New --
   -------------

   procedure Gtk_New
     (View : out Scenario_View;
      Kernel : access Kernel_Handle_Record'Class)
   is
   begin
      View := new Scenario_View_Record;
      Initialize (View, Kernel);
   end Gtk_New;

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize
     (View   : access Scenario_View_Record'Class;
      Kernel : access Kernel_Handle_Record'Class)
   is
      Hook : constant Refresh_Hook := new Refresh_Hook_Record'
        (Hook_No_Args_Record with View => Scenario_View (View));
   begin
      View.Kernel := Kernel_Handle (Kernel);
      Gtk.Table.Initialize
        (View,
         Rows        => 1,
         Columns     => 4,
         Homogeneous => False);
      Set_Col_Spacing (View, 0, 0);
      Set_Col_Spacing (View, 1, 10);

      --  We do not need to connect to "project_changed", since it is always
      --  emitted at the same time as a "project_view_changed", and we do the
      --  same thing in both cases.
      Add_Hook
        (Kernel, Project_View_Changed_Hook, Hook, Watch => GObject (View));
      Add_Hook (Kernel, Variable_Changed_Hook, Hook, Watch => GObject (View));

      --  Update the viewer with the current project
      Execute (Hook.all, Kernel);
   end Initialize;

   ----------------------------
   -- Variable_Value_Changed --
   ----------------------------

   procedure Variable_Value_Changed
     (Combo : access Gtk_Widget_Record'Class;
      User  : Variable_User_Data)
   is
      Value : constant String := Get_Text (Get_Entry (Gtkada_Combo (Combo)));
   begin
      if Value /= "" then
         Set_Value (User.Var, Value);
         User.View.Combo_Is_Open := True;
         Recompute_View (User.View.Kernel);
         User.View.Combo_Is_Open := False;
      end if;
   end Variable_Value_Changed;

   -------------------------
   -- Add_Possible_Values --
   -------------------------

   procedure Add_Possible_Values
     (List : access Gtk_List_Record'Class; Var : Scenario_Variable)
   is
      Iter : String_List_Iterator := Value_Of (Var);
      Item : Gtk_List_Item;
   begin
      while not Done (Iter) loop
         --  We know this is a list of static strings
         Get_Name_String (Data (Iter));
         Gtk_New (Item, Locale_To_UTF8
                    (Name_Buffer (Name_Buffer'First .. Name_Len)));
         Add (List, Item);
         Iter := Next (Iter);
      end loop;
      Show_All (List);
   end Add_Possible_Values;

   -------------------
   -- Edit_Variable --
   -------------------

   procedure Edit_Variable
     (Button : access Gtk_Widget_Record'Class; Data : Variable_User_Data)
   is
      pragma Unreferenced (Button);
      Edit : New_Var_Edit;
   begin
      Gtk_New (Edit, Data.View.Kernel, Data.Var, -"Editing a variable");
      Show_All (Edit);
      while Run (Edit) = Gtk_Response_OK
        and then not Update_Variable (Edit)
      loop
         null;
      end loop;
      Destroy (Edit);
   end Edit_Variable;

   ---------------------
   -- Delete_Variable --
   ---------------------

   procedure Delete_Variable
     (Button : access Gtk_Widget_Record'Class; Data : Variable_User_Data)
   is
      pragma Unreferenced (Button);
      Message : constant String :=
        "Doing so will remove all the configurations associated with"
        & ASCII.LF
        & "that variable, except for the currently selected value";

      Response : constant Message_Dialog_Buttons := Message_Dialog
        (Msg           => (-"Are you sure you want to remove the variable ")
           & '"' & External_Reference_Of (Data.Var)
           & """?" & ASCII.LF & (-Message),
         Dialog_Type   => Confirmation,
         Buttons       => Button_OK or Button_Cancel,
         Title         => -"Deleting a variable",
         Justification => Justify_Left,
         Parent        => Get_Current_Window (Data.View.Kernel));
   begin
      if Response = Button_OK then
         Delete_External_Variable
           (Root_Project             => Get_Project (Data.View.Kernel),
            Ext_Variable_Name        => External_Reference_Of (Data.Var),
            Keep_Choice              => Value_Of (Data.Var),
            Delete_Direct_References => False);
         Run_Hook (Data.View.Kernel, Variable_Changed_Hook);

         --  Recompute the view so that the explorer is updated graphically.
         Recompute_View (Data.View.Kernel);

         Trace (Me, "Delete_Variable: " & External_Reference_Of (Data.Var));
      end if;
   end Delete_Variable;

   -------------
   -- Execute --
   -------------

   procedure Execute
     (Hook : Refresh_Hook_Record; Kernel : access Kernel_Handle_Record'Class)
   is
      V      : constant Scenario_View := Hook.View;
      Label  : Gtk_Label;
      Combo  : Gtkada_Combo;
      Row    : Guint;
      Button : Gtk_Button;
      Pix    : Gtk_Image;

      use type Widget_List.Glist;
      Child, Tmp : Widget_List.Glist;
   begin
      --  There is a small problem here: Refresh might be called while one of
      --  the combo boxes is still displayed. Thus, if we destroy it now, any
      --  pending signal on the combo box (like hiding the popup window) will
      --  generate a segmentation fault.
      --  This also saves some refreshing when the values would be reflected
      --  automatically anyway.

      if V.Combo_Is_Open then
         return;
      end if;

      --  Remove all children, except the edit button.

      Child := Children (V);
      Tmp := Widget_List.First (Child);

      while Tmp /= Widget_List.Null_List loop
         Destroy (Widget_List.Get_Data (Tmp));
         Tmp := Widget_List.Next (Tmp);
      end loop;

      Widget_List.Free (Child);

      --  No project view => Clean up the scenario viewer
      if Get_Project (Kernel) = No_Project then
         Resize (V, Rows => 1, Columns => 4);
         Hide_All (V);

      else
         declare
            Scenar_Var : constant Scenario_Variable_Array :=
              Scenario_Variables (Kernel);
         begin
            Resize (V, Rows => Guint (Scenar_Var'Length) + 1, Columns => 4);

            for J in Scenar_Var'Range loop
               Row := Guint (J - Scenar_Var'First) + 1;

               Gtk_New (Button);
               Gtk_New (Pix, Stock_Properties, Icon_Size_Small_Toolbar);
               Add (Button, Pix);
               Attach
                 (V, Button, 0, 1, Row, Row + 1, Xoptions => 0, Yoptions => 0);
               View_Callback.Connect
                 (Button, "clicked",
                  View_Callback.To_Marshaller (Edit_Variable'Access),
                  (View => V, Var => Scenar_Var (J)));
               Set_Tip (Get_Tooltips (V.Kernel), Button,
                        -"Edit variable properties");

               Gtk_New (Button);
               Gtk_New (Pix, Stock_Delete, Icon_Size_Small_Toolbar);
               Add (Button, Pix);
               Attach
                 (V, Button, 1, 2, Row, Row + 1, Xoptions => 0, Yoptions => 0);
               Set_Tip
                 (Get_Tooltips (V.Kernel), Button, -"Delete variable");
               View_Callback.Connect
                 (Button, "clicked",
                  View_Callback.To_Marshaller (Delete_Variable'Access),
                  (View => V, Var => Scenar_Var (J)));

               Gtk_New (Label, Locale_To_UTF8
                        (External_Reference_Of (Scenar_Var (J))));
               Set_Alignment (Label, 0.0, 0.5);
               Attach (V, Label, 2, 3, Row, Row + 1, Xoptions => Fill,
                       Xpadding => 5);

               Gtk_New (Combo);
               Set_Editable (Get_Entry (Combo), False);
               Set_Width_Chars (Get_Entry (Combo), 0);
               Attach (V, Combo, 3, 4, Row, Row + 1);

               Add_Possible_Values (Get_List (Combo), Scenar_Var (J));
               Set_Text (Get_Entry (Combo), Value_Of (Scenar_Var (J)));

               View_Callback.Connect
                 (Combo,
                  "changed",
                  View_Callback.To_Marshaller (Variable_Value_Changed'Access),
                  (View => V, Var => Scenar_Var (J)));
            end loop;
         end;
         Show_All (V);
      end if;
   end Execute;

end Scenario_Views;
