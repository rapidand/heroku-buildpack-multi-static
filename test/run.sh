#!/usr/bin/env bash

root="$(dirname "$0")/.."

testBasic() {
    temp_dir="$(mktemp -d "${SHUNIT_TMPDIR}/temp.XXXXX")"
    mkdir -p "$temp_dir/"{build,cache,env}

    mkdir "$temp_dir/build/sub"
    echo "web: hello" > "$temp_dir/build/sub/THE_PROCFILE"
    echo "sub/THE_PROCFILE" > "$temp_dir/env/PROCFILE"

    "$root/bin/compile" "$temp_dir/build" "$temp_dir/cache" "$temp_dir/env"

    assertTrue "sub/THE_PROCFILE and Procfile differ" "cmp $temp_dir/build/sub/THE_PROCFILE $temp_dir/build/Procfile"
}

testBasicAppJSON() {
    temp_dir="$(mktemp -d "${SHUNIT_TMPDIR}/temp.XXXXX")"
    mkdir -p "$temp_dir/"{build,cache,env}

    mkdir "$temp_dir/build/sub"
    echo "web: hello" > "$temp_dir/build/sub/THE_PROCFILE"
    echo "{}" > "$temp_dir/build/sub/app.json"
    echo "sub/THE_PROCFILE" > "$temp_dir/env/PROCFILE"

    "$root/bin/compile" "$temp_dir/build" "$temp_dir/cache" "$temp_dir/env"

    assertTrue "sub/app.json and app.json differ" "cmp $temp_dir/build/sub/app.json $temp_dir/build/app.json"
}

testMissingProcfileEnv() {
    temp_dir="$(mktemp -d "${SHUNIT_TMPDIR}/temp.XXXXX")"
    mkdir -p "$temp_dir/"{build,cache,env}

    if "$root/bin/compile" "$temp_dir/build" "$temp_dir/cache" "$temp_dir/env"; then
	fail "compile should have failed"
    fi
}

testMissingProcfileFile() {
    temp_dir="$(mktemp -d "${SHUNIT_TMPDIR}/temp.XXXXX")"
    mkdir -p "$temp_dir/"{build,cache,env}

    echo "sub/THE_PROCFILE" > "$temp_dir/env/PROCFILE"

    if "$root/bin/compile" "$temp_dir/build" "$temp_dir/cache" "$temp_dir/env"; then
	fail "compile should have failed"
    fi
}

. "$root/test/shunit2"
