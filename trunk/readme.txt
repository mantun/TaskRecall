Contents:
Installation
Keyboard shortcuts
Setting a Reminder
Support
Compiling the source code
Credits
Legal notes

+Installation
Just copy the executable file somewhere. It creates a 'data' directory in the current folder.

+Keyboard shortcuts
Win+A    - Activates the program
Win+G    - Append a Log note to the currently active task
Win+1-9  - Activates (starts time tracking for) task from the active tasks list
Win+0    - Deactivates (starts time tracking for) a task 
Ctrl+T   - Shows the timeline
Del      - (in task list view) Removes task from current view - this does not delete the task
Ctrl+Del - (in task list view) Deletes a task

+Setting a Reminder
Perhaps the most unique feature of the program is the way you set reminders. The program has integrated interpreter for lisp-like expressions (called Simple List Interpreter). The expression is evaluated and its result determines the time when the reminder fires and a pop-up window is shown.
Some examples:
-5 - 5 minutes before task start date
(ts 17.12.2007 12:00) - at the specified time
(ts (move-day sd -1) 18:00) - the day before task start date at 18h
(ts (dmy 17 12 (year)) 11:00) - at 17.12 of the current year (note that this will fire every year on that date)
(ts (in (dow) 1 3 5) 11:00) - every Monday, Wednesday and Friday at 11h (note that the date here is a boolean expression)
(ts (seq 17.12.2007 20.12.2007) 18:00) - on both dates at 18h
(ts (= (day) 6) 11:00) - on the 6th of every month at 11h
For detailed description of the language and available functions, see syntax.txt.

+Support
I offer no support, sorry. However, drop me a note on http://sourceforge.net/tracker/?group_id=194959 if you need something. Chances are, I'll reply within a month.

+Compiling the source code
I have used Delphi 7 Personal Edition, and I have no access to other versions, so I have not tried other versions. It will most probably compile with any version of Delphi. 'Personal Edition' means that the program can rely only on the most basic components with the exception of the powerful VirtualTreeview component.
You must download and install Virtual Treeview (http://www.soft-gems.net/index.php?option=com_content&task=view&id=12&Itemid=38) before opening the project.
Then you can open the project and build it. Note that in directory SLI there is another project that can be used to test the Simple List Interpreter.

+Credits
TStringManager (Class with string functions) - by Eric Grobler, http://www.geocities.com/ericdelphi/StrMan.html
Virtual Tree View - by Mike Lischke, http://www.soft-gems.net/
Fast Memory Manager - by Pierre le Riche, http://fastmm.sourceforge.net/
Button Icons - by Mark James, http://www.famfamfam.com/

+Legal notes
This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.
