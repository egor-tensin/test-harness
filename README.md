test-harness
============

[![CI](https://github.com/egor-tensin/test-harness/actions/workflows/ci.yml/badge.svg)](https://github.com/egor-tensin/test-harness/actions/workflows/ci.yml)

A simple bash-based harness for integration tests.

Used in a bunch of projects of mine, for example:

* [tag-release](https://github.com/egor-tensin/tag-release/tree/master/test)
* [config-links](https://github.com/egor-tensin/config-links/tree/master/test)
* [cgitize](https://github.com/egor-tensin/cgitize/tree/master/test/integration)

Integration
-----------

* Can be added as a submodule like so:

      > cd my/project/test
      > git submodule add https://github.com/egor-tensin/test-harness.git runner

    * Run tests using the `harness` script:

          > ./test/runner/harness

    * This will pick up all test files in "project/test/".

* Alternatively, check out this repo somewhere and use the `-d` parameter to
specify the path to the tests directory.

Usage
-----

* By default, all tests in the parent directory are run:

      ./test/runner/harness    # Runs all tests in the test/ directory

* You can filter tests to run using the `-f`/`--filter` parameter (uses
fnmatch(3)):

      ./test/runner/harness -f '*'          # Runs all tests still
      ./test/runner/harness -f '*label*'    # Collects all test files containing "label"

* Specify a directory to collect tests from using the `-d`/`--dir` parameter:

      ./harness -d path/to/tests/

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
