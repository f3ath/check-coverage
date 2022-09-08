import 'package:check_coverage/src/file_coverage.dart';
import 'package:lcov_tracefile/lcov_tracefile.dart';

class TraceFile {
  static Future<TraceFile> readLines(Stream<String> lines) async {
    final tracefile = readTracefile(await lines.toList());
    final files = tracefile.sources
        .map((source) => FileCoverage(
            source.name,
            Map.fromEntries(source.lines.coverage
                .map((coverage) => MapEntry(coverage.line, coverage.count)))))
        .toList();

    if (files.isEmpty) throw StateError('No coverage found');
    return TraceFile._(files);
  }

  TraceFile._(this._files)
      : totalLines = _files
            .map((e) => e.linesTotal)
            .reduce((value, element) => value + element),
        totalCovered = _files
            .map((e) => e.linesCovered)
            .reduce((value, element) => value + element) {
    _files.sort((a, b) => b.linesUncovered - a.linesUncovered);
  }

  final List<FileCoverage> _files;

  final int totalLines;
  final int totalCovered;

  num get coveredRatio => totalCovered / totalLines;

  Iterable<FileCoverage> get uncovered =>
      _files.where((e) => e.linesUncovered > 0);
}
