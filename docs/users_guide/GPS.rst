.. This file is automatically generated, do not edit

Scripting API reference for `GPS`
==========================================

.. automodule:: GPS

.. inheritance-diagram: GPS    # DISABLED, add "::" to enable


Functions
---------

.. autofunction:: add_location_command
.. autofunction:: base_name
.. autofunction:: cd
.. autofunction:: compute_xref
.. autofunction:: compute_xref_bg
.. autofunction:: contextual_context
.. autofunction:: current_context
.. autofunction:: delete
.. autofunction:: dir
.. autofunction:: dir_name
.. autofunction:: dump
.. autofunction:: dump_file
.. autofunction:: exec_in_console
.. autofunction:: execute_action
.. autofunction:: execute_asynchronous_action
.. autofunction:: exit
.. autofunction:: freeze_prefs
.. autofunction:: get_build_mode
.. autofunction:: get_build_output
.. autofunction:: get_home_dir
.. autofunction:: get_runtime
.. autofunction:: get_system_dir
.. autofunction:: get_target
.. autofunction:: get_tmp_dir
.. autofunction:: insmod
.. autofunction:: is_server_local
.. autofunction:: last_command
.. autofunction:: lookup_actions
.. autofunction:: lookup_actions_from_key
.. autofunction:: ls
.. autofunction:: lsmod
.. autofunction:: parse_xml
.. autofunction:: process_all_events
.. autofunction:: pwd
.. autofunction:: repeat_next
.. autofunction:: reset_xref_db
.. autofunction:: save_persistent_properties
.. autofunction:: send_button_event
.. autofunction:: send_crossing_event
.. autofunction:: send_key_event
.. autofunction:: set_build_mode
.. autofunction:: set_last_command
.. autofunction:: supported_languages
.. autofunction:: thaw_prefs
.. autofunction:: version
.. autofunction:: xref_db

Classes
-------


:class:`GPS.Action`
^^^^^^^^^^^^^^^^^^^

.. autoclass:: Action()



   .. automethod:: GPS.Action.__init__

   .. automethod:: GPS.Action.button

   .. automethod:: GPS.Action.can_execute

   .. automethod:: GPS.Action.contextual

   .. automethod:: GPS.Action.create

   .. automethod:: GPS.Action.destroy_ui

   .. automethod:: GPS.Action.disable

   .. automethod:: GPS.Action.execute_if_possible

   .. automethod:: GPS.Action.exists

   .. automethod:: GPS.Action.key

   .. automethod:: GPS.Action.menu

:class:`GPS.Activities`
^^^^^^^^^^^^^^^^^^^^^^^

.. autoclass:: Activities()



   .. automethod:: GPS.Activities.__init__

   .. automethod:: GPS.Activities.add_file

   .. automethod:: GPS.Activities.commit

   .. automethod:: GPS.Activities.files

   .. automethod:: GPS.Activities.from_file

   .. automethod:: GPS.Activities.get

   .. automethod:: GPS.Activities.group_commit

   .. automethod:: GPS.Activities.has_log

   .. automethod:: GPS.Activities.id

   .. automethod:: GPS.Activities.is_closed

   .. automethod:: GPS.Activities.list

   .. automethod:: GPS.Activities.log

   .. automethod:: GPS.Activities.log_file

   .. automethod:: GPS.Activities.name

   .. automethod:: GPS.Activities.remove_file

   .. automethod:: GPS.Activities.set_closed

   .. automethod:: GPS.Activities.toggle_group_commit

   .. automethod:: GPS.Activities.vcs

:class:`GPS.Alias`
^^^^^^^^^^^^^^^^^^

.. autoclass:: Alias()



   .. automethod:: GPS.Alias.get

:class:`GPS.Bookmark`
^^^^^^^^^^^^^^^^^^^^^

.. autoclass:: Bookmark()



   .. automethod:: GPS.Bookmark.__init__

   .. automethod:: GPS.Bookmark.create

   .. automethod:: GPS.Bookmark.delete

   .. automethod:: GPS.Bookmark.get

   .. automethod:: GPS.Bookmark.goto

   .. automethod:: GPS.Bookmark.list

   .. automethod:: GPS.Bookmark.name

   .. automethod:: GPS.Bookmark.rename

:class:`GPS.BuildTarget`
^^^^^^^^^^^^^^^^^^^^^^^^

.. autoclass:: BuildTarget()



   .. automethod:: GPS.BuildTarget.__init__

   .. automethod:: GPS.BuildTarget.clone

   .. automethod:: GPS.BuildTarget.execute

   .. automethod:: GPS.BuildTarget.get_command_line

   .. automethod:: GPS.BuildTarget.hide

   .. automethod:: GPS.BuildTarget.remove

   .. automethod:: GPS.BuildTarget.show

:class:`GPS.Button`
^^^^^^^^^^^^^^^^^^^

.. autoclass:: Button()

   .. inheritance-diagram:: GPS.Button

   .. automethod:: GPS.Button.__init__

   .. automethod:: GPS.Button.set_text

:class:`GPS.Clipboard`
^^^^^^^^^^^^^^^^^^^^^^

.. autoclass:: Clipboard()



   .. automethod:: GPS.Clipboard.contents

   .. automethod:: GPS.Clipboard.copy

   .. automethod:: GPS.Clipboard.current

   .. automethod:: GPS.Clipboard.merge

:class:`GPS.CodeAnalysis`
^^^^^^^^^^^^^^^^^^^^^^^^^

.. autoclass:: CodeAnalysis()



   .. automethod:: GPS.CodeAnalysis.__init__

   .. automethod:: GPS.CodeAnalysis.add_all_gcov_project_info

   .. automethod:: GPS.CodeAnalysis.add_gcov_file_info

   .. automethod:: GPS.CodeAnalysis.add_gcov_project_info

   .. automethod:: GPS.CodeAnalysis.clear

   .. automethod:: GPS.CodeAnalysis.dump_to_file

   .. automethod:: GPS.CodeAnalysis.get

   .. automethod:: GPS.CodeAnalysis.hide_coverage_information

   .. automethod:: GPS.CodeAnalysis.load_from_file

   .. automethod:: GPS.CodeAnalysis.show_analysis_report

   .. automethod:: GPS.CodeAnalysis.show_coverage_information

:class:`GPS.Codefix`
^^^^^^^^^^^^^^^^^^^^

.. autoclass:: Codefix()



   .. automethod:: GPS.Codefix.__init__

   .. automethod:: GPS.Codefix.error_at

   .. automethod:: GPS.Codefix.errors

   .. automethod:: GPS.Codefix.parse

   .. automethod:: GPS.Codefix.sessions

:class:`GPS.CodefixError`
^^^^^^^^^^^^^^^^^^^^^^^^^

.. autoclass:: CodefixError()



   .. automethod:: GPS.CodefixError.__init__

   .. automethod:: GPS.CodefixError.fix

   .. automethod:: GPS.CodefixError.location

   .. automethod:: GPS.CodefixError.message

   .. automethod:: GPS.CodefixError.possible_fixes

:class:`GPS.Command`
^^^^^^^^^^^^^^^^^^^^

.. autoclass:: Command()



   .. automethod:: GPS.Command.get

   .. automethod:: GPS.Command.get_result

   .. automethod:: GPS.Command.interrupt

   .. automethod:: GPS.Command.list

   .. automethod:: GPS.Command.name

   .. automethod:: GPS.Command.progress

:class:`GPS.CommandWindow`
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. autoclass:: CommandWindow()

   .. inheritance-diagram:: GPS.CommandWindow

   .. automethod:: GPS.CommandWindow.__init__

   .. automethod:: GPS.CommandWindow.read

   .. automethod:: GPS.CommandWindow.set_background

   .. automethod:: GPS.CommandWindow.set_prompt

   .. automethod:: GPS.CommandWindow.write

:class:`GPS.Completion`
^^^^^^^^^^^^^^^^^^^^^^^

.. autoclass:: Completion()



   .. automethod:: GPS.Completion.register

:class:`GPS.Console`
^^^^^^^^^^^^^^^^^^^^

.. autoclass:: Console()

   .. inheritance-diagram:: GPS.Console

   .. automethod:: GPS.Console.__init__

   .. automethod:: GPS.Console.accept_input

   .. automethod:: GPS.Console.add_input

   .. automethod:: GPS.Console.clear

   .. automethod:: GPS.Console.clear_input

   .. automethod:: GPS.Console.copy_clipboard

   .. automethod:: GPS.Console.create_link

   .. automethod:: GPS.Console.delete_links

   .. automethod:: GPS.Console.enable_input

   .. automethod:: GPS.Console.flush

   .. automethod:: GPS.Console.get_text

   .. automethod:: GPS.Console.insert_link

   .. automethod:: GPS.Console.isatty

   .. automethod:: GPS.Console.read

   .. automethod:: GPS.Console.readline

   .. automethod:: GPS.Console.select_all

   .. automethod:: GPS.Console.write

   .. automethod:: GPS.Console.write_with_links

:class:`GPS.Construct`
^^^^^^^^^^^^^^^^^^^^^^

.. autoclass:: Construct()




   .. autoattribute:: GPS.Construct.file



   .. autoattribute:: GPS.Construct.id



   .. autoattribute:: GPS.Construct.name



   .. autoattribute:: GPS.Construct.start


   .. automethod:: GPS.Construct.__init__

:class:`GPS.ConstructsList`
^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. autoclass:: ConstructsList()



   .. automethod:: GPS.ConstructsList.add_construct

:class:`GPS.Context`
^^^^^^^^^^^^^^^^^^^^

.. autoclass:: Context()




   .. autoattribute:: GPS.Context.module_name


   .. automethod:: GPS.Context.__init__

   .. automethod:: GPS.Context.directory

   .. automethod:: GPS.Context.end_line

   .. automethod:: GPS.Context.entity

   .. automethod:: GPS.Context.entity_name

   .. automethod:: GPS.Context.file

   .. automethod:: GPS.Context.files

   .. automethod:: GPS.Context.location

   .. automethod:: GPS.Context.message

   .. automethod:: GPS.Context.project

   .. automethod:: GPS.Context.set_file

   .. automethod:: GPS.Context.start_line

:class:`GPS.Contextual`
^^^^^^^^^^^^^^^^^^^^^^^

.. autoclass:: Contextual()




   .. autoattribute:: GPS.Contextual.name


   .. automethod:: GPS.Contextual.__init__

   .. automethod:: GPS.Contextual.create

   .. automethod:: GPS.Contextual.create_dynamic

   .. automethod:: GPS.Contextual.hide

   .. automethod:: GPS.Contextual.list

   .. automethod:: GPS.Contextual.set_sensitive

   .. automethod:: GPS.Contextual.show

:class:`GPS.Cursor`
^^^^^^^^^^^^^^^^^^^

.. autoclass:: Cursor()



   .. automethod:: GPS.Cursor.__init__

   .. automethod:: GPS.Cursor.location

   .. automethod:: GPS.Cursor.mark

   .. automethod:: GPS.Cursor.move

   .. automethod:: GPS.Cursor.sel_mark

   .. automethod:: GPS.Cursor.set_manual_sync

:class:`GPS.Debugger`
^^^^^^^^^^^^^^^^^^^^^

.. autoclass:: Debugger()




   .. autoattribute:: GPS.Debugger.breakpoints



   .. autoattribute:: GPS.Debugger.current_file



   .. autoattribute:: GPS.Debugger.current_line



   .. autoattribute:: GPS.Debugger.remote_protocol



   .. autoattribute:: GPS.Debugger.remote_target


   .. automethod:: GPS.Debugger.__init__

   .. automethod:: GPS.Debugger.break_at_location

   .. automethod:: GPS.Debugger.close

   .. automethod:: GPS.Debugger.command

   .. automethod:: GPS.Debugger.get

   .. automethod:: GPS.Debugger.get_console

   .. automethod:: GPS.Debugger.get_executable

   .. automethod:: GPS.Debugger.get_num

   .. automethod:: GPS.Debugger.is_break_command

   .. automethod:: GPS.Debugger.is_busy

   .. automethod:: GPS.Debugger.is_context_command

   .. automethod:: GPS.Debugger.is_exec_command

   .. automethod:: GPS.Debugger.list

   .. automethod:: GPS.Debugger.non_blocking_send

   .. automethod:: GPS.Debugger.send

   .. automethod:: GPS.Debugger.set_variable

   .. automethod:: GPS.Debugger.spawn

   .. automethod:: GPS.Debugger.unbreak_at_location

   .. automethod:: GPS.Debugger.value_of

:class:`GPS.DebuggerBreakpoint`
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. autoclass:: DebuggerBreakpoint()




   .. autoattribute:: GPS.DebuggerBreakpoint.enabled



   .. autoattribute:: GPS.DebuggerBreakpoint.file



   .. autoattribute:: GPS.DebuggerBreakpoint.line



   .. autoattribute:: GPS.DebuggerBreakpoint.num



   .. autoattribute:: GPS.DebuggerBreakpoint.type



   .. autoattribute:: GPS.DebuggerBreakpoint.watched


   .. automethod:: GPS.DebuggerBreakpoint.__init__

:class:`GPS.Editor`
^^^^^^^^^^^^^^^^^^^

.. autoclass:: Editor()



   .. automethod:: GPS.Editor.add_blank_lines

   .. automethod:: GPS.Editor.add_case_exception

   .. automethod:: GPS.Editor.block_fold

   .. automethod:: GPS.Editor.block_get_end

   .. automethod:: GPS.Editor.block_get_level

   .. automethod:: GPS.Editor.block_get_name

   .. automethod:: GPS.Editor.block_get_start

   .. automethod:: GPS.Editor.block_get_type

   .. automethod:: GPS.Editor.block_unfold

   .. automethod:: GPS.Editor.close

   .. automethod:: GPS.Editor.copy

   .. automethod:: GPS.Editor.create_mark

   .. automethod:: GPS.Editor.cursor_center

   .. automethod:: GPS.Editor.cursor_get_column

   .. automethod:: GPS.Editor.cursor_get_line

   .. automethod:: GPS.Editor.cursor_set_position

   .. automethod:: GPS.Editor.cut

   .. automethod:: GPS.Editor.edit

   .. automethod:: GPS.Editor.get_buffer

   .. automethod:: GPS.Editor.get_chars

   .. automethod:: GPS.Editor.get_last_line

   .. automethod:: GPS.Editor.goto_mark

   .. automethod:: GPS.Editor.highlight

   .. automethod:: GPS.Editor.highlight_range

   .. automethod:: GPS.Editor.indent

   .. automethod:: GPS.Editor.indent_buffer

   .. automethod:: GPS.Editor.insert_text

   .. automethod:: GPS.Editor.mark_current_location

   .. automethod:: GPS.Editor.paste

   .. automethod:: GPS.Editor.print_line_info

   .. automethod:: GPS.Editor.redo

   .. automethod:: GPS.Editor.refill

   .. automethod:: GPS.Editor.register_highlighting

   .. automethod:: GPS.Editor.remove_blank_lines

   .. automethod:: GPS.Editor.remove_case_exception

   .. automethod:: GPS.Editor.replace_text

   .. automethod:: GPS.Editor.save

   .. automethod:: GPS.Editor.save_buffer

   .. automethod:: GPS.Editor.select_all

   .. automethod:: GPS.Editor.select_text

   .. automethod:: GPS.Editor.set_background_color

   .. automethod:: GPS.Editor.set_synchronized_scrolling

   .. automethod:: GPS.Editor.set_title

   .. automethod:: GPS.Editor.set_writable

   .. automethod:: GPS.Editor.subprogram_name

   .. automethod:: GPS.Editor.undo

   .. automethod:: GPS.Editor.unhighlight

   .. automethod:: GPS.Editor.unhighlight_range

:class:`GPS.EditorBuffer`
^^^^^^^^^^^^^^^^^^^^^^^^^

.. autoclass:: EditorBuffer()




   .. autoattribute:: GPS.EditorBuffer.extend_existing_selection


   .. automethod:: GPS.EditorBuffer.__init__

   .. automethod:: GPS.EditorBuffer.add_cursor

   .. automethod:: GPS.EditorBuffer.add_special_line

   .. automethod:: GPS.EditorBuffer.apply_overlay

   .. automethod:: GPS.EditorBuffer.at

   .. automethod:: GPS.EditorBuffer.beginning_of_buffer

   .. automethod:: GPS.EditorBuffer.blocks_fold

   .. automethod:: GPS.EditorBuffer.blocks_unfold

   .. automethod:: GPS.EditorBuffer.characters_count

   .. automethod:: GPS.EditorBuffer.close

   .. automethod:: GPS.EditorBuffer.copy

   .. automethod:: GPS.EditorBuffer.create_overlay

   .. automethod:: GPS.EditorBuffer.current_view

   .. automethod:: GPS.EditorBuffer.cursors

   .. automethod:: GPS.EditorBuffer.cut

   .. automethod:: GPS.EditorBuffer.delete

   .. automethod:: GPS.EditorBuffer.end_of_buffer

   .. automethod:: GPS.EditorBuffer.entity_under_cursor

   .. automethod:: GPS.EditorBuffer.expand_alias

   .. automethod:: GPS.EditorBuffer.file

   .. automethod:: GPS.EditorBuffer.finish_undo_group

   .. automethod:: GPS.EditorBuffer.get

   .. automethod:: GPS.EditorBuffer.get_chars

   .. automethod:: GPS.EditorBuffer.get_cursors

   .. automethod:: GPS.EditorBuffer.get_lang

   .. automethod:: GPS.EditorBuffer.get_mark

   .. automethod:: GPS.EditorBuffer.get_new

   .. automethod:: GPS.EditorBuffer.has_slave_cursors

   .. automethod:: GPS.EditorBuffer.indent

   .. automethod:: GPS.EditorBuffer.insert

   .. automethod:: GPS.EditorBuffer.is_modified

   .. automethod:: GPS.EditorBuffer.is_read_only

   .. automethod:: GPS.EditorBuffer.lines_count

   .. automethod:: GPS.EditorBuffer.list

   .. automethod:: GPS.EditorBuffer.main_cursor

   .. automethod:: GPS.EditorBuffer.new_undo_group

   .. automethod:: GPS.EditorBuffer.paste

   .. automethod:: GPS.EditorBuffer.redo

   .. automethod:: GPS.EditorBuffer.refill

   .. automethod:: GPS.EditorBuffer.remove_all_slave_cursors

   .. automethod:: GPS.EditorBuffer.remove_overlay

   .. automethod:: GPS.EditorBuffer.remove_special_lines

   .. automethod:: GPS.EditorBuffer.save

   .. automethod:: GPS.EditorBuffer.select

   .. automethod:: GPS.EditorBuffer.selection_end

   .. automethod:: GPS.EditorBuffer.selection_start

   .. automethod:: GPS.EditorBuffer.set_cursors_auto_sync

   .. automethod:: GPS.EditorBuffer.set_lang

   .. automethod:: GPS.EditorBuffer.set_read_only

   .. automethod:: GPS.EditorBuffer.start_undo_group

   .. automethod:: GPS.EditorBuffer.undo

   .. automethod:: GPS.EditorBuffer.unselect

   .. automethod:: GPS.EditorBuffer.update_cursors_selection

   .. automethod:: GPS.EditorBuffer.views

:class:`GPS.EditorHighlighter`
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. autoclass:: EditorHighlighter()



   .. automethod:: GPS.EditorHighlighter.__init__

   .. automethod:: GPS.EditorHighlighter.remove

:class:`GPS.EditorLocation`
^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. autoclass:: EditorLocation()



   .. automethod:: GPS.EditorLocation.__init__

   .. automethod:: GPS.EditorLocation.backward_overlay

   .. automethod:: GPS.EditorLocation.beginning_of_line

   .. automethod:: GPS.EditorLocation.block_end

   .. automethod:: GPS.EditorLocation.block_end_line

   .. automethod:: GPS.EditorLocation.block_fold

   .. automethod:: GPS.EditorLocation.block_level

   .. automethod:: GPS.EditorLocation.block_name

   .. automethod:: GPS.EditorLocation.block_start

   .. automethod:: GPS.EditorLocation.block_start_line

   .. automethod:: GPS.EditorLocation.block_type

   .. automethod:: GPS.EditorLocation.block_unfold

   .. automethod:: GPS.EditorLocation.buffer

   .. automethod:: GPS.EditorLocation.column

   .. automethod:: GPS.EditorLocation.create_mark

   .. automethod:: GPS.EditorLocation.end_of_line

   .. automethod:: GPS.EditorLocation.ends_word

   .. automethod:: GPS.EditorLocation.entity

   .. automethod:: GPS.EditorLocation.forward_char

   .. automethod:: GPS.EditorLocation.forward_line

   .. automethod:: GPS.EditorLocation.forward_overlay

   .. automethod:: GPS.EditorLocation.forward_word

   .. automethod:: GPS.EditorLocation.get_char

   .. automethod:: GPS.EditorLocation.get_overlays

   .. automethod:: GPS.EditorLocation.get_word

   .. automethod:: GPS.EditorLocation.has_overlay

   .. automethod:: GPS.EditorLocation.inside_word

   .. automethod:: GPS.EditorLocation.line

   .. automethod:: GPS.EditorLocation.offset

   .. automethod:: GPS.EditorLocation.search

   .. automethod:: GPS.EditorLocation.starts_word

   .. automethod:: GPS.EditorLocation.subprogram_name

:class:`GPS.EditorMark`
^^^^^^^^^^^^^^^^^^^^^^^

.. autoclass:: EditorMark()




   .. autoattribute:: GPS.EditorMark.column



   .. autoattribute:: GPS.EditorMark.file



   .. autoattribute:: GPS.EditorMark.line


   .. automethod:: GPS.EditorMark.__init__

   .. automethod:: GPS.EditorMark.delete

   .. automethod:: GPS.EditorMark.is_present

   .. automethod:: GPS.EditorMark.location

   .. automethod:: GPS.EditorMark.move

:class:`GPS.EditorOverlay`
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. autoclass:: EditorOverlay()



   .. automethod:: GPS.EditorOverlay.__init__

   .. automethod:: GPS.EditorOverlay.get_property

   .. automethod:: GPS.EditorOverlay.name

   .. automethod:: GPS.EditorOverlay.set_property

:class:`GPS.EditorView`
^^^^^^^^^^^^^^^^^^^^^^^

.. autoclass:: EditorView()

   .. inheritance-diagram:: GPS.EditorView

   .. automethod:: GPS.EditorView.__init__

   .. automethod:: GPS.EditorView.buffer

   .. automethod:: GPS.EditorView.center

   .. automethod:: GPS.EditorView.cursor

   .. automethod:: GPS.EditorView.get_extend_selection

   .. automethod:: GPS.EditorView.goto

   .. automethod:: GPS.EditorView.is_read_only

   .. automethod:: GPS.EditorView.set_extend_selection

   .. automethod:: GPS.EditorView.set_read_only

   .. automethod:: GPS.EditorView.title

:class:`GPS.Entity`
^^^^^^^^^^^^^^^^^^^

.. autoclass:: Entity()



   .. automethod:: GPS.Entity.__init__

   .. automethod:: GPS.Entity.attributes

   .. automethod:: GPS.Entity.body

   .. automethod:: GPS.Entity.called_by

   .. automethod:: GPS.Entity.called_by_browser

   .. automethod:: GPS.Entity.calls

   .. automethod:: GPS.Entity.category

   .. automethod:: GPS.Entity.child_types

   .. automethod:: GPS.Entity.declaration

   .. automethod:: GPS.Entity.derived_types

   .. automethod:: GPS.Entity.discriminants

   .. automethod:: GPS.Entity.documentation

   .. automethod:: GPS.Entity.end_of_scope

   .. automethod:: GPS.Entity.fields

   .. automethod:: GPS.Entity.find_all_refs

   .. automethod:: GPS.Entity.full_name

   .. automethod:: GPS.Entity.get_called_entities

   .. automethod:: GPS.Entity.instance_of

   .. automethod:: GPS.Entity.is_access

   .. automethod:: GPS.Entity.is_array

   .. automethod:: GPS.Entity.is_container

   .. automethod:: GPS.Entity.is_generic

   .. automethod:: GPS.Entity.is_global

   .. automethod:: GPS.Entity.is_predefined

   .. automethod:: GPS.Entity.is_subprogram

   .. automethod:: GPS.Entity.is_type

   .. automethod:: GPS.Entity.literals

   .. automethod:: GPS.Entity.methods

   .. automethod:: GPS.Entity.name

   .. automethod:: GPS.Entity.name_parameters

   .. automethod:: GPS.Entity.overrides

   .. automethod:: GPS.Entity.parameters

   .. automethod:: GPS.Entity.parent_types

   .. automethod:: GPS.Entity.pointed_type

   .. automethod:: GPS.Entity.primitive_of

   .. automethod:: GPS.Entity.references

   .. automethod:: GPS.Entity.rename

   .. automethod:: GPS.Entity.return_type

   .. automethod:: GPS.Entity.show

   .. automethod:: GPS.Entity.type

:class:`GPS.Exception`
^^^^^^^^^^^^^^^^^^^^^^

.. autoclass:: Exception()

   .. inheritance-diagram:: GPS.Exception

:class:`GPS.File`
^^^^^^^^^^^^^^^^^

.. autoclass:: File()




   .. autoattribute:: GPS.File.executable_path



   .. autoattribute:: GPS.File.path


   .. automethod:: GPS.File.__init__

   .. automethod:: GPS.File.compile

   .. automethod:: GPS.File.directory

   .. automethod:: GPS.File.entities

   .. automethod:: GPS.File.generate_doc

   .. automethod:: GPS.File.get_property

   .. automethod:: GPS.File.imported_by

   .. automethod:: GPS.File.imports

   .. automethod:: GPS.File.language

   .. automethod:: GPS.File.make

   .. automethod:: GPS.File.name

   .. automethod:: GPS.File.other_file

   .. automethod:: GPS.File.project

   .. automethod:: GPS.File.references

   .. automethod:: GPS.File.remove_property

   .. automethod:: GPS.File.search

   .. automethod:: GPS.File.search_next

   .. automethod:: GPS.File.set_property

   .. automethod:: GPS.File.unit

   .. automethod:: GPS.File.used_by

   .. automethod:: GPS.File.uses

:class:`GPS.FileLocation`
^^^^^^^^^^^^^^^^^^^^^^^^^

.. autoclass:: FileLocation()



   .. automethod:: GPS.FileLocation.__init__

   .. automethod:: GPS.FileLocation.column

   .. automethod:: GPS.FileLocation.file

   .. automethod:: GPS.FileLocation.line

:class:`GPS.FileTemplate`
^^^^^^^^^^^^^^^^^^^^^^^^^

.. autoclass:: FileTemplate()



   .. automethod:: GPS.FileTemplate.register

:class:`GPS.Filter`
^^^^^^^^^^^^^^^^^^^

.. autoclass:: Filter()



   .. automethod:: GPS.Filter.list

:class:`GPS.GUI`
^^^^^^^^^^^^^^^^

.. autoclass:: GUI()



   .. automethod:: GPS.GUI.__init__

   .. automethod:: GPS.GUI.destroy

   .. automethod:: GPS.GUI.hide

   .. automethod:: GPS.GUI.is_sensitive

   .. automethod:: GPS.GUI.pywidget

   .. automethod:: GPS.GUI.set_sensitive

   .. automethod:: GPS.GUI.show

:class:`GPS.HTML`
^^^^^^^^^^^^^^^^^

.. autoclass:: HTML()



   .. automethod:: GPS.HTML.add_doc_directory

   .. automethod:: GPS.HTML.browse

:class:`GPS.Help`
^^^^^^^^^^^^^^^^^

.. autoclass:: Help()



   .. automethod:: GPS.Help.__init__

   .. automethod:: GPS.Help.file

   .. automethod:: GPS.Help.getdoc

   .. automethod:: GPS.Help.reset

:class:`GPS.History`
^^^^^^^^^^^^^^^^^^^^

.. autoclass:: History()



   .. automethod:: GPS.History.__init__

   .. automethod:: GPS.History.add

:class:`GPS.Hook`
^^^^^^^^^^^^^^^^^

.. autoclass:: Hook()



   .. automethod:: GPS.Hook.__init__

   .. automethod:: GPS.Hook.add

   .. automethod:: GPS.Hook.describe_functions

   .. automethod:: GPS.Hook.list

   .. automethod:: GPS.Hook.list_types

   .. automethod:: GPS.Hook.register

   .. automethod:: GPS.Hook.remove

   .. automethod:: GPS.Hook.run

   .. automethod:: GPS.Hook.run_until_failure

   .. automethod:: GPS.Hook.run_until_success

:class:`GPS.Predefined_Hooks`
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. autoclass:: Predefined_Hooks()
    :members:



:class:`GPS.Invalid_Argument`
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. autoclass:: Invalid_Argument()

   .. inheritance-diagram:: GPS.Invalid_Argument

:class:`GPS.Language`
^^^^^^^^^^^^^^^^^^^^^

.. autoclass:: Language()



   .. automethod:: GPS.Language.__init__

   .. automethod:: GPS.Language.get

   .. automethod:: GPS.Language.register

:class:`GPS.LanguageInfo`
^^^^^^^^^^^^^^^^^^^^^^^^^

.. autoclass:: LanguageInfo()




   .. autoattribute:: GPS.LanguageInfo.keywords



   .. autoattribute:: GPS.LanguageInfo.name


:class:`GPS.Libclang`
^^^^^^^^^^^^^^^^^^^^^

.. autoclass:: Libclang()



   .. automethod:: GPS.Libclang.get_translation_unit

:class:`GPS.Locations`
^^^^^^^^^^^^^^^^^^^^^^

.. autoclass:: Locations()



   .. automethod:: GPS.Locations.add

   .. automethod:: GPS.Locations.dump

   .. automethod:: GPS.Locations.list_categories

   .. automethod:: GPS.Locations.list_locations

   .. automethod:: GPS.Locations.parse

   .. automethod:: GPS.Locations.remove_category

   .. automethod:: GPS.Locations.set_sort_order_hint

:class:`GPS.Logger`
^^^^^^^^^^^^^^^^^^^

.. autoclass:: Logger()




   .. autoattribute:: GPS.Logger.active



   .. autoattribute:: GPS.Logger.count


   .. automethod:: GPS.Logger.__init__

   .. automethod:: GPS.Logger.check

   .. automethod:: GPS.Logger.log

   .. automethod:: GPS.Logger.set_active

:class:`GPS.MDI`
^^^^^^^^^^^^^^^^

.. autoclass:: MDI()




   .. autoattribute:: GPS.MDI.FLAGS_ALL_BUTTONS



   .. autoattribute:: GPS.MDI.FLAGS_ALWAYS_DESTROY_FLOAT



   .. autoattribute:: GPS.MDI.FLAGS_DESTROY_BUTTON



   .. autoattribute:: GPS.MDI.FLAGS_FLOAT_AS_TRANSIENT



   .. autoattribute:: GPS.MDI.FLAGS_FLOAT_TO_MAIN



   .. autoattribute:: GPS.MDI.GROUP_CONSOLES



   .. autoattribute:: GPS.MDI.GROUP_DEBUGGER_DATA



   .. autoattribute:: GPS.MDI.GROUP_DEBUGGER_STACK



   .. autoattribute:: GPS.MDI.GROUP_DEFAULT



   .. autoattribute:: GPS.MDI.GROUP_GRAPHS



   .. autoattribute:: GPS.MDI.GROUP_VCS_ACTIVITIES



   .. autoattribute:: GPS.MDI.GROUP_VCS_EXPLORER



   .. autoattribute:: GPS.MDI.GROUP_VIEW



   .. autoattribute:: GPS.MDI.POSITION_AUTOMATIC



   .. autoattribute:: GPS.MDI.POSITION_BOTTOM



   .. autoattribute:: GPS.MDI.POSITION_FLOAT



   .. autoattribute:: GPS.MDI.POSITION_LEFT



   .. autoattribute:: GPS.MDI.POSITION_RIGHT



   .. autoattribute:: GPS.MDI.POSITION_TOP


   .. automethod:: GPS.MDI.add

   .. automethod:: GPS.MDI.children

   .. automethod:: GPS.MDI.current

   .. automethod:: GPS.MDI.current_perspective

   .. automethod:: GPS.MDI.dialog

   .. automethod:: GPS.MDI.file_selector

   .. automethod:: GPS.MDI.get

   .. automethod:: GPS.MDI.get_by_child

   .. automethod:: GPS.MDI.hide

   .. automethod:: GPS.MDI.input_dialog

   .. automethod:: GPS.MDI.load_perspective

   .. automethod:: GPS.MDI.save_all

   .. automethod:: GPS.MDI.show

   .. automethod:: GPS.MDI.yes_no_dialog

:class:`GPS.MDIWindow`
^^^^^^^^^^^^^^^^^^^^^^

.. autoclass:: MDIWindow()

   .. inheritance-diagram:: GPS.MDIWindow

   .. automethod:: GPS.MDIWindow.__init__

   .. automethod:: GPS.MDIWindow.close

   .. automethod:: GPS.MDIWindow.float

   .. automethod:: GPS.MDIWindow.get_child

   .. automethod:: GPS.MDIWindow.is_floating

   .. automethod:: GPS.MDIWindow.name

   .. automethod:: GPS.MDIWindow.next

   .. automethod:: GPS.MDIWindow.raise_window

   .. automethod:: GPS.MDIWindow.rename

   .. automethod:: GPS.MDIWindow.split

:class:`GPS.Menu`
^^^^^^^^^^^^^^^^^

.. autoclass:: Menu()




   .. autoattribute:: GPS.Menu.action


   .. automethod:: GPS.Menu.__init__

   .. automethod:: GPS.Menu.create

   .. automethod:: GPS.Menu.destroy

   .. automethod:: GPS.Menu.get

   .. automethod:: GPS.Menu.hide

   .. automethod:: GPS.Menu.pywidget

   .. automethod:: GPS.Menu.set_sensitive

   .. automethod:: GPS.Menu.show

:class:`GPS.Message`
^^^^^^^^^^^^^^^^^^^^

.. autoclass:: Message()




   .. autoattribute:: GPS.Message.MESSAGE_INVISIBLE



   .. autoattribute:: GPS.Message.MESSAGE_IN_LOCATIONS



   .. autoattribute:: GPS.Message.MESSAGE_IN_SIDEBAR



   .. autoattribute:: GPS.Message.MESSAGE_IN_SIDEBAR_AND_LOCATIONS


   .. automethod:: GPS.Message.__init__

   .. automethod:: GPS.Message.execute_action

   .. automethod:: GPS.Message.get_category

   .. automethod:: GPS.Message.get_column

   .. automethod:: GPS.Message.get_file

   .. automethod:: GPS.Message.get_flags

   .. automethod:: GPS.Message.get_line

   .. automethod:: GPS.Message.get_mark

   .. automethod:: GPS.Message.get_text

   .. automethod:: GPS.Message.list

   .. automethod:: GPS.Message.remove

   .. automethod:: GPS.Message.set_action

   .. automethod:: GPS.Message.set_sort_order_hint

   .. automethod:: GPS.Message.set_style

   .. automethod:: GPS.Message.set_subprogram

:class:`GPS.Missing_Arguments`
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. autoclass:: Missing_Arguments()

   .. inheritance-diagram:: GPS.Missing_Arguments

:class:`GPS.OutputParserWrapper`
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. autoclass:: OutputParserWrapper()



   .. automethod:: GPS.OutputParserWrapper.__init__

   .. automethod:: GPS.OutputParserWrapper.on_exit

   .. automethod:: GPS.OutputParserWrapper.on_stderr

   .. automethod:: GPS.OutputParserWrapper.on_stdout

:class:`GPS.Preference`
^^^^^^^^^^^^^^^^^^^^^^^

.. autoclass:: Preference()



   .. automethod:: GPS.Preference.__init__

   .. automethod:: GPS.Preference.create

   .. automethod:: GPS.Preference.create_style

   .. automethod:: GPS.Preference.get

   .. automethod:: GPS.Preference.set

:class:`GPS.PreferencesPage`
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. autoclass:: PreferencesPage()



   .. automethod:: GPS.PreferencesPage.create

:class:`GPS.Process`
^^^^^^^^^^^^^^^^^^^^

.. autoclass:: Process()

   .. inheritance-diagram:: GPS.Process

   .. automethod:: GPS.Process.__init__

   .. automethod:: GPS.Process.expect

   .. automethod:: GPS.Process.get_result

   .. automethod:: GPS.Process.interrupt

   .. automethod:: GPS.Process.kill

   .. automethod:: GPS.Process.send

   .. automethod:: GPS.Process.set_size

   .. automethod:: GPS.Process.wait

:class:`GPS.Project`
^^^^^^^^^^^^^^^^^^^^

.. autoclass:: Project()




   .. autoattribute:: GPS.Project.target


   .. automethod:: GPS.Project.__init__

   .. automethod:: GPS.Project.add_attribute_values

   .. automethod:: GPS.Project.add_dependency

   .. automethod:: GPS.Project.add_main_unit

   .. automethod:: GPS.Project.add_predefined_paths

   .. automethod:: GPS.Project.add_source_dir

   .. automethod:: GPS.Project.ancestor_deps

   .. automethod:: GPS.Project.clear_attribute_values

   .. automethod:: GPS.Project.dependencies

   .. automethod:: GPS.Project.exec_dir

   .. automethod:: GPS.Project.external_sources

   .. automethod:: GPS.Project.file

   .. automethod:: GPS.Project.generate_doc

   .. automethod:: GPS.Project.get_attribute_as_list

   .. automethod:: GPS.Project.get_attribute_as_string

   .. automethod:: GPS.Project.get_executable_name

   .. automethod:: GPS.Project.get_property

   .. automethod:: GPS.Project.get_tool_switches_as_list

   .. automethod:: GPS.Project.get_tool_switches_as_string

   .. automethod:: GPS.Project.is_harness_project

   .. automethod:: GPS.Project.is_modified

   .. automethod:: GPS.Project.languages

   .. automethod:: GPS.Project.load

   .. automethod:: GPS.Project.name

   .. automethod:: GPS.Project.object_dirs

   .. automethod:: GPS.Project.original_project

   .. automethod:: GPS.Project.properties_editor

   .. automethod:: GPS.Project.recompute

   .. automethod:: GPS.Project.remove_attribute_values

   .. automethod:: GPS.Project.remove_dependency

   .. automethod:: GPS.Project.remove_property

   .. automethod:: GPS.Project.remove_source_dir

   .. automethod:: GPS.Project.rename

   .. automethod:: GPS.Project.root

   .. automethod:: GPS.Project.scenario_variables

   .. automethod:: GPS.Project.scenario_variables_cmd_line

   .. automethod:: GPS.Project.scenario_variables_values

   .. automethod:: GPS.Project.search

   .. automethod:: GPS.Project.set_attribute_as_string

   .. automethod:: GPS.Project.set_property

   .. automethod:: GPS.Project.set_scenario_variable

   .. automethod:: GPS.Project.source_dirs

   .. automethod:: GPS.Project.sources

:class:`GPS.ProjectTemplate`
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. autoclass:: ProjectTemplate()



   .. automethod:: GPS.ProjectTemplate.add_templates_dir

:class:`GPS.ReferencesCommand`
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. autoclass:: ReferencesCommand()

   .. inheritance-diagram:: GPS.ReferencesCommand

   .. automethod:: GPS.ReferencesCommand.get_result

:class:`GPS.Revision`
^^^^^^^^^^^^^^^^^^^^^

.. autoclass:: Revision()



   .. automethod:: GPS.Revision.add_link

   .. automethod:: GPS.Revision.add_log

   .. automethod:: GPS.Revision.add_revision

   .. automethod:: GPS.Revision.clear_view

:class:`GPS.Search`
^^^^^^^^^^^^^^^^^^^

.. autoclass:: Search()




   .. autoattribute:: GPS.Search.ACTIONS



   .. autoattribute:: GPS.Search.BOOKMARKS



   .. autoattribute:: GPS.Search.BUILDS



   .. autoattribute:: GPS.Search.CASE_SENSITIVE



   .. autoattribute:: GPS.Search.ENTITIES



   .. autoattribute:: GPS.Search.FILE_NAMES



   .. autoattribute:: GPS.Search.FUZZY



   .. autoattribute:: GPS.Search.OPENED



   .. autoattribute:: GPS.Search.REGEXP



   .. autoattribute:: GPS.Search.SOURCES



   .. autoattribute:: GPS.Search.SUBSTRINGS



   .. autoattribute:: GPS.Search.WHOLE_WORD


   .. automethod:: GPS.Search.__init__

   .. automethod:: GPS.Search.get

   .. automethod:: GPS.Search.lookup

   .. automethod:: GPS.Search.next

   .. automethod:: GPS.Search.register

   .. automethod:: GPS.Search.search

   .. automethod:: GPS.Search.set_pattern

:class:`GPS.Search_Result`
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. autoclass:: Search_Result()




   .. autoattribute:: GPS.Search_Result.long



   .. autoattribute:: GPS.Search_Result.short


   .. automethod:: GPS.Search_Result.__init__

   .. automethod:: GPS.Search_Result.show

:class:`GPS.Style`
^^^^^^^^^^^^^^^^^^

.. autoclass:: Style()



   .. automethod:: GPS.Style.__init__

   .. automethod:: GPS.Style.get_background

   .. automethod:: GPS.Style.get_foreground

   .. automethod:: GPS.Style.get_in_speedbar

   .. automethod:: GPS.Style.get_name

   .. automethod:: GPS.Style.list

   .. automethod:: GPS.Style.set_background

   .. automethod:: GPS.Style.set_foreground

   .. automethod:: GPS.Style.set_in_speedbar

:class:`GPS.SwitchesChooser`
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. autoclass:: SwitchesChooser()

   .. inheritance-diagram:: GPS.SwitchesChooser

   .. automethod:: GPS.SwitchesChooser.__init__

   .. automethod:: GPS.SwitchesChooser.get_cmd_line

   .. automethod:: GPS.SwitchesChooser.set_cmd_line

:class:`GPS.Task`
^^^^^^^^^^^^^^^^^

.. autoclass:: Task()




   .. autoattribute:: GPS.Task.visible


   .. automethod:: GPS.Task.block_exit

   .. automethod:: GPS.Task.interrupt

   .. automethod:: GPS.Task.list

   .. automethod:: GPS.Task.name

   .. automethod:: GPS.Task.pause

   .. automethod:: GPS.Task.progress

   .. automethod:: GPS.Task.resume

   .. automethod:: GPS.Task.status

:class:`GPS.Timeout`
^^^^^^^^^^^^^^^^^^^^

.. autoclass:: Timeout()



   .. automethod:: GPS.Timeout.__init__

   .. automethod:: GPS.Timeout.remove

:class:`GPS.ToolButton`
^^^^^^^^^^^^^^^^^^^^^^^

.. autoclass:: ToolButton()

   .. inheritance-diagram:: GPS.ToolButton

   .. automethod:: GPS.ToolButton.__init__

:class:`GPS.Toolbar`
^^^^^^^^^^^^^^^^^^^^

.. autoclass:: Toolbar()

   .. inheritance-diagram:: GPS.Toolbar

   .. automethod:: GPS.Toolbar.__init__

   .. automethod:: GPS.Toolbar.append

   .. automethod:: GPS.Toolbar.get

   .. automethod:: GPS.Toolbar.get_by_pos

   .. automethod:: GPS.Toolbar.insert

:class:`GPS.Unexpected_Exception`
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. autoclass:: Unexpected_Exception()

   .. inheritance-diagram:: GPS.Unexpected_Exception

:class:`GPS.VCS`
^^^^^^^^^^^^^^^^

.. autoclass:: VCS()



   .. automethod:: GPS.VCS.annotate

   .. automethod:: GPS.VCS.annotations_parse

   .. automethod:: GPS.VCS.commit

   .. automethod:: GPS.VCS.diff_head

   .. automethod:: GPS.VCS.diff_working

   .. automethod:: GPS.VCS.get_current_vcs

   .. automethod:: GPS.VCS.get_log_file

   .. automethod:: GPS.VCS.get_status

   .. automethod:: GPS.VCS.log

   .. automethod:: GPS.VCS.log_parse

   .. automethod:: GPS.VCS.remove_annotations

   .. automethod:: GPS.VCS.repository_dir

   .. automethod:: GPS.VCS.repository_path

   .. automethod:: GPS.VCS.revision_parse

   .. automethod:: GPS.VCS.set_reference

   .. automethod:: GPS.VCS.status_parse

   .. automethod:: GPS.VCS.supported_systems

   .. automethod:: GPS.VCS.update

   .. automethod:: GPS.VCS.update_parse

:class:`GPS.VCS2`
^^^^^^^^^^^^^^^^^

.. autoclass:: VCS2()




   .. autoattribute:: GPS.VCS2.Status



   .. autoattribute:: GPS.VCS2.name


   .. automethod:: GPS.VCS2.active_vcs

   .. automethod:: GPS.VCS2.ensure_status_for_all_source_files

   .. automethod:: GPS.VCS2.ensure_status_for_files

   .. automethod:: GPS.VCS2.ensure_status_for_project

   .. automethod:: GPS.VCS2.get

   .. automethod:: GPS.VCS2.get_file_status

   .. automethod:: GPS.VCS2.invalidate_status_cache

   .. automethod:: GPS.VCS2.set_run_in_background

   .. automethod:: GPS.VCS2.vcs_in_use

:class:`GPS.VCS2_Task_Visitor`
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. autoclass:: VCS2_Task_Visitor()



   .. automethod:: GPS.VCS2_Task_Visitor.add_lines

   .. automethod:: GPS.VCS2_Task_Visitor.annotations

   .. automethod:: GPS.VCS2_Task_Visitor.branches

   .. automethod:: GPS.VCS2_Task_Visitor.diff_computed

   .. automethod:: GPS.VCS2_Task_Visitor.file_computed

   .. automethod:: GPS.VCS2_Task_Visitor.set_details

:class:`GPS.Vdiff`
^^^^^^^^^^^^^^^^^^

.. autoclass:: Vdiff()



   .. automethod:: GPS.Vdiff.__init__

   .. automethod:: GPS.Vdiff.close_editors

   .. automethod:: GPS.Vdiff.create

   .. automethod:: GPS.Vdiff.files

   .. automethod:: GPS.Vdiff.get

   .. automethod:: GPS.Vdiff.list

   .. automethod:: GPS.Vdiff.recompute

:class:`GPS.XMLViewer`
^^^^^^^^^^^^^^^^^^^^^^

.. autoclass:: XMLViewer()



   .. automethod:: GPS.XMLViewer.__init__

   .. automethod:: GPS.XMLViewer.create_metric

   .. automethod:: GPS.XMLViewer.get_existing

   .. automethod:: GPS.XMLViewer.parse

   .. automethod:: GPS.XMLViewer.parse_string
