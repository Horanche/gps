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

with GNATCOLL.Projects;

package body GPS.CLI_Kernels is

   ---------------------
   -- Create_Database --
   ---------------------

   overriding procedure Create_Database
     (Self   : not null access CLI_Kernel;
      Result : out Xref.General_Xref_Database) is
   begin
      Result := new Xref.General_Xref_Database_Record;

      Xref.Initialize
        (Result, Self.Lang_Handler, Self.Symbols, Self.Registry);
   end Create_Database;

   ---------------------
   -- Create_Registry --
   ---------------------

   overriding procedure Create_Registry
     (Self   : not null access CLI_Kernel;
      Result : out Projects.Project_Registry_Access)
   is
      pragma Unreferenced (Self);
      Tree : constant GNATCOLL.Projects.Project_Tree_Access :=
        new GNATCOLL.Projects.Project_Tree;
   begin
      Result := Projects.Create (Tree => Tree);
      Tree.Load_Empty_Project;
   end Create_Registry;

   -------------------------------
   -- Create_Scripts_Repository --
   -------------------------------

   overriding procedure Create_Scripts_Repository
     (Self   : not null access CLI_Kernel;
      Result : out GNATCOLL.Scripts.Scripts_Repository)
   is
      pragma Unreferenced (Self);
   begin
      Result := new GNATCOLL.Scripts.Scripts_Repository_Record;
   end Create_Scripts_Repository;

end GPS.CLI_Kernels;