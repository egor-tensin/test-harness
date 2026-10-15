test_run() {
    cat > "$test_root_dir/$test_file" <<'EOF'
test_run() {
    log "I'm dumb"
}
EOF

    local output
    output="$( test_run_harness )"

    test_check_harness_log "$output" "$test_file | I'm dumb"
    test_check_harness_summary "$output" 1 0
}
