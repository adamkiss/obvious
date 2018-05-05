function __obvious_prompt_git_is_touched --description 'Count untracked or uncommited files'
    if not git_is_repo; return 1; end

    set -l untracked_or_uncommited (git ls-files (git_repository_root) --exclude-standard --others -m)
    [ (count $untracked_or_uncommited) -gt 0 ]; and return 0; or return 1;
end

function __obvious_prompt_git_is_merging -a repo_root --description 'Simple check for MERGE_HEAD'
    test -f $repo_root/.git/MERGE_HEAD; return $status
end

function __obvious_prompt_git_symbol -a symbol
    set -l color $argv[2..-1]

    echo (set_color $color)$symbol
end

function __obvious_prompt_git -a repo_root
    set -l branch_name (git_branch_name)

    # branch name color
    set -l branch_color brblack
    set -l symbols (git_ahead '⇡' '⇣' '⇡⇣' '')
    if string length $symbols -q
        set branch_color cyan
        set symbols (set_color $branch_color)$symbols
    end
    if __obvious_prompt_git_is_touched
        set branch_color red
        set symbols $symbols(__obvious_prompt_git_symbol '*' $branch_color)
    end
    if git_is_staged
        set branch_color green
        set symbols (__obvious_prompt_git_symbol '️+' $branch_color)$symbols
    end
    if __obvious_prompt_git_is_merging $repo_root
        set branch_color red
        set branch_name 'M! '$branch_name
    end

    # output
    set_color normal
    [ $COLUMNS -gt 30 ]; and echo -n (set_color $branch_color)$branch_name' '
    test -n $symbols; and echo -n $symbols
end