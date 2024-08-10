# check-coverage
A tiny Dart CLI tool to check if code coverage is below the threshold.

Pass the content of the trace file (lcov) as the input. Provide the desired coverage as the argument.

Example usage in a Dart project:
```
dart test --coverage=.coverage
format_coverage -l -c -i .coverage --report-on=lib | check_coverage 98
```
The first line runs the tests placing the coverage report in the `.coverage` folder.
The second line produces a combined lcov coverage and passes it to the tool requiring at least 98% coverage.

The tool will exit normally if the coverage is at or above the threshold. 
Otherwise, it will set the exit status to 1 and print the top 3 uncovered files.