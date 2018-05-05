function __obvious_beautify_path --description 'Shorten path output via configurable list'
    set -q __obvious_paths_shorten; or set -l __obvious_paths_shorten $HOME '~'

    set -l shorten_pairs $__obvious_paths_shorten

    for p in $argv
        set -l path $p

        for i in (seq (math (count $shorten_pairs)/2))
            set -l match $shorten_pairs[(math "$i * 2 - 1")]
            set -l in $shorten_pairs[(math "$i * 2")]
            set path (string replace $match $in $path)
        end

        echo $path
    end
end