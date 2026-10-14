test-harness
============

A simple bash-based harness for integration tests.

Used in a bunch of projects of mine, for example:

* [tag-release](https://github.com/egor-tensin/tag-release/tree/master/test)
* [config-links](https://github.com/egor-tensin/config-links/tree/master/test)

Usage
-----

Supposed to be added as a submodule like so:

    > cd my/project/test
    > git submodule add https://github.com/egor-tensin/test-harness.git runner

This will add it as a submodule in `test/runner/` in your project's directory.

Run tests using the main.sh script:

    > ./test/runner/main.sh

The script will discover all your tests in the parent directory, run them and
print a short summary.

API
---

### Test structure

* All tests are stored in `tst-*.sh` files in the parent directory of the runner.
* All tests are `source`d by a bash script, so they must be bash code too.
* All tests must have the `test_run` function, which will be executed.
* All files in the "lib" subdirectory of the tests directory will be `source`d
independently for each test.
This allows maintaining a library of common routines.

### Global state

* The runner sets the following global variables:
    * `test_root_dir`: a temporary directory unique for each test.
A test can do whatever it wants in it; it'll get deleted after test's
completion.
    * `tests_dir`: the root directory with all the tests.
It can be used for relative paths.

### Hooks

* `test_run`: as mentioned above, this is the entry point for the test; do your
testing here.
* `test_cleanup`: optional; if present, it'll be run on test's completion.

### Logging

Some useful logging routines are provided for ease of use.

* `log`: prefixes lines with the test file's name, prints to stderr.
* `log_run`: `log`s the executable to be run along with its arguments in a
shell-ready format.
* `fail`: use this if your test assertion fails.
* `fail_details`: explain what's wrong.

### Failures

You can indicate that a test is expected to fail by setting the
`test_should_fail` variable to a non-empty string in the test file.
If such test's `test_run` function exits with anything but 0 then, it will
still count as a successful test run.

License
-------

Distributed under the MIT License.
See [LICENSE.txt] for details.

[LICENSE.txt]: LICENSE.txt
