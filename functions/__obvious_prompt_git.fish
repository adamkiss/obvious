function __obvious_prompt_git_is_touched --description 'Count untracked or uncommited files'
    if not git_is_repo; return 1; end

    set -l untracked_or_uncommited (git ls-files (git_repository_root) --exclude-standard --others -m)
    [ (count $untracked_or_uncommited) -gt 0 ]; and return 0; or return 1;
end

function __obvious_prompt_git_symbol -a symbol
    set -l color $argv[2..-1]

    echo (set_color $color)$symbol
end


function __obvious_prompt_git
    # symbols / colors
    set -l sym_merging (__obvious_prompt_git_symbol '⨉' red)
    set -l sym_up (__obvious_prompt_git_symbol '↑' magenta)
    set -l sym_down (__obvious_prompt_git_symbol '↓' magenta)
    set -l symbols ''

    set -l upstream_diff (
        string split \t (
            command git rev-list --count --left-right origin...HEAD 2>/dev/null
        )
    )

    # branch name color
    set -l branch_color brblack
    if [ (count $upstream_diff) -gt 0 ]; and [ $upstream_diff[1] -gt 0 -o $upstream_diff[2] -gt 0 ]
        set branch_color magenta
        if test $upstream_diff[1] -gt 0
            set symbols $symbols (__obvious_prompt_git_symbol '⇣' $branch_color)
        end
        if test $upstream_diff[2] -gt 0
            set symbols $symbols (__obvious_prompt_git_symbol '⇡' $branch_color)
        end
    end
    if __obvious_prompt_git_is_touched
        set branch_color red
        set symbols $symbols(__obvious_prompt_git_symbol '*' $branch_color)
    end
    if git_is_staged
        set branch_color green
        set symbols (__obvious_prompt_git_symbol '️+' $branch_color)$symbols
    end

    # output
    set_color normal
    [ $COLUMNS -gt 40 ]; and echo -n (set_color $branch_color)(git_branch_name)' '
    test -n $symbols; and echo -n $symbols
end