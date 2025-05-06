# This is a sample commands.py.  You can add your own commands here.
#
# Please refer to commands_full.py for all the default commands and a complete
# documentation.  Do NOT add them all here, or you may end up with defunct
# commands when upgrading ranger.

# A simple command for demonstration purposes follows.
# -----------------------------------------------------------------------------

from __future__ import (absolute_import, division, print_function)

# You can import any python module as needed.
import os

# You always need to import ranger.api.commands here to get the Command class:
from ranger.api.commands import Command

# Open_with_xournal
from ranger.api.commands import Command
import os
class open_with_xournal(Command):
    """
    Custom command to open a file with Flatpak Xournal on the selected path.
    """
    def execute(self):
        # Get the selected file's path
        selected_path = self.fm.thisfile.path

        # Construct the command to open with flatpak xournalpp
        command = f"nohup setsid flatpak run com.github.xournalpp.xournalpp '{selected_path}' > /dev/null &"

        # Execute the command
        self.fm.execute_command(command)

# Open_with_typora
from ranger.api.commands import Command
import os
class open_with_typora(Command):
    """
    Custom command to open a file with Flatpak Xournal on the selected path.
    """
    def execute(self):
        # Get the selected file's path
        selected_path = self.fm.thisfile.path

        # Construct the command to open with flatpak typora
        command = f"nohup setsid flatpak run io.typora.Typora '{selected_path}' > /dev/null &"

        # Execute the command
        self.fm.execute_command(command)

# Open With nvim
from ranger.api.commands import Command
import os
class open_with_nvim(Command):
    """
    Custom command to open a file with Flatpak Xournal on the selected path.
    """
    def execute(self):
        # Get the selected file's path
        selected_path = self.fm.thisfile.path

        # Construct the command to open with flatpak xournalpp
        command = f"nvim '{selected_path}'"

        # Execute the command
        self.fm.execute_command(command)

# Open With code
from ranger.api.commands import Command
import os
class open_with_code(Command):
    """
    Custom command to open a file with Flatpak Xournal on the selected path.
    """
    def execute(self):
        # Get the selected file's path
        selected_path = self.fm.thisfile.path

        # Construct the command to open with flatpak xournalpp
        command = f"code --profile main '{selected_path}'"

        # Execute the command
        self.fm.execute_command(command)



# Open With Firefox (For HTML/CSS)
from ranger.api.commands import Command
import os
class open_with_firefox(Command):
    """
    Custom command to open a file with Flatpak Xournal on the selected path.
    """
    def execute(self):
        # Get the selected file's path
        selected_path = self.fm.thisfile.path

        # Construct the command to open with flatpak xournalpp
        command = f"nohup setsid firefox --new-window '{selected_path}' > /dev/null &"

        # Execute the command
        self.fm.execute_command(command)




from ranger.api.commands import Command
import os
class open_with_inkscape(Command):
    """
    Custom command to open a file with Flatpak Xournal on the selected path.
    """
    def execute(self):
        # Get the selected file's path
        selected_path = self.fm.thisfile.path

        # Construct the command to open with flatpak xournalpp
        command = f"nohup setsid flatpak run org.inkscape.Inkscape '{selected_path}' > /dev/null &"

        # Execute the command
        self.fm.execute_command(command)

# Open-with-rofi - Outwards Integration
from ranger.api.commands import Command
class open_with_rofi(Command):
    """
    Custom command to open a file or directory with a rofi-based script.
    """
    def execute(self):
        # Get the selected file's path
        selected = self.fm.thisfile.path
        selected_path = self.fm.thisfile.path
        # Export the variables to the environment
        os.environ['selected'] = selected
        os.environ['selected_path'] = selected_path
        # Construct the command to open with rofi
        command = f"nohup setsid ~/Dropbox/Kaiser-Linux/Scripts/rofi/finder.sh openwithrofi > /dev/null &"
        # Execute the command
        self.fm.execute_command(command)

class copy_markdown_image_path(Command):
    def execute(self):
        # Get the current file's path
        filename = self.fm.thisfile.relative_path
        # Format the path as ![](./Images/filename)
        markdown_path = f"![](./Images/{filename})"
        # Copy the formatted path to the clipboard
        self.fm.execute_command(f"echo -n '{markdown_path}' | xclip -selection clipboard")
        self.fm.notify(f"Copied to clipboard: {markdown_path}")

# Any class that is a subclass of "Command" will be integrated into ranger as a
# command.  Try typing ":my_edit<ENTER>" in ranger!
class my_edit(Command):
    # The so-called doc-string of the class will be visible in the built-in
    # help that is accessible by typing "?c" inside ranger.
    """:my_edit <filename>

    A sample command for demonstration purposes that opens a file in an editor.
    """

    # The execute method is called when you run this command in ranger.
    def execute(self):
        # self.arg(1) is the first (space-separated) argument to the function.
        # This way you can write ":my_edit somefilename<ENTER>".
        if self.arg(1):
            # self.rest(1) contains self.arg(1) and everything that follows
            target_filename = self.rest(1)
        else:
            # self.fm is a ranger.core.filemanager.FileManager object and gives
            # you access to internals of ranger.
            # self.fm.thisfile is a ranger.container.file.File object and is a
            # reference to the currently selected file.
            target_filename = self.fm.thisfile.path

        # This is a generic function to print text in ranger.
        self.fm.notify("Let's edit the file " + target_filename + "!")

        # Using bad=True in fm.notify allows you to print error messages:
        if not os.path.exists(target_filename):
            self.fm.notify("The given file does not exist!", bad=True)
            return

        # This executes a function from ranger.core.acitons, a module with a
        # variety of subroutines that can help you construct commands.
        # Check out the source, or run "pydoc ranger.core.actions" for a list.
        self.fm.edit_file(target_filename)

    # The tab method is called when you press tab, and should return a list of
    # suggestions that the user will tab through.
    # tabnum is 1 for <TAB> and -1 for <S-TAB> by default
    def tab(self, tabnum):
        # This is a generic tab-completion function that iterates through the
        # content of the current directory.
        return self._tab_directory_content()

# fzf (inside files)

from ranger.api.commands import Command
import os, subprocess, shlex

class fzf_inside(Command):
    """
    :fzf_inside

    Search inside files using ripgrep and fzf, then open the selected file in nvim.
    """

    def execute(self):
        # Build the pipeline:
        #   1. Use ripgrep (rg) to output matches in "filename:line:..." format.
        #   2. Pipe into fzf with colon as delimiter.
        command = (
            "rg --line-number --no-heading --color=always "" | fzf --ansi --delimiter : --nth 2.. | while IFS=: read -r file line _; do [[ -n \"$file\" ]] && nvim +\"$line\" \"$file\"; done"
        )

        proc = self.fm.execute_command(command, stdout=subprocess.PIPE, shell=True)
        stdout, _ = proc.communicate()

        if proc.returncode != 0 or not stdout:
            return

        # Decode and split the output; expected format is "filename:line:..."
        selected = stdout.decode('utf-8').strip()
        parts = selected.split(":", 2)
        if len(parts) < 2:
            self.fm.notify("No valid selection", bad=True)
            return

        file_path = os.path.abspath(parts[0])
        line_number = parts[1]

        if not os.path.exists(file_path):
            self.fm.notify("File not found!", bad=True)
            return

        # Use shlex.quote to safely escape the file_path if it contains special characters.
        cmd = f"nvim +{line_number} {shlex.quote(file_path)}"
        self.fm.execute_command(cmd)

# fzf
import os
import subprocess

import ranger.api.commands as ranger


class fzf(ranger.Command):
    """
    :fzf_select

    Find a file using fzf.

    With a prefix argument, select only directories.
    """

    def execute(self):
        if self.quantifier:
            # match only directories, excluding hidden ones
            command = "find . -mindepth 1 -type d ! -path '*/.*' 2>/dev/null | fzf +m"
        else:
            # match files and directories, excluding hidden ones
            command = "find . -mindepth 1 ! -path '*/.*' 2>/dev/null | fzf +m"
        fzf = self.fm.execute_command(command, stdout=subprocess.PIPE)
        stdout, _ = fzf.communicate()
        if fzf.returncode == 0:
            fzf_file = os.path.abspath(stdout.decode('utf-8').rstrip('\n'))
            if os.path.isdir(fzf_file):
                self.fm.cd(fzf_file)
            else:
                self.fm.select_file(fzf_file)
