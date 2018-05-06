function __obvious_prompt_split
    echo (set_color $__obv_color_split)' · '
end

function fish_prompt --description 'Write out the prompt'
    set -l last_status $status
    
    # Get configurable things or use default
    set -q obvious_prompt_symbol; or set -l obvious_prompt_symbol '⚡️ '

    echo 
    if [ $COLUMNS -gt '60' ]
        echo -n (set_color $__obv_color_time)(date +"%H:%M")(__obvious_prompt_split)
    end

    if test -n "$SSH_CONNECTION"
        # User
        set_color -b 666 000
        echo -n ' '(whoami)' @ '

        # Host
        set_color -o
        echo -n (hostname -s)' '

        echo -n (__obvious_prompt_split)
    end

    # PWD
    set_color $fish_color_cwd
    echo -n (__obvious_prompt_pwd)

    set -l git_repo_root (git_repository_root)
    if git_is_repo
        echo -n (__obvious_prompt_split)
        __obvious_prompt_git $git_repo_root
    end
    
    echo # end first line

    if not test $last_status -eq 0
        set_color $fish_color_error
        echo -n '👿 '
    else
        echo -n $obvious_prompt_symbol
    end

    set_color normal
end