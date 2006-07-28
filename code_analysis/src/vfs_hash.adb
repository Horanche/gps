-----------------------------------------------------------------------
--                               G P S                               --
--                                                                   --
--                        Copyright (C) 2006                         --
--                              AdaCore                              --
--                                                                   --
-- GPS is Free  software;  you can redistribute it and/or modify  it --
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

with Ada.Strings.Hash;
with Ada.Characters.Handling; use Ada.Characters.Handling;
with Filesystem;              use Filesystem;

package body VFS_Hash is

   function VFS_Hash (Key : VFS.Virtual_File) return Hash_Type is
   begin
      if Is_Case_Sensitive (Get_Filesystem (Key)) then
         return Ada.Strings.Hash (Full_Name (Key, True).all);
      else
         return Ada.Strings.Hash (To_Lower (Full_Name (Key, True).all));
      end if;
   end VFS_Hash;

end VFS_Hash;
