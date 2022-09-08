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

class FileCoverage {
  FileCoverage(this.name, Map<int, int> hits) {
    hits.entries.forEach((e) {
      (e.value > 0 ? _covered : _uncovered).add(e.key);
    });
  }

  final _covered = <int>{};
  final _uncovered = <int>{};

  final String name;

  int get linesCovered => _covered.length;

  int get linesUncovered => _uncovered.length;

  int get linesTotal => linesCovered + linesUncovered;

  Iterable<int> get uncovered => _uncovered;

  Iterable<Range> get uncoveredRanges =>
      _uncovered.map(Range.single).fold<List<Range>>(
          [],
          (list, range) => list.isNotEmpty && range.follows(list.last)
              ? [
                  ...list.sublist(0, list.length - 1),
                  Range(list.last.first, range.last)
                ]
              : [...list, range]);
}

class Range {
  final int first;
  final int last;

  Range(this.first, this.last);

  Range.single(int val) : this(val, val);

  bool follows(Range other) => first - 1 == other.last;

  @override
  String toString() => first == last ? '$first' : '$first-$last';
}
