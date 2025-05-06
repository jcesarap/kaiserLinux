#!/bin/bash

# --- "Use Case"
# "Install" the script by setting up a "terminal shortcut" to it
# After it, you can re-Compile/Run code with two clicks - instead of typing commands

# --- "Installation"
# Set an alias to bash so it runs this script anywhere
# By adding "alias c='~/path/to/script'" to "~/.bash_profile" or "~/.bashrc"
# ...And adjusting the path to the path you stored the script
# After that, you can type the letters after "alias", and it will run 
# Each directory must have a README.md file with "Compile: " with the compile command in front of it
# --- Example Aliases to add to "~/.bash_profile" file
# alias co='~/path/to/script options' # For Options
# alias cc='~/path/to/script compile' # For Compile Code
# alias cr='~/path/to/script run' # For Compile (kinda the name of the script) Run
# alias car='~/path/to/script compile_and_run' # For Compile And Run

# Find README ---- --- --- --- --- --- --- --- --- --- -- --- --- --- --- --- --- --- --- --- --- 
# Get lines with commands (and get them to variables - trimmed)
COMPILE=$(awk '/- Compile: / {print substr($0, index($0,$2))}' README.md)
RUN=$(awk '/- Run: / {print substr($0, index($0,$2))}' README.md)
# index() Finds the starting position ($2) in the entire line ($0)
# Say you have "Compile: gcc", awk takes gcc (whatever is after : and space)

# Fallback --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

if [[ -z "$COMPILE" ]]; then
    printf "\n We couldn't find a compile command... \n \n Write (on a README.md) 'Compile: ' (with space after ':'), and run the script again"
fi

if [[ -z "$RUN" ]]; then
    printf "\n We couldn't find a run command... \n \n Write (on a README.md) 'Run: ' (with space after ':'), and run the script again"
fi

# Arguments --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
case "$1" in
    options)
        printf "   \n [ Quick Compile ] \n\n   1 Compile \n   2) Run \n   3) Compile & Run \n\n"
        read -p "   Choose a number/option: " option
        case "$option" in
            1)
                bash -c "$COMPILE"
                ;;
            2)
                bash -c "$RUN"
                ;;
            3)
                bash -c "$COMPILE"
                bash -c "$RUN"
                ;;
            *)
                echo "   Invalid option... Choose between 1, 2 or 3"
                ;;
        esac
        ;;
    compile)
        bash -c "$COMPILE"
        ;;
    run)
        bash -c "$RUN"
        ;;
    compile_and_run)
        bash -c "$COMPILE"
        bash -c "$RUN"
        ;;
    *)
        echo "   Invalid option... Choose between 1, 2 or 3"
        ;;
esac
