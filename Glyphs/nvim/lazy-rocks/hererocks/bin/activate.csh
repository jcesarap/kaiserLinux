which deactivate-lua >&/dev/null && deactivate-lua

alias deactivate-lua 'if ( -x '\''~/.local/share/nvim/lazy-rocks/hererocks/bin/lua'\'' ) then; setenv PATH `'\''~/.local/share/nvim/lazy-rocks/hererocks/bin/lua'\'' '\''~/.local/share/nvim/lazy-rocks/hererocks/bin/get_deactivated_path.lua'\''`; rehash; endif; unalias deactivate-lua'

setenv PATH '~/.local/share/nvim/lazy-rocks/hererocks/bin':"$PATH"
rehash
