function __obvious_prompt_split
    set -l split_symbol ' · '
    if [ $COLUMNS -lt '60' ]; set split_symbol ' '; end

    echo (set_color $__obv_color_split)$split_symbol
end

function fish_prompt --description 'Write out the prompt'
    set -l last_status $status
    
    # Get configurable things or use default
    set -q obvious_prompt_symbol; or set -l obvious_prompt_symbol '⚡️ '
    set -q obvious_prompt_error_symbol; or set -l obvious_prompt_error_symbol '× '

    echo
    
    if test -n "$SSH_CONNECTION"
        # User
        set_color -b 222 brblack
        echo -n ' '(whoami)' @ '

        # Host
        set_color -o
        echo -n (hostname -s)' '

        set_color normal
        echo -n (__obvious_prompt_split)
    end

    # TEST FOR SCREEN
    if test -n "$STY"
        set_color -b 222 brblack
        echo -n (string split -m 1 '.' $STY)[2]

        set_color normal
        echo -n (__obvious_prompt_split)
    end

    if [ $COLUMNS -gt '60' ]
        echo -n (set_color $__obv_color_time)(date +"%H:%M")(__obvious_prompt_split)
    end

    # PWD
    set_color $fish_color_cwd
    echo -n (__obvious_prompt_pwd)

    set -l git_repo_root (git_repository_root)
    if git_is_repo
        echo -n (__obvious_prompt_split)
        __obvious_prompt_git $git_repo_root
    end

    set_color normal
    echo # end first line

    if not test $last_status -eq 0
        set_color $fish_color_error
        echo -n $obvious_prompt_error_symbol
    else
        echo -n $obvious_prompt_symbol
    end

    set_color normal
end