test_run() {
    local i
    for i in 1 2 3; do
        cat > "$test_root_dir/tst-$i.sh" <<EOF
test_run() {
    log "Hello from test #$i"
}
EOF
    done

    local output
    output="$( test_run_harness )"

    test_check_harness_log "$output" "tst-1.sh | Hello from test #1"
    test_check_harness_log "$output" "tst-2.sh | Hello from test #2"
    test_check_harness_log "$output" "tst-3.sh | Hello from test #3"
    test_check_harness_summary "$output" 3 0

    output="$( test_run_harness -f '*2*' )"

    test_check_harness_log "$output" "tst-2.sh | Hello from test #2"
    test_check_harness_summary "$output" 1 0
}
