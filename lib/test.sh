# Copyright (c) 2026 Egor Tensin <egor@tensin.name>
# This file is part of the "test-harness" project.
# For details, see https://github.com/egor-tensin/test-harness
# Distributed under the MIT License.

test_should_fail=
test_root_dir=

test_setup_global() {
    test_root_dir="$( mktemp -d )"
}

test_cleanup_global() {
    if [ "$( type -t test_cleanup )" == function ]; then
        test_cleanup || true
    fi
    if [ -n "$test_root_dir" ]; then
        log "Removing test's root directory: $test_root_dir"
        rm -rf -- "$test_root_dir"
    fi
}
