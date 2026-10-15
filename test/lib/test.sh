test_run_harness() {
    "$tests_dir/../harness" -d "$test_root_dir" "$@" 2>&1
}

test_check_harness_log() {
    if [ "$#" -lt 1 ]; then
        log "usage: ${FUNCNAME[0]} LOG [STR...]"
        return 1
    fi

    local output="$1"
    shift

    local str
    for str; do
        log "Checking output log for line: $str"
        if ! echo "$output" | grep -F --line-regexp "$str" > /dev/null; then
            fail "Couldn't find the expected string: $str"
            return 1
        fi
    done
}

test_check_harness_summary() {
    if [ "$#" -ne 3 ]; then
        log "usage: ${FUNCNAME[0]} LOG N_OK N_FAILED"
        return 1
    fi

    local output="$1"
    local n_ok="$2"
    local n_failed="$3"

    log "Validating test summary..."

    test_check_harness_log "$output" "OK:   $n_ok"
    test_check_harness_log "$output" "FAIL: $n_failed"
}
