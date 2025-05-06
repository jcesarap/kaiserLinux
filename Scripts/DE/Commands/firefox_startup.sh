#!/bin/bash
# Add this to i3wm
# Open all files in directory
index="~/Dropbox/Notes/— Workspace/Fullstack_engineer_index.md"
date="date +%s"
# tempfile="/tmp/pandoc.tmp.$(date +%s).html"
tempfile="~/Downloads/pandoc.tmp.$(date +%s).html"
pandoc "$index" -t html -o "$tempfile"
firefox "$tempfile" 2>/dev/null
sleep 5
rm -f "$tempfile"
