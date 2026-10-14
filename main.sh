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

source "$_script_dir/lib/log.sh"

_test_run_file() {
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

        _log_test_start "$test_file"

        set +e
        (
            set -o errexit -o nounset -o pipefail
            shopt -s inherit_errexit 2> /dev/null || true
            shopt -s lastpipe

            trap _test_cleanup_global EXIT
            _test_setup_global
            test_run
        )
        local ret="$?"
        set -e

        _log_test_finish "$test_file" "$ret"
    done
}

_test_usage() {
    local msg
    for msg; do
        echo "$_script_name: $msg"
    done

    echo "usage: $_script_name [-h|--help] [-d|--dir DIR] [-f|--filter NAME_PATTERN]
  -h,--help      show this message and exit
  -d,--dir       directory with tests
  -f,--filter    only run tests with names matching the pattern (uses fnmatch(3))"
}

_test_parse_args() {
    tests_dir="$_script_dir/.."
    _test_pattern='*'

    while [ "$#" -gt 0 ]; do
        local key="$1"
        shift

        case "$key" in
            -h|--help)
                _test_usage
                exit 0
                ;;
            -d|--dir|-f|--filter)
                ;;
            *)
                _test_usage "unrecognized parameter: $key" >&2
                return 1
                ;;
        esac

        if [ "$#" -eq 0 ]; then
            _test_usage "missing argument for parameter: $key" >&2
            return 1
        fi

        local value="$1"
        shift

        case "$key" in
            -d|--dir)
                tests_dir="$value"
                ;;
            -f|--filter)
                _test_pattern="$value"
                ;;
            *)
                _test_usage "unrecognized parameter: $key" >&2
                return 1
                ;;
        esac
    done

    tests_dir="$( realpath -e -- "$tests_dir" )"
}

_test_main() {
    _test_parse_args "$@"

    local -a test_files=()
    local test_file

    find "$tests_dir" \
        -mindepth 1 \
        -maxdepth 1 \
        -type f \
        -regex '.*/tst-.*\.sh$' \
        -regextype posix-basic \
        -name "$_test_pattern" \
        -printf '%P\0' \
        | sort -z \
        | \
    while IFS= read -d '' -r test_file; do
        test_files+=("$test_file")
    done

    _test_run_file ${test_files[@]+"${test_files[@]}"}
    _log_tests_summary
}

_test_main "$@"
