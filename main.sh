#!/usr/bin/env bash

# Copyright (c) 2026 Egor Tensin <egor@tensin.name>
# This file is part of the "test-harness" project.
# For details, see https://github.com/egor-tensin/test-harness
# Distributed under the MIT License.

set -o errexit -o nounset -o pipefail
shopt -s inherit_errexit 2> /dev/null || true
shopt -s lastpipe

_script_dir="$( dirname -- "${BASH_SOURCE[0]}" )"
_script_dir="$( cd -- "$_script_dir" && pwd )"
readonly _script_dir
_script_name="$( basename -- "${BASH_SOURCE[0]}" )"
readonly _script_name

readonly tests_dir="$_script_dir/.."

source "$_script_dir/lib/log.sh"

run_test_file() {
    local test_file
    for test_file; do
        source "$_script_dir/lib/test.sh"

        local lib_file
        find "$tests_dir/lib" \
            -mindepth 1 \
            -maxdepth 1 \
            -type f \
            -name '*.sh' \
            -print0 \
            | sort -z \
            | \
        while IFS= read -d '' -r lib_file; do
            source "$lib_file"
        done

        source "$tests_dir/$test_file"

        log_test_start "$test_file"

        set +e
        (
            set -o errexit -o nounset -o pipefail
            shopt -s inherit_errexit 2> /dev/null || true
            shopt -s lastpipe

            trap test_cleanup_global EXIT
            test_setup_global
            test_run
        )
        local ret="$?"
        set -e

        log_test_finish "$test_file" "$ret"
    done
}

main() {
    if [ "$#" -gt 1 ]; then
        echo "usage: $_script_name [PATTERN]" >&2
        return 1
    fi

    local -a test_files=()
    local test_file

    local pattern='*'
    [ "$#" -gt 0 ] && pattern="$1"

    find "$tests_dir" \
        -mindepth 1 \
        -maxdepth 1 \
        -type f \
        -regex '.*/tst-.*\.sh$' \
        -regextype posix-basic \
        -name "$pattern" \
        -printf '%P\0' \
        | sort -z \
        | \
    while IFS= read -d '' -r test_file; do
        test_files+=("$test_file")
    done

    run_test_file ${test_files[@]+"${test_files[@]}"}
    log_tests_summary
}

main "$@"
