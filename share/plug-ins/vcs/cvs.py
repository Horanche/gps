"""
Provides support for the CVS configuration management system.

This file integrates into GPS's VCS support, and uses the same
menus as all other VCS systems supported by GPS.
You can easily edit this file to configurat the CVS commands that
are executed by each of the menus
"""


import GPS
from vcs import *

actions = [
    SEPARATOR,

    {ACTION: "Status", LABEL: "Query _status"},
    {ACTION: "Update", LABEL: "_Update"},
    {ACTION: "Commit", LABEL: "_Commit"},
    {ACTION: "Commit (via revision log)", LABEL: "_Commit (via revision log)"},
    {ACTION: "Commit (from revision log)", LABEL: "Commit file"},

    SEPARATOR,

    {ACTION: "Open",   LABEL: "_Open"},
    {ACTION: "History (as text)",
        LABEL: "View _entire revision history (as text)"},
    {ACTION: "History",
     LABEL: "View _entire revision history"},
    {ACTION: "History for revision",
     LABEL: "View specific revision _history"},

    SEPARATOR,

    {ACTION: "Diff against head",
     LABEL: "Compare against head revision"},
    {ACTION: "Diff against revision",
     LABEL: "Compare against other revision"},
    {ACTION: "Diff between two revisions",
        LABEL: "Compare two revisions"},
    {ACTION: "Diff base against head",
     LABEL: "Compare base against head"},
    {ACTION: "Diff against tag",                LABEL: "Compare against tag"},
    {ACTION: "Diff against selected revision",
     LABEL: "Compare against selected revision"},

    SEPARATOR,

    {ACTION: "Annotate",                LABEL: "Add annotations"},
    {ACTION: "Remove Annotate",         LABEL: "Remove annotations"},
    {ACTION: "Edit revision log",       LABEL: "Edit revision log"},
    {ACTION: "Edit global ChangeLog",   LABEL: "Edit global ChangeLog"},
    {ACTION: "Remove revision log",     LABEL: "Remove revision log"},

    SEPARATOR,

    {ACTION: "Add",                       LABEL: "Add"},
    {ACTION: "Add (via revision log)",    LABEL: "Add (via revision log)"},
    {ACTION: "Add no commit",             LABEL: "Add, no commit"},
    {ACTION: "Remove",                    LABEL: "Remove"},
    {ACTION: "Remove (via revision log)", LABEL: "Remove (via revision log)"},
    {ACTION: "Remove no commit",          LABEL: "Remove, no commit"},
    {ACTION: "Revert",                    LABEL: "Revert"},

    SEPARATOR,

    {ACTION: "Create tag",    LABEL: "Create _tag..."},
    {ACTION: "Switch tag",    LABEL: "S_witch tag..."},
    {ACTION: "Merge",         LABEL: "Merge"},
    {ACTION: "View revision", LABEL: "View revision"},

    SEPARATOR,

    {ACTION: "Add directory, no commit",
     LABEL: "Directory/Add directory, no commit"},
    {ACTION: "Remove directory, no commit",
     LABEL: "Directory/Remove directory, no commit"},
    {ACTION: "Commit directory",
        LABEL: "Directory/Commit directory"},
    {ACTION: "Status dir",
     LABEL: "Directory/Query status for directory"},
    {ACTION: "Update dir",
        LABEL: "Directory/Update directory"},
    {ACTION: "Status dir (recursively)",     LABEL:
        "Directory/Query status for directory recursively"},
    {ACTION: "Update dir (recursively)",
        LABEL: "Directory/Update directory recursively"},

    {ACTION: "List project",
     LABEL: "Project/List all files in project"},
    {ACTION: "Status project",
     LABEL: "Project/Query status for project"},
    {ACTION: "Update project",               LABEL: "Project/Update project"},
    {ACTION: "List project (recursively)",   LABEL:
        "Project/List all files in project (recursively)"},
    {ACTION: "Status project (recursively)", LABEL:
        "Project/Query status for project (recursively)"},
    {ACTION: "Update project (recursively)",
        LABEL: "Project/Update project (recursively)"},
]

XML = r"""<?xml version="1.0"?>
<GPS>
   <!-- CVS status -->

   <action name="generic_cvs_status" show-command="false" output="none" category="">
      <shell>pwd</shell>
      <shell output="">echo "Querying status for files in %1"</shell>
      <external check-password="true">cvs status $2-</external>
      <on-failure>
         <shell output="">echo_error "CVS error:"</shell>
         <shell output="">echo_error "%2"</shell>
      </on-failure>
      <shell>VCS.status_parse "CVS" "%1" "$1" FALSE "%3"</shell>
   </action>

   <!-- CVS status dir -->

   <action name="generic_cvs_status_dir" show-command="false" output="none" category="">
      <shell>pwd</shell>
      <shell output="">echo "Querying status for %1"</shell>
      <external check-password="true">cvs status -l .</external>
      <on-failure>
         <shell output="">echo_error "CVS error:"</shell>
         <shell output="">echo_error "%2"</shell>
      </on-failure>
      <shell>VCS.status_parse "CVS" "%1" "$1" FALSE "%3"</shell>
   </action>

   <!-- CVS tag/branch -->

   <action name="generic_cvs_create_tag" show-command="false" output="" category="">
      <shell>echo "Create tag $2 on $1"</shell>
      <external check-password="true" output="none">cvs tag -c "$2"</external>
      <on-failure>
         <shell output="">echo_error "CVS error:"</shell>
         <shell output="">echo_error "%2"</shell>
      </on-failure>
   </action>

   <action name="generic_cvs_create_branch" show-command="false" output="" category="">
      <shell>echo "Create branch $2 on $1"</shell>
      <external check-password="true" output="none">cvs tag -c -b "$2"</external>
      <on-failure>
         <shell output="">echo_error "CVS error:"</shell>
         <shell output="">echo_error "%2"</shell>
      </on-failure>
   </action>

   <!-- CVS switch -->

   <action name="generic_cvs_switch" show-command="false" output="" category="">
      <shell>echo "Switch to $2"</shell>
      <external check-password="true" output="none">cvs update -r $2</external>
      <on-failure>
         <shell output="">echo_error "CVS error:"</shell>
         <shell output="">echo_error "%2"</shell>
      </on-failure>
   </action>

   <!-- CVS annotate -->

   <action name="generic_cvs_annotate" show-command="false" output="" category="">
      <shell>echo "Querying annotations for $1"</shell>
      <external check-password="true" output="none">cvs annotate "$1"</external>
      <on-failure>
         <shell output="">echo_error "CVS error:"</shell>
         <shell output="">echo_error "%2"</shell>
      </on-failure>
      <shell output="none">VCS.annotations_parse "CVS" "$1" "%1"</shell>
   </action>

   <!-- CVS local status -->

   <action name="generic_cvs_local_status" show-command="false" output="none" category="">
      <shell>pwd</shell>
      <shell>Editor.get_buffer "./CVS/Entries"</shell>
      <shell>VCS.status_parse "CVS" "%1" FALSE TRUE "%2"</shell>
   </action>

   <!-- CVS commit -->

   <action name="generic_cvs_commit" show-command="false" output="none" category="">
      <shell output="">echo "Committing file(s) $2-"</shell>
      <shell>dump "$1" TRUE</shell>
      <external check-password="true">cvs commit -F "%1" $2-</external>
      <on-failure>
         <shell output="">echo_error "CVS error:"</shell>
         <shell output="">echo_error "%2"</shell>
      </on-failure>
      <shell>delete "%2"</shell>
      <shell>Hook "file_changed_on_disk"</shell>
      <shell>Hook.run %1 null</shell>
   </action>

   <!-- CVS add -->

   <action name="generic_cvs_add" show-command="false" output="none" category="">
      <shell output="">echo "adding file(s) $2-"</shell>
      <external check-password="true">cvs add $2-</external>
      <on-failure>
         <shell output="">echo_error "CVS error:"</shell>
         <shell output="">echo_error "%2"</shell>
      </on-failure>
      <shell>dump "$1" TRUE</shell>
      <external check-password="true">cvs commit -F "%1" $2-</external>
      <on-failure>
         <shell output="">echo_error "CVS error:"</shell>
         <shell output="">echo_error "%2"</shell>
      </on-failure>
      <shell>delete "%2"</shell>
   </action>

   <!-- CVS add (no commit) -->

   <action name="generic_cvs_add_no_commit" show-command="false" output="none" category="">
      <shell output="">echo "adding (no commit) file(s) $2-"</shell>
      <external check-password="true">cvs add $2-</external>
      <on-failure>
         <shell output="">echo_error "CVS error:"</shell>
         <shell output="">echo_error "%2"</shell>
      </on-failure>
   </action>

   <!-- CVS remove -->

   <action name="generic_cvs_remove" show-command="false" output="none" category="">
      <shell output="">echo "removing file(s) $2-"</shell>
      <shell>delete $2-</shell>
      <external check-password="true">cvs remove $2-</external>
      <on-failure>
         <shell output="">echo_error "CVS error:"</shell>
         <shell output="">echo_error "%2"</shell>
      </on-failure>
      <shell>dump "$1" TRUE</shell>
      <external check-password="true">cvs commit -F "%1" $2-</external>
      <on-failure>
         <shell output="">echo_error "CVS error:"</shell>
         <shell output="">echo_error "%2"</shell>
      </on-failure>
      <shell>delete "%2"</shell>
   </action>

   <!-- CVS remove (no commit) -->

   <action name="generic_cvs_remove_no_commit" show-command="false" output="none" category="">
      <shell output="">echo "removing file(s) $2-"</shell>
      <shell>delete $2-</shell>
      <external check-password="true">cvs remove $2-</external>
      <on-failure>
         <shell output="">echo_error "CVS error:"</shell>
         <shell output="">echo_error "%2"</shell>
      </on-failure>
   </action>

   <!-- CVS history -->

   <action name="generic_cvs_history" show-command="false" output="none" category="">
      <shell output="">echo "Querying history for $1"</shell>
      <external check-password="true">cvs status -v "$1"</external>
      <on-failure>
         <shell output="">echo_error "CVS error:"</shell>
         <shell output="">echo_error "%2"</shell>
      </on-failure>
      <shell>VCS.revision_parse "CVS" "$1" "%1"</shell>
      <external check-password="true">cvs log -N "$1"</external>
      <on-failure>
         <shell output="">echo_error "CVS error:"</shell>
         <shell output="">echo_error "%2"</shell>
      </on-failure>
      <shell>VCS.log_parse "CVS" "$1" "%1"</shell>
   </action>

   <action name="generic_cvs_history_text" show-command="false" output="none" category="">
     <shell output="">echo "Querying history for $1"</shell>
     <external check-password="true">cvs log -N "$1"</external>
     <on-failure>
       <shell output="">echo_error "CVS error:"</shell>
       <shell output="">echo_error "%2"</shell>
     </on-failure>
     <shell>base_name "$1"</shell>
     <shell>dump "%2" TRUE</shell>
     <shell>Editor.edit "%1"</shell>
     <shell>Editor.set_title "%2" "Log for %3" "Log for %3"</shell>
     <shell>Editor.set_writable "%3" FALSE</shell>
     <shell>MDI.split_vertically TRUE</shell>
     <shell>delete "%5"</shell>
   </action>

   <action name="generic_cvs_history_rev" show-command="false" output="none" category="">
      <shell output="">echo "Querying history for $2"</shell>
      <external check-password="true">cvs status -v "$2"</external>
      <on-failure>
         <shell output="">echo_error "CVS error:"</shell>
         <shell output="">echo_error "%2"</shell>
      </on-failure>
      <shell>VCS.revision_parse "CVS" "$2" "%1"</shell>
      <external check-password="true">cvs log -N -r$1 "$2"</external>
      <on-failure>
         <shell output="">echo_error "CVS error:"</shell>
         <shell output="">echo_error "%2"</shell>
      </on-failure>
      <shell>VCS.log_parse "CVS" "$2" "%1"</shell>
   </action>

   <!-- CVS update -->

   <action name="generic_cvs_update" show-command="false" output="none" category="">
      <shell>pwd</shell>
      <external check-password="true">cvs update $*</external>
      <on-failure>
	 <shell>Hook "file_changed_on_disk"</shell>
	 <shell>Hook.run %1 null</shell>
	 <shell>VCS.update_parse "CVS" "%3" "%4"</shell>
      </on-failure>
      <shell>Hook "file_changed_on_disk"</shell>
      <shell>Hook.run %1 null</shell>
      <shell>VCS.update_parse "CVS" "%3" "%4"</shell>
   </action>

   <!-- CVS merge -->

   <action name="generic_cvs_merge" show-command="false" output="none" category="">
      <external check-password="true" output="">cvs update -j "$1" "$2"</external>
      <on-failure>
         <shell output="">echo_error "CVS error:"</shell>
         <shell output="">echo_error "%2"</shell>
      </on-failure>
      <shell>Hook "file_changed_on_disk"</shell>
      <shell>Hook.run %1 null</shell>
   </action>

   <!-- CVS diff -->

   <action name="generic_cvs_diff_patch" show-command="false" output="none" category="">
      <shell output="">echo "Getting comparison for $2 ..."</shell>
      <external check-password="true">cvs -f diff -N -c -rHEAD "$2"</external>

      <on-failure>
        <shell>dump_file "%1" "$1" FALSE</shell>
      </on-failure>
   </action>

   <action name="generic_cvs_diff_head" show-command="false" output="none" category="">
      <shell output="">echo "Getting comparison for $1 ..."</shell>
      <external check-password="true">cvs -f diff -rHEAD "$1"</external>

      <on-failure>
	    <shell>base_name "$1"</shell>
        <shell>dump "%2" TRUE</shell>
        <shell>File "%1"</shell>
        <shell>File "$1" TRUE</shell>
        <shell>File.name %1</shell>
        <shell>Hook "diff_action_hook"</shell>
        <shell>Hook.run %1 "%2" null %3 %4 "%6 [HEAD]"</shell>
        <shell>delete "%6"</shell>
      </on-failure>
      <shell output="">echo "No differences found."</shell>
   </action>

   <action name="generic_cvs_diff" show-command="false" output="none" category="">
      <shell output="">echo "Getting comparison for revision $1 of $2 ..."</shell>
      <external check-password="true">cvs -f diff -r $1 "$2"</external>

      <on-failure>
	<shell>base_name "$2"</shell>
        <shell>dump "%2" TRUE</shell>
        <shell>File "%1"</shell>
        <shell>File "$2" TRUE</shell>
        <shell>Hook "diff_action_hook"</shell>
        <shell>Hook.run %1 "$2" null %2 %3 "%5 [$1]"</shell>
        <shell>delete "%5"</shell>
      </on-failure>
      <shell output="">echo "No differences found."</shell>
   </action>

   <action name="generic_cvs_diff_tag" show-command="false" output="none" category="">
      <shell output="">echo "Getting comparison for revision $1 of $2 ..."</shell>
      <external check-password="true">cvs -f diff -r $1 "$2"</external>

      <on-failure>
	<shell>base_name "$2"</shell>
        <shell>dump "%2" TRUE</shell>
        <shell>File "%1"</shell>
        <shell>File "$2" TRUE</shell>
        <shell>Hook "diff_action_hook"</shell>
        <shell>Hook.run %1 "$2" null %2 %3 "%5 [$1]"</shell>
        <shell>delete "%5"</shell>
      </on-failure>
      <shell output="">echo "No differences found."</shell>
   </action>

   <action name="generic_cvs_diff2" show-command="false" output="none" category="">
      <shell output="">echo "Getting comparison between revisions $1 / $2 of $3 ..."</shell>
      <external check-password="true">cvs -q update -p -r$2 "$3"</external>
      <on-failure>
         <shell output="">echo_error "CVS error:"</shell>
         <shell output="">echo_error "%2"</shell>
      </on-failure>
      <shell>base_name "$3"</shell>
      <shell>dump_file "%2" "%1.[$2]" FALSE</shell>
      <shell>File "%1"</shell>
      <shell>Editor.edit "%2"</shell>
      <shell>Editor.set_title %3 "%4 [$2]" "%4 [$2]"</shell>
      <shell>Editor.set_writable %4 FALSE</shell>
      <shell>VCS.set_reference %5 "$3"</shell>

      <external check-password="true">cvs -f diff -r$1 -r$2 "$3"</external>

      <on-failure>
        <shell>dump "%1" TRUE</shell>
        <shell>File "%1"</shell>
        <shell>Hook "diff_action_hook"</shell>
        <shell>Hook.run %1 "$3" null %9 %2 "%11 [$1]"</shell>
        <shell>delete "%4"</shell>
        <shell>delete "%12"</shell>
      </on-failure>
      <shell output="">echo "No differences found."</shell>
   </action>

   <action name="generic_cvs_diff_base_head" show-command="false" output="none" category="">
      <shell output="">echo "Getting comparison between base and head of $1 ..."</shell>
      <external check-password="true">cvs -q update -p -rHEAD "$1"</external>
      <on-failure>
         <shell output="">echo_error "CVS error:"</shell>
         <shell output="">echo_error "%2"</shell>
      </on-failure>
      <shell>dump "%1" TRUE</shell>
      <shell>File "%1"</shell>

      <external check-password="true">cvs -f diff -rBASE -rHEAD "$1"</external>

      <on-failure>
	<shell>base_name "$1"</shell>
        <shell>dump "%2" TRUE</shell>
        <shell>File "%1"</shell>
        <shell>Hook "diff_action_hook"</shell>
        <shell>Hook.run %1 "$1" null %6 %2 "%4 [BASE]"</shell>
        <shell>delete "%4"</shell>
        <shell>delete "%9"</shell>
      </on-failure>
      <shell output="">echo "No differences found between BASE and HEAD for $1"</shell>
   </action>

   <!-- CVS open -->

   <action name="generic_cvs_open" show-command="false" output="none" category="">
      <shell output="">echo "Opening CVS file $*"</shell>
      <external check-password="true">cvs edit $*</external>
      <on-failure>
         <shell output="">echo_error "CVS error:"</shell>
         <shell output="">echo_error "%2"</shell>
      </on-failure>
      <shell>Hook "file_changed_on_disk"</shell>
      <shell>Hook.run %1 null</shell>
      <shell>Editor.edit "$1" 0 0</shell>
   </action>

   <!-- CVS revert -->

   <action name="generic_cvs_revert" show-command="false" output="none" category="">
      <external check-password="true" output="">cvs update -C $*</external>
      <on-failure>
         <shell output="">echo_error "CVS error:"</shell>
         <shell output="">echo_error "%2"</shell>
      </on-failure>
      <shell>Hook "file_changed_on_disk"</shell>
      <shell>Hook.run %1 null</shell>
   </action>

   <!-- CVS revision -->

   <action name="generic_cvs_revision" show-command="false" output="none" category="">
      <shell output="">echo "Getting $2 at revision $1"</shell>
      <external check-password="true" output="none">cvs -q update -p -r "$1" "$2"</external>
      <on-failure>
         <shell output="">echo_error "CVS error:"</shell>
         <shell output="">echo_error "%2"</shell>
      </on-failure>
      <shell>base_name "$2"</shell>
      <shell>dump "%2"</shell>
      <shell>Editor.edit "%1"</shell>
      <shell>Editor.set_title "%2" "%3 [$1]" "%3 [$1]"</shell>
      <shell>Editor.set_writable "%3" FALSE</shell>
      <shell>delete "%4"</shell>
   </action>

   <!-- CVS -->

   <vcs name="CVS" dir_sep="UNIX"
        absolute_names="FALSE" ignore_file=".cvsignore"
	administrative_directory="CVS">
      <status_files       action="generic_cvs_status"           label="Query status"/>
      <status_dir         action="generic_cvs_status_dir"       label="Query status for directory"/>
      <local_status_files action="generic_cvs_local_status"     label="Local status"/>
      <create_tag         action="generic_cvs_create_tag"       label="Create tag"/>
      <create_branch      action="generic_cvs_create_branch"    label="Create branch"/>
      <switch             action="generic_cvs_switch"           label="Switch tag/branch"/>
      <open               action="generic_cvs_open"             label="Open"/>
      <update             action="generic_cvs_update"           label="Update"/>
      <merge              action="generic_cvs_merge"            label="Merge"/>
      <commit             action="generic_cvs_commit"           label="Commit"/>
      <history            action="generic_cvs_history"          label="View entire revision history"/>
      <history_text       action="generic_cvs_history_text"     label="View entire revision history (as text)"/>
      <history_revision   action="generic_cvs_history_rev"      label="View specific revision history"/>
      <annotate           action="generic_cvs_annotate"         label="Annotations"/>
      <add                action="generic_cvs_add"              label="Add"/>
      <add_no_commit      action="generic_cvs_add_no_commit"    label="Add/No commit"/>
      <remove             action="generic_cvs_remove"           label="Remove"/>
      <remove_no_commit   action="generic_cvs_remove_no_commit" label="Remove/No commit"/>
      <revert             action="generic_cvs_revert"           label="Revert"/>
      <revision           action="generic_cvs_revision"         label="View revision"/>
      <diff_patch         action="generic_cvs_diff_patch"       label="Compare against head revision for building a patch file"/>
      <diff_head          action="generic_cvs_diff_head"        label="Compare against head revision"/>
      <diff_base_head     action="generic_cvs_diff_base_head"   label="Compare base against head"/>
      <diff               action="generic_cvs_diff"             label="Compare against other revision"/>
      <diff_tag           action="generic_cvs_diff_tag"         label="Compare against a tag/branch"/>
      <diff2              action="generic_cvs_diff2"            label="Compare two revisions"/>

      <status label="Up to date" stock="vcs-up-to-date" />
      <status label="Locally modified" stock="vcs-modified" />
      <status label="Needs merge" stock="vcs-needs-merge" />
      <status label="Needs update" stock="vcs-needs-update" />
      <status label="Contains merge conflicts" stock="vcs-has-conflicts" />
      <status label="Removed" stock="vcs-removed" />
      <status label="Added" stock="vcs-added" />

      <parent_revision regexp="(\d+(\.\d+)+)\.\d+\.\d+"/>
      <branch_root_revision regexp="(\d+(\.\d+)+)\.\d+"/>

      <status_parser>
         <regexp>File: (no file )?([^\s]*)\s*Status: (.*?)\n\n *Working revision:\s*([^\s]*).*\n *Repository revision:\s*([^\s]*).*</regexp>

         <file_index>2</file_index>
         <status_index>3</status_index>
         <local_revision_index>4</local_revision_index>
         <repository_revision_index>5</repository_revision_index>

         <status_matcher label="Up to date">Up-to-date</status_matcher>
         <status_matcher label="Locally modified">Locally Modified</status_matcher>
         <status_matcher label="Needs update">Needs Patch</status_matcher>
         <status_matcher label="Needs merge">Needs Merge</status_matcher>
         <status_matcher label="Added">Locally Added</status_matcher>
         <status_matcher label="Removed">Locally Removed</status_matcher>
         <status_matcher label="Removed">Entry Invalid</status_matcher>
         <status_matcher label="Contains merge conflicts">File had conflicts on merge</status_matcher>
      </status_parser>

      <local_status_parser>
         <regexp>/(.+)/(.+?)/.*//(\n|$)</regexp>

         <file_index>1</file_index>
         <local_revision_index>2</local_revision_index>
      </local_status_parser>

      <annotations_parser>
         <regexp>(\d\.\d[^\s]*)[^\(]*\(([^\s]*)[\s]*([^\)]*)\)\:(.*)(\n|$)</regexp>

         <repository_revision_index>1</repository_revision_index>
	 <author_index>2</author_index>
	 <date_index>3</date_index>
         <file_index>4</file_index>
	 <tooltip_pattern>Revision \1 on \3, Author \2</tooltip_pattern>
      </annotations_parser>

      <update_parser>
         <regexp>(^|\n)([UMC])\s+([^\n]+)</regexp>

         <file_index>3</file_index>
         <status_index>2</status_index>

         <status_matcher label="Up to date">U</status_matcher>
         <status_matcher label="Locally modified">M</status_matcher>
         <status_matcher label="Contains merge conflicts">C</status_matcher>
      </update_parser>

      <log_parser>
         <regexp>----------\nrevision ([^\n]+)\ndate: ([^;]+);  author: ([^;]+)[^\n]+(\nbranches: [^;]+;\n|\n)(([^-\n][^\n]+\n|.?.?[^-=][^-=][^-=][^-=][^-=][^\n]*\n)*)</regexp>

         <repository_revision_index>1</repository_revision_index>
	 <author_index>3</author_index>
	 <date_index>2</date_index>
	 <log_index>5</log_index>
      </log_parser>

      <revision_parser>
         <regexp>\t([^ ]+) *\t\((revision:|branch:) (\d+\.\d+)(\.\d+)?\)</regexp>
	 <sym_index>1</sym_index>
	 <repository_revision_index>3</repository_revision_index>
      </revision_parser>
   </vcs>
</GPS>
"""

GPS.parse_xml(XML)
register_vcs_actions("CVS", actions)
