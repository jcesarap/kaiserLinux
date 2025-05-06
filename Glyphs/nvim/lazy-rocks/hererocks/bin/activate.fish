if functions -q deactivate-lua
    deactivate-lua
end

function deactivate-lua
    if test -x '~/.local/share/nvim/lazy-rocks/hererocks/bin/lua'
        eval ('~/.local/share/nvim/lazy-rocks/hererocks/bin/lua' '~/.local/share/nvim/lazy-rocks/hererocks/bin/get_deactivated_path.lua' --fish)
    end

    functions -e deactivate-lua
end

set -gx PATH '~/.local/share/nvim/lazy-rocks/hererocks/bin' $PATH
