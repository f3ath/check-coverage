Example usage in a Dart project:
```
dart test --coverage=.coverage
format_coverage -l -c -i .coverage --report-on=lib | check_coverage 98
```
The first line runs the tests placing the coverage report in the `.coverage` folder.
The second line produces a combined lcov coverage and passes it to the tool requiring at least 98% coverage.

The tool will exit normally if the coverage is at or above the threshold.
Otherwise, it will set the exit status to 1 and list the least covered files.