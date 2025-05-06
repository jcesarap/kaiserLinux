from __future__ import absolute_import, division, print_function

from ranger.gui.colorscheme import ColorScheme
from ranger.gui.color import (
    black,
    white,
    default,
    normal,
    bold,
    reverse,
)


class BlackWhiteColorScheme(ColorScheme):
    progress_bar_color = white

    def verify_browser(self, context, fg, bg, attr):
        if context.selected:
            attr = reverse
        else:
            attr = normal

        if context.empty or context.error:
            bg = black
            fg = white
        if context.border:
            fg = default
        if context.document:
            attr |= normal
            fg = white
        if context.media:
            fg = white
        if context.container:
            attr |= bold
            fg = white
        if context.directory:
            attr |= bold
            fg = white
        elif context.executable:
            attr |= bold
            fg = white
        if context.socket:
            fg = white
            attr |= bold
        if context.fifo or context.device:
            fg = white
        if context.link:
            fg = white if context.good else white
        if context.tag_marker and not context.selected:
            attr |= bold
            fg = white
        if not context.selected and (context.cut or context.copied):
            fg = white
            attr |= bold
        if context.main_column:
            if context.selected:
                attr |= bold
            if context.marked:
                attr |= bold
                fg = white
        if context.badinfo:
            if attr & reverse:
                bg = white
            else:
                fg = white

        if context.inactive_pane:
            fg = white

        return fg, bg, attr

    def verify_titlebar(self, context, fg, bg, attr):
        attr |= bold
        if context.hostname:
            fg = white if context.bad else white
        elif context.directory:
            fg = white
        elif context.tab:
            if context.good:
                bg = white
        elif context.link:
            fg = white

        return fg, bg, attr

    def verify_statusbar(self, context, fg, bg, attr):
        if context.permissions:
            if context.good:
                fg = white
            elif context.bad:
                bg = white
                fg = black
        if context.marked:
            attr |= bold | reverse
            fg = white
        if context.frozen:
            attr |= bold | reverse
            fg = white
        if context.message:
            if context.bad:
                attr |= bold
                fg = white
        if context.loaded:
            bg = self.progress_bar_color
        if context.vcsinfo:
            fg = white
            attr &= ~bold
        if context.vcscommit:
            fg = white
            attr &= ~bold
        if context.vcsdate:
            fg = white
            attr &= ~bold

        return fg, bg, attr

    def verify_taskview(self, context, fg, bg, attr):
        if context.title:
            fg = white

        if context.selected:
            attr |= reverse

        if context.loaded:
            if context.selected:
                fg = self.progress_bar_color
            else:
                bg = self.progress_bar_color

        return fg, bg, attr

    def verify_vcsfile(self, context, fg, bg, attr):
        attr &= ~bold
        if context.vcsconflict:
            fg = white
        elif context.vcschanged:
            fg = white
        elif context.vcsunknown:
            fg = white
        elif context.vcsstaged:
            fg = white
        elif context.vcssync:
            fg = white
        elif context.vcsignored:
            fg = white

        return fg, bg, attr

    def verify_vcsremote(self, context, fg, bg, attr):
        attr &= ~bold
        if context.vcssync or context.vcsnone:
            fg = white
        elif context.vcsbehind:
            fg = white
        elif context.vcsahead:
            fg = white
        elif context.vcsdiverged:
            fg = white
        elif context.vcsunknown:
            fg = white

        return fg, bg, attr

    def use(self, context):
        fg, bg, attr = default_colors

        if context.reset:
            return default_colors

        elif context.in_browser:
            fg, bg, attr = self.verify_browser(context, fg, bg, attr)

        elif context.in_titlebar:
            fg, bg, attr = self.verify_titlebar(context, fg, bg, attr)

        elif context.in_statusbar:
            fg, bg, attr = self.verify_statusbar(context, fg, bg, attr)

        if context.text:
            if context.highlight:
                attr |= reverse

        if context.in_taskview:
            fg, bg, attr = self.verify_taskview(context, fg, bg, attr)

        if context.vcsfile and not context.selected:
            fg, bg, attr = self.verify_vcsfile(context, fg, bg, attr)

        elif context.vcsremote and not context.selected:
            fg, bg, attr = self.verify_vcsremote(context, fg, bg, attr)

        return fg, bg, attr
