test_run() {
    cat > "$test_root_dir/$test_file" <<'EOF'
test_run() {
    log "I'm a failure"
    false
}
EOF

    local output=
    output="$( test_run_harness )" || true

    test_check_harness_log "$output" "$test_file | I'm a failure"
    test_check_harness_summary "$output" 0 1
}
