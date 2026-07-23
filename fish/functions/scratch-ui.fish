function scratch-ui --description "Launch a named Vite scratch app"
    if test (count $argv) -lt 1
        echo "Usage: scratch-ui <name> [template]" >&2
        echo "Example: scratch-ui drag-drop-test" >&2
        return 2
    end

    set -l app_name $argv[1]
    set -l template react-ts

    if test (count $argv) -ge 2
        set template $argv[2]
    end

    if not string match -rq '^[a-z0-9][a-z0-9-]*$' -- "$app_name"
        echo "Name must be a lowercase slug, e.g. drag-drop-test" >&2
        return 2
    end

    set -l previous_dir $PWD
    set -l temp_root /tmp

    if set -q TMPDIR
        set temp_root (string trim --right --chars=/ $TMPDIR)
    end

    set -l scratch_root "$temp_root/scratch-ui"
    set -l dir "$scratch_root/$app_name"

    mkdir -p "$scratch_root"
    or return 1

    if test -e "$dir"
        echo "A scratch app with that name already exists:"
        echo "$dir"
        return 1
    end

    mkdir "$dir"
    or return 1

    cd "$dir"
    or return 1

    if not npm create vite@latest . -- \
        --template "$template" \
        --no-interactive
        cd "$previous_dir"
        command rm -rf -- "$dir"
        return 1
    end

    if not npm install
        cd "$previous_dir"
        command rm -rf -- "$dir"
        return 1
    end

    set -l zed_cli (command -s zed)

    if test -z "$zed_cli"
        set zed_cli "/Applications/Zed.app/Contents/MacOS/cli"
    end

    if not test -x "$zed_cli"
        echo "Could not locate the Zed CLI." >&2
        cd "$previous_dir"
        return 1
    end

    "$zed_cli" -n "$dir"
    npm run dev -- --open
    set -l dev_status $status

    cd "$previous_dir"

    echo
    echo "Scratch app retained at:"
    echo "$dir"

    return $dev_status
end
