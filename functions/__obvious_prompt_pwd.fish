function __obvious_prompt_pwd --description 'Prompt pwd with highlighted "root" folder (based on config)'
    # get config
    set -q __obvious_paths_important; or set -l __obvious_paths_important '~'

    # get beautified parents and pwd
    set -l highlight_parents (string join '|' (__obvious_beautify_path $__obvious_paths_important))
    set -l pwd_short (__obvious_beautify_path $PWD)

    # match parents against pwd
    set -l regexp "^((?:$highlight_parents)/)(.*?)(/.*)?\$"
    set -l matches (string match -r $regexp -- $pwd_short)

    # show output
    set_color normal
    if test (count $matches) -gt 1
        # path to project
        [ $COLUMNS -gt '50' ]; and echo -n $matches[2]

        # project name
        set_color $__obv_color_path_important
        echo -n $matches[3]

        # project subdirectory
        if test (count $matches) -eq 4
            set_color normal
            echo $matches[4]
        end
    else
        # just print the path
        echo -n $pwd_short
    end
end