-----------------------------------------------------------------------
--                          G L I D E  I I                           --
--                                                                   --
--                        Copyright (C) 2001                         --
--                            ACT-Europe                             --
--                                                                   --
-- GVD is free  software;  you can redistribute it and/or modify  it --
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

with Glib;                use Glib;
with Glib.Graphs;         use Glib.Graphs;
with Gdk.Color;           use Gdk.Color;
with Gdk.GC;              use Gdk.GC;
with Gtkada.Canvas;       use Gtkada.Canvas;
with Gtkada.Handlers;     use Gtkada.Handlers;
with Gdk.Drawable;        use Gdk.Drawable;
with Gdk.Event;           use Gdk.Event;
with Gdk.Font;            use Gdk.Font;
with Gdk.Rectangle;       use Gdk.Rectangle;
with Gdk.Types.Keysyms;   use Gdk.Types.Keysyms;
with Gdk.Window;          use Gdk.Window;
with Gtk.Accel_Group;     use Gtk.Accel_Group;
with Gtk.Enums;           use Gtk.Enums;
with Gtk.Handlers;        use Gtk.Handlers;
with Gtk.Check_Menu_Item; use Gtk.Check_Menu_Item;
with Gtk.Menu;            use Gtk.Menu;
with Gtk.Menu_Item;       use Gtk.Menu_Item;
with Gtk.Scrolled_Window; use Gtk.Scrolled_Window;
with Gtk.Style;           use Gtk.Style;
with Gtk.Widget;          use Gtk.Widget;
with Pango.Font;          use Pango.Font;

with Glide_Kernel;              use Glide_Kernel;
with Glide_Kernel.Modules;      use Glide_Kernel.Modules;
with Glide_Kernel.Preferences;  use Glide_Kernel.Preferences;
with Browsers.Dependency_Items; use Browsers.Dependency_Items;
with Browsers.Module;           use Browsers.Module;
with Browsers.Projects;         use Browsers.Projects;
with Layouts;                   use Layouts;
with Src_Info;                  use Src_Info;
with Prj_API;                   use Prj_API;

package body Browsers.Canvas is

   Selected_Link_Color : constant String := "#FF0000";
   --  <preference> Color to use links whose ends are selected.

   Selected_Item_Color : constant String := "#888888";
   --  <preference> Color to use to draw the selected item.

   Linked_Item_Color : constant String := "#BBBBBB";
   --  <preference> Color to use to draw the items that are linked to the
   --  selected item.

   Zoom_Levels : constant array (Positive range <>) of Guint :=
     (25, 50, 75, 100, 150, 200, 300, 400);
   --  All the possible zoom levels. We have to use such an array, instead
   --  of doing the computation directly, so as to avoid rounding errors that
   --  would appear in the computation and make zoom_in not the reverse of
   --  zoom_out.

   Zoom_Steps : constant := 7;
   --  Number of steps while zooming in or out.

   type Cb_Data is record
      Browser : Glide_Browser;
      Zoom    : Guint;
   end record;

   package Contextual_Cb is new Gtk.Handlers.User_Callback
     (Gtk_Widget_Record, Cb_Data);

   procedure Zoom_In (Browser : access Gtk_Widget_Record'Class);
   --  Zoom in to the previous zoom level, if any

   procedure Zoom_Out (Browser : access Gtk_Widget_Record'Class);
   --  Zoom out to the next zoom level, if any

   procedure Zoom_Level
     (Browser : access Gtk_Widget_Record'Class; Data : Cb_Data);
   --  Zoom directly to a specific level (Data.Zoom)

   procedure Realized (Browser : access Gtk_Widget_Record'Class);
   --  Callback for the "realized" signal.

   function Key_Press
     (Browser : access Gtk_Widget_Record'Class; Event : Gdk_Event)
      return Boolean;
   --  Callback for the key press event

   -------------
   -- Gtk_New --
   -------------

   procedure Gtk_New
     (Browser : out Glide_Browser;
      Mask    : Browser_Type_Mask;
      Kernel  : access Glide_Kernel.Kernel_Handle_Record'Class) is
   begin
      Browser := new Glide_Browser_Record;
      Initialize (Browser, Mask, Kernel);
   end Gtk_New;

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize
     (Browser : out Glide_Browser;
      Mask    : Browser_Type_Mask;
      Kernel  : access Glide_Kernel.Kernel_Handle_Record'Class) is
   begin
      Gtk.Scrolled_Window.Initialize (Browser);
      Set_Policy (Browser, Policy_Automatic, Policy_Automatic);
      Gtk_New (Browser.Canvas);
      Add (Browser, Browser.Canvas);
      Add_Events (Browser.Canvas, Key_Press_Mask);
      Browser.Mask := Mask;
      Browser.Kernel := Kernel_Handle (Kernel);

      Set_Layout_Algorithm (Browser.Canvas, Layer_Layout'Access);
      Set_Auto_Layout (Browser.Canvas, False);

      Widget_Callback.Object_Connect
        (Browser.Canvas, "realize",
         Widget_Callback.To_Marshaller (Realized'Access), Browser);

      Gtkada.Handlers.Return_Callback.Object_Connect
        (Browser.Canvas, "key_press_event",
         Gtkada.Handlers.Return_Callback.To_Marshaller (Key_Press'Access),
         Browser);
   end Initialize;

   ---------------
   -- Key_Press --
   ---------------

   function Key_Press
     (Browser : access Gtk_Widget_Record'Class; Event : Gdk_Event)
      return Boolean is
   begin
      case Get_Key_Val (Event) is
         when GDK_equal => Zoom_In (Browser);
         when GDK_minus => Zoom_Out (Browser);
         when others    => null;
      end case;
      return False;
   end Key_Press;

   --------------
   -- Realized --
   --------------

   procedure Realized (Browser : access Gtk_Widget_Record'Class) is
      use type Gdk.Gdk_GC;
      B : Glide_Browser := Glide_Browser (Browser);
      Color : Gdk_Color;
      Desc : Pango_Font_Description;
   begin
      if B.Selected_Link_GC = null then
         Gdk_New (B.Selected_Link_GC, Get_Window (B.Canvas));
         Color := Parse (Selected_Link_Color);
         Alloc (Get_Default_Colormap, Color);
         Set_Foreground (B.Selected_Link_GC, Color);

         Gdk_New (B.Selected_Item_GC, Get_Window (B.Canvas));
         Color := Parse (Selected_Item_Color);
         Alloc (Get_Default_Colormap, Color);
         Set_Foreground (B.Selected_Item_GC, Color);

         Gdk_New (B.Linked_Item_GC, Get_Window (B.Canvas));
         Color := Parse (Linked_Item_Color);
         Alloc (Get_Default_Colormap, Color);
         Set_Foreground (B.Linked_Item_GC, Color);

         Gdk_New (B.Text_GC, Get_Window (B.Canvas));
         Set_Foreground (B.Text_GC, Get_Pref (B.Kernel, Browsers_Link_Color));

         Desc := Get_Pref (B.Kernel, Browsers_Link_Font);
         B.Text_Font := From_Description (Desc);
         Free (Desc);
      end if;
   end Realized;

   --------------
   -- Get_Mask --
   --------------

   function Get_Mask (Browser : access Glide_Browser_Record)
      return Browser_Type_Mask is
   begin
      return Browser.Mask;
   end Get_Mask;

   ----------------
   -- Get_Canvas --
   ----------------

   function Get_Canvas (Browser : access Glide_Browser_Record)
      return Interactive_Canvas is
   begin
      return Browser.Canvas;
   end Get_Canvas;

   -----------------------------
   -- Browser_Context_Factory --
   -----------------------------

   function Browser_Context_Factory
     (Kernel       : access Kernel_Handle_Record'Class;
      Event_Widget : access Gtk.Widget.Gtk_Widget_Record'Class;
      Object       : access Glib.Object.GObject_Record'Class;
      Event        : Gdk.Event.Gdk_Event;
      Menu         : Gtk.Menu.Gtk_Menu)
      return Glide_Kernel.Selection_Context_Access
   is
      B          : Glide_Browser := Glide_Browser (Object);
      Context    : Selection_Context_Access;
      Mitem      : Gtk_Menu_Item;
      Check      : Gtk_Check_Menu_Item;
      Zooms_Menu : Gtk_Menu;
      Item       : Canvas_Item;
      Src        : Src_Info.Internal_File;
      Xr, Yr     : Gint;
      Success    : Boolean;

   begin
      --  Click on an item: this is a file selection

      Get_Origin (Get_Window (B.Canvas), Xr, Yr, Success);
      Set_X (Event, Get_X_Root (Event) - Gdouble (Xr));
      Set_Y (Event, Get_Y_Root (Event) - Gdouble (Yr));

      Item := Item_At_Coordinates (B.Canvas, Event);

      --  ??? Should test whether this is a file-related item
      if Item /= null
        and then Item.all in File_Item_Record'Class
      then
         Context := new File_Selection_Context;
         Src := Get_Source (File_Item (Item));

         Set_File_Information
           (File_Selection_Context_Access (Context),
            File_Name => Get_Source_Filename (Src));

      elsif Item /= null
        and then Item.all in Browser_Project_Vertex'Class
      then
         Context := new File_Selection_Context;

         Set_File_Information
           (File_Selection_Context_Access (Context),
            Project_View => Get_Project_View_From_Name
              (Project_Name (Browser_Project_Vertex_Access (Item))));

      --  Else, a general browser selection
      else
         Unlock (Get_Default_Accelerators (Kernel));

         Context := new Selection_Context;

         --  ??? Should be set only for browsers related to files
         Gtk_New (Mitem, Label => "Open file...");
         Append (Menu, Mitem);
         Context_Callback.Object_Connect
           (Mitem, "activate",
            Context_Callback.To_Marshaller (Open_File'Access),
            Slot_Object => B,
            User_Data   => Selection_Context_Access (Context));

         Gtk_New (Check, Label => "Hide system files");
         Set_Active (Check, True);
         Set_Sensitive (Check, False);
         Append (Menu, Check);

         Gtk_New (Check, Label => "Hide implicit dependencies");
         Set_Active (Check, True);
         Set_Sensitive (Check, False);
         Append (Menu, Check);

         Gtk_New (Mitem, Label => "Zoom in");
         Append (Menu, Mitem);
         Widget_Callback.Object_Connect
           (Mitem, "activate",
            Widget_Callback.To_Marshaller (Zoom_In'Access), B);
         Add_Accelerator
           (Mitem, "activate",
            Get_Default_Accelerators (Kernel), GDK_equal, 0, Accel_Visible);

         Gtk_New (Mitem, Label => "Zoom out");
         Append (Menu, Mitem);
         Widget_Callback.Object_Connect
           (Mitem, "activate",
            Widget_Callback.To_Marshaller (Zoom_Out'Access), B);
         Add_Accelerator
           (Mitem, "activate",
            Get_Default_Accelerators (Kernel), GDK_minus, 0, Accel_Visible);

         Gtk_New (Zooms_Menu);

         for J in Zoom_Levels'Range loop
            Gtk_New (Mitem, Label => Guint'Image (Zoom_Levels (J)) & '%');
            Append (Zooms_Menu, Mitem);
            Contextual_Cb.Connect
              (Mitem, "activate",
               Contextual_Cb.To_Marshaller (Zoom_Level'Access),
               (Browser => B,
                Zoom    => Zoom_Levels (J)));
         end loop;

         Gtk_New (Mitem, Label => "Zoom");
         Append (Menu, Mitem);
         Set_Submenu (Mitem, Zooms_Menu);

         Lock (Get_Default_Accelerators (Kernel));
      end if;

      return Context;
   end Browser_Context_Factory;

   -------------
   -- Zoom_In --
   -------------

   procedure Zoom_In (Browser : access Gtk_Widget_Record'Class) is
      Canvas : Interactive_Canvas := Glide_Browser (Browser).Canvas;
      Z : constant Guint := Get_Zoom (Canvas);
   begin
      for J in Zoom_Levels'Range loop
         if Zoom_Levels (J) = Z then
            if J /= Zoom_Levels'Last then
               Zoom (Canvas, Zoom_Levels (J + 1), Zoom_Steps);
            end if;
         end if;
      end loop;
   end Zoom_In;

   --------------
   -- Zoom_Out --
   --------------

   procedure Zoom_Out (Browser : access Gtk_Widget_Record'Class) is
      Canvas : Interactive_Canvas := Glide_Browser (Browser).Canvas;
      Z : constant Guint := Get_Zoom (Canvas);
   begin
      for J in Zoom_Levels'Range loop
         if Zoom_Levels (J) = Z then
            if J /= Zoom_Levels'First then
               Zoom (Canvas, Zoom_Levels (J - 1), Zoom_Steps);
            end if;
         end if;
      end loop;
   end Zoom_Out;

   ----------------
   -- Zoom_Level --
   ----------------

   procedure Zoom_Level
     (Browser : access Gtk_Widget_Record'Class; Data : Cb_Data) is
   begin
      Zoom (Data.Browser.Canvas, Data.Zoom, 1);
   end Zoom_Level;

   ---------------
   -- To_Brower --
   ---------------

   function To_Brower
     (Canvas : access Gtkada.Canvas.Interactive_Canvas_Record'Class)
      return Glide_Browser is
   begin
      return Glide_Browser (Get_Parent (Canvas));
   end To_Brower;

   -------------------
   -- Selected_Item --
   -------------------

   function Selected_Item (Browser : access Glide_Browser_Record)
      return Gtkada.Canvas.Canvas_Item is
   begin
      return Browser.Selected_Item;
   end Selected_Item;

   --------------------------
   -- Draw_Item_Background --
   --------------------------

   procedure Draw_Item_Background
     (Browser : access Glide_Browser_Record;
      Item    : access Gtkada.Canvas.Buffered_Item_Record'Class)
   is
      Bg_GC : Gdk_GC;
      Coord : Gdk_Rectangle := Get_Coord (Item);
   begin
      if Canvas_Item (Item) = Selected_Item (Browser) then
         Bg_GC := Get_Selected_Item_GC (Browser);

      elsif Selected_Item (Browser) /= null
        and then (Has_Link (Browser.Canvas,
                            From => Item, To => Selected_Item (Browser))
                  or else
                  Has_Link (Browser.Canvas,
                            From => Selected_Item (Browser), To => Item))
      then
         Bg_GC := Get_Linked_Item_GC (Browser);

      else
         Bg_GC := Get_White_GC (Get_Style (Browser.Canvas));
      end if;

      Set_Screen_Size_And_Pixmap
        (Item, Get_Window (Browser), Gint (Coord.Width), Gint (Coord.Height));

      Draw_Rectangle
        (Pixmap (Item),
         GC     => Bg_GC,
         Filled => True,
         X      => 0,
         Y      => 0,
         Width  => Coord.Width,
         Height => Coord.Height);

      Draw_Shadow
        (Style       => Get_Style (Browser.Canvas),
         Window      => Pixmap (Item),
         State_Type  => State_Normal,
         Shadow_Type => Shadow_Out,
         X           => 0,
         Y           => 0,
         Width       => Coord.Width,
         Height      => Coord.Height);
   end Draw_Item_Background;

   -----------------
   -- Select_Item --
   -----------------

   procedure Select_Item
     (Browser : access Glide_Browser_Record;
      Item    : access Gtkada.Canvas.Canvas_Item_Record'Class;
      Refresh : Refresh_Item_Func := null)
   is
      function Refresh_Item
        (Canvas : access Interactive_Canvas_Record'Class;
         Item   : access Canvas_Item_Record'Class) return Boolean;
      --  Refresh the display of an item.

      ------------------
      -- Refresh_Item --
      ------------------

      function Refresh_Item
        (Canvas : access Interactive_Canvas_Record'Class;
         Item   : access Canvas_Item_Record'Class) return Boolean is
      begin
         Refresh (Browser, Buffered_Item (Item));
         return True;
      end Refresh_Item;

   begin
      Browser.Selected_Item := Canvas_Item (Item);

      if Refresh /= null then
         --  ??? We should redraw only the items that were previously
         --  ??? highlighted, and the new ones.
         For_Each_Item (Browser.Canvas, Refresh_Item'Unrestricted_Access);
         Refresh_Canvas (Browser.Canvas);
      end if;
   end Select_Item;

   --------------------------
   -- Get_Selected_Link_GC --
   --------------------------

   function Get_Selected_Link_GC (Browser : access Glide_Browser_Record)
      return Gdk.GC.Gdk_GC is
   begin
      return Browser.Selected_Link_GC;
   end Get_Selected_Link_GC;

   --------------------------
   -- Get_Selected_Item_GC --
   --------------------------

   function Get_Selected_Item_GC (Browser : access Glide_Browser_Record)
      return Gdk.GC.Gdk_GC is
   begin
      return Browser.Selected_Item_GC;
   end Get_Selected_Item_GC;

   ------------------------
   -- Get_Linked_Item_GC --
   ------------------------

   function Get_Linked_Item_GC
     (Browser : access Glide_Browser_Record) return Gdk.GC.Gdk_GC is
   begin
      return Browser.Linked_Item_GC;
   end Get_Linked_Item_GC;

   -----------------
   -- Get_Text_GC --
   -----------------

   function Get_Text_GC
     (Browser : access Glide_Browser_Record) return Gdk.GC.Gdk_GC is
   begin
      return Browser.Text_GC;
   end Get_Text_GC;

   -------------------
   -- Get_Text_Font --
   -------------------

   function Get_Text_Font
     (Browser : access Glide_Browser_Record) return Gdk.Font.Gdk_Font is
   begin
      return Browser.Text_Font;
   end Get_Text_Font;

   ---------------
   -- Draw_Link --
   ---------------

   procedure Draw_Link
     (Canvas      : access Interactive_Canvas_Record'Class;
      Link        : access Glide_Browser_Link_Record;
      Window      : Gdk.Window.Gdk_Window;
      Invert_Mode : Boolean;
      GC          : Gdk.GC.Gdk_GC;
      Edge_Number : Glib.Gint)
   is
      Browser : Glide_Browser := To_Brower (Canvas);
   begin
      if Invert_Mode
        or else
        (Get_Src (Link) /= Vertex_Access (Selected_Item (Browser))
         and then Get_Dest (Link) /= Vertex_Access (Selected_Item (Browser)))
      then
         Draw_Link
           (Canvas, Canvas_Link_Access (Link), Window,
            Invert_Mode, GC, Edge_Number);
      else
         Draw_Link
           (Canvas, Canvas_Link_Access (Link),
            Window, Invert_Mode, Get_Selected_Link_GC (Browser), Edge_Number);
      end if;
   end Draw_Link;

end Browsers.Canvas;
