
-----------------------------------------------------------------------
--                          G L I D E  I I                           --
--                                                                   --
--                        Copyright (C) 2002                         --
--                            ACT-Europe                             --
--                                                                   --
-- GLIDE is free software; you can redistribute it and/or modify  it --
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

with Ada.Text_IO;

package body Basic_Mapper is

   use Double_String_Table.String_Hash_Table;

   --------------------
   -- Get_Other_File --
   --------------------

   function Get_Other_File
     (Mapper    : File_Mapper_Access;
      File_Name : String) return String
   is
      Element : String_Access;
      Key     : String_Access := new String' (File_Name);
   begin
      if Mapper = null then
         Free (Key);
         return "";
      end if;

      Element := Get (Mapper.Table_1, Key);

      if Element = No_Element then
         Free (Key);
         Key := new String' (File_Name);
         Element := Get (Mapper.Table_2, Key);
      end if;

      if Element = No_Element then
         Free (Key);
         return "";
      else
         return Element.all;
      end if;
   end Get_Other_File;

   ---------------
   -- Add_Entry --
   ---------------

   procedure Add_Entry
     (Mapper      : in out File_Mapper_Access;
      File_Name_1 : String;
      File_Name_2 : String)
   is
      Key_1 : String_Access := new String' (File_Name_1);
      Key_2 : String_Access := new String' (File_Name_2);
   begin
      if Mapper = null then
         Mapper := new File_Mapper;
      end if;

      Set (Mapper.Table_1, Key_1, Key_2);
      Set (Mapper.Table_2, Key_2, Key_1);
   end Add_Entry;

   -----------------
   -- Save_Mapper --
   -----------------

   procedure Save_Mapper
     (Mapper      : File_Mapper_Access;
      File_Name   : String)
   is
      File : Ada.Text_IO.File_Type;
      Element : String_Access;
   begin
      if Mapper = null then
         return;
      end if;

      if not Is_Regular_File (File_Name) then
         Ada.Text_IO.Create (File, Ada.Text_IO.Out_File, File_Name);
      else
         Ada.Text_IO.Open (File, Ada.Text_IO.Out_File, File_Name);
      end if;

      Get_First (Mapper.Table_1, Element);

      while Element /= No_Element loop
         Ada.Text_IO.Put_Line (File, Element.all);
         Ada.Text_IO.Put_Line (File, Get_Other_File (Mapper, Element.all));
         Get_Next (Mapper.Table_1, Element);
      end loop;

      Ada.Text_IO.Close (File);
   end Save_Mapper;

   -----------------
   -- Load_Mapper --
   -----------------

   procedure Load_Mapper
     (Mapper      : out File_Mapper_Access;
      File_Name   : String)
   is
      File     : Ada.Text_IO.File_Type;
      Buffer_1 : String (1 .. 8192);
      Buffer_2 : String (1 .. 8192);
      Last_1   : Integer := 1;
      Last_2   : Integer := 1;
   begin
      if Mapper = null then
         Mapper := new File_Mapper;
      end if;

      Ada.Text_IO.Open (File, Ada.Text_IO.In_File, File_Name);

      while Last_2 >= 0
        and then Last_1 >= 0
        and then not Ada.Text_IO.End_Of_File (File)
      loop
         Ada.Text_IO.Get_Line (File, Buffer_1, Last_1);
         Ada.Text_IO.Get_Line (File, Buffer_2, Last_2);
         Add_Entry (Mapper,
                    Buffer_1 (1 .. Last_1),
                    Buffer_2 (1 .. Last_2));
      end loop;

      Ada.Text_IO.Close (File);
   end Load_Mapper;

end Basic_Mapper;
