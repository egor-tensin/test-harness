test_run() {
    mkdir -- "$test_root_dir/lib"
    cat > "$test_root_dir/lib/foo.sh" <<'EOF'
test_foo() {
    log foo
}

test_bar() {
    log bar
}
EOF
    cat > "$test_root_dir/lib/baz.sh" <<'EOF'
test_baz() {
    log baz
}
EOF

    cat > "$test_root_dir/$test_file" <<'EOF'
test_run() {
    test_foo
    test_bar
    test_baz
}
EOF

    local output
    output="$( test_run_harness )"

    test_check_harness_log "$output" "$test_file | foo"
    test_check_harness_log "$output" "$test_file | bar"
    test_check_harness_log "$output" "$test_file | baz"

    test_check_harness_summary "$output" 1 0
}
