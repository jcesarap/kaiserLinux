
# Perfect size
> VSC is currently supplying all your text editing needs. No more function is needed.
- THE COST OF BEING A READY TOOL WITH DEBUGGERS AND PLUGINS OF EVERY KIND, PLUG AND PLAY... IS BEING A HEAVIER PROGRAM.
- Other text editors, allegedly lighter, would grow heavier and heavier with constant HEAVY time-costs for adjustments as more tools are needed, to match VSCode's support - all for eventually smaller and smaller performance gains.
- As time is your most precious resource, makes no mathematical sense to waste this for an incomplete tool with NEGLIGIBLE PERFORMANCE DIFFERENCE, BETWEEN TWO EQUALLY LIGHT ALTERNATIVES.
> By 儉无为, to care to learn anything else that is not Yielding, is stupid.

---

# Forewords
> ### The technologies that build this tool are more flexible, allowing swift adaptation, extension and maintenance. ***This, plus sed & regex*** make using (learn it you already have) vim useless
- *Root* - As you often work with text (Eht & Muninn), you need proper tools. Frugality seeks expression in your tools also, and so you map your needs, as being aware of them makes your more able to switch tools upon need.
- *No need to fear* - Important to remember not even the old text editors have become obsolete, nor unusable, nor the switch made hard - as they share similar keybindings, and scripting can be done via regex - which is universal and therefore Yielding, opposed to something like Vimscript, used mostly for writing plugins..
- U.I - Visible, you only need the text you're working on. Other things such as file-tree and terminal may be nice but can be implemented other ways, as long as the glyph is open to keyboard shortcuts on current path.
—— **Menu bar, minimap, any other buttons are completely unneeded**.

> Learn Mth and Eth, not yagni text editing. 

# Lara-script
- This files serves both as reference to VSCodium, and to map ideal functions in text editors.
- **Keep these notes so you can quickly switch to other editors**, knowing what you need, and how to configure it.

# Techniques
## Jumps
- Use `Ctrl+F (Search)` & `Ctrl+[` to jump through words.
	(`workbench.action.closeQuickOpen` & `closeFindWidget` to setup the shortcut above to closing search dialog)
- `Ctrl+P/N` for previous and next matches.
- # TYPE SYMBOLS TO JUMP THROUGH THEM - E.g., `[, {, :`
> þråenr, Editing json files - which is the first format you're considering for Raðasamanbøk, outside of markdown.

# Interoperability 
> Use multiple editors to fulfil optimised editing.
- Micro - Config & Quick edits.
- VSCodium - Optimised development, plug-&-play anything, follows Flow Design.
--- With many tabs, uses no more than 100mb RAM.
- Obsidian/Typora for Markdown with live rendering.
> Through rofi, you can quickly switch between these.

# Basic functions
## General
> The visible UI needs to contain no more than: File-name, Scroll-bar.
- Host clipboard integration.
- `Esc` in search puts cursor to result.
- Markdown highlighting - the most common feature.
## Keyboard
> Customisable keyboard shortcuts - to keep them consistent through glyphs &  Complete (almost) keyboard navigation - requiring mouse, at most, to manage settings.
- Arrows to move cursor, Ctrl jumps words.
- Fn+Arrows for Home/End/PgUp/PgDn.
- Arrows+Shift for selection.

# Important
> From here forth, features are only needed in relation to Interoperability's specific glyphs.
- File tree, Outline, Cross document replace & query.

# K. Shortcuts
> Other features can be ignored, as are un-Yielding.
## Common
- Save `Ctrl+S`
- Save As `Ctrl+Shift+S`
- Open file `Ctrl+O`
- Undo `Ctrl+Z`
- Redo `Ctrl+Shift+Z`
- Copy `Ctrl+C`
- Paste `Ctrl+V`
- Delete line `Ctrl+D`
- Cut `Ctrl+X`
- Select all `Ctrl+A`
- Rename `Super+R`
## Specific
- Move line `Ctrl+Shift+Arrows`
## UI
- File explorer `Super+E`
- Outline `Super+O`
## File
- Find in Folder `Ctrl+Shift+F` -> `Ctrl+Alt+F`
- Settings `Ctrl+;`
- New instance of current editor `Super+N`
> New file, new folder, Open folder, Close folder - All evoked via *universal search*, as rarely needed.
## CC
> Menu bar and any other buttons can be activated via this.
- Go to file `Super+F`
	- `>` commands
		- or `Ctrl+Shift+/`
	- `view` to toggle menu visibility
## Text modifications
- Replace `Ctrl+R`
- Column selection mode `Super+\`
- Toggle Line comment `Ctrl+~`
- Word wrap `Ctrl+]`
- Switch to uppercase `ctrl+super+up`
- Switch to lowercase `ctrl+super+down`
## Expansion & Folding
- Fold all `Super+Shift+Tab`
- Unfold all `Super+Tab`
- Fold toggle current line `Ctrl+Tab`
## Multi-cursor
> Back to only one selection `Esc`
- Cursor/Select all `Super+A`
- Cursor to line ends `Super+D`
- Cursor next/previous (matching selection) `Super+W||S`

## Miscellaneous cursor
- Last edit location `Ctrl+Alt+Z`
- Go to line `Ctrl+L`
- Move view without moving cursor `Ctrl+Arrows`
- Cursor undo `Super+z`
- Cursor redo `Super+Shift+z`
- Go back & forward cursor (resuming positions) `Super+Arrows`

## Tabs
- Move through tabs `Super+Arrows` - Both vertical (tabs) and horizontal (open-editors, right side menu) tabs
- Move tabs `Super+Shift+Arrows` - Both vertical (tabs) and horizontal (open-editors, right side menu) tabs
## View
> `Super+V` to open menu that moves through menus.
- In it you can toggle: Breadcrumbs, Status bar, Extensions.
- Primary sidebar // Secondary sidebar `Super+< // >`
- Focus on bar `Super+Shift+< // >`
- File explorer `Super+E`
- Hide search: `Ctrl+[`, ergonomic, based on Vim - as Codium seems to refuse the xbk rebinding of Esc to Ins.
- Hide secondary cursors: `Ctrl+[` - same reasons as the above.`
## Second Panel
- Problems `Super+1`
- Output `Super+2`
- Debug console `Super+3`
- Terminal `Super+4`
- Ports `Super+5`
> Focus can be switched by toggling the whole bar on/off view.

# Others
- Spelling suggestion `Ctrl+Super+Space`

# CLI
> For now, use the tools VSCode already loads - aware that if you ever need to change, you can use the following to separate concerns/actions between other glyphs.
- `codium .` - Opens the folder you're on the terminal.
- This also allows you to manage files/directories on Ranger.
