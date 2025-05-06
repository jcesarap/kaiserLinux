# ~/.config/ranger/colorschemes/invisible_status_bar.py
from ranger.gui.colorscheme import ColorScheme
from ranger.gui.color import *

class InvisibleStatusBar(ColorScheme):
    def __init__(self):
        super().__init__()
        self.base00 = black  # Match this with your terminal's background color
        self.base01 = darkgray
        self.base02 = gray
        self.base03 = lightgray
        self.base04 = white
        self.base05 = brightwhite
        self.base06 = red
        self.base07 = yellow
        self.base08 = green
        self.base09 = blue
        self.base0A = cyan
        self.base0B = magenta
        self.base0C = brightcyan
        self.base0D = brightmagenta
        self.base0E = brightyellow
        self.base0F = brightred

    def setup(self, *args, **kwargs):
        # Colors for file types
        self.normal = {
            "directory": self.base0D,
            "executable": self.base0B,
            "link": self.base0A,
            "compressed": self.base09,
            "image": self.base0C,
            "text": self.base0F,
            "default": self.base05,
        }
        self.selected = {
            "directory": self.base0D,
            "executable": self.base0B,
            "link": self.base0A,
            "compressed": self.base09,
            "image": self.base0C,
            "text": self.base0F,
            "default": self.base06,
        }
        self.marked = {
            "directory": self.base0D,
            "executable": self.base0B,
            "link": self.base0A,
            "compressed": self.base09,
            "image": self.base0C,
            "text": self.base0F,
            "default": self.base06,
        }
        # Set status bar colors to match terminal background
        self.status = {
            "directory": self.base00,
            "executable": self.base00,
            "link": self.base00,
            "compressed": self.base00,
            "image": self.base00,
            "text": self.base00,
            "default": self.base00,
        }
        self.message = {
            "directory": self.base00,
            "executable": self.base00,
            "link": self.base00,
            "compressed": self.base00,
            "image": self.base00,
            "text": self.base00,
            "default": self.base00,
        }
