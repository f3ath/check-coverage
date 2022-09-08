import 'package:check_coverage/src/range.dart';

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

  Iterable<Range> get uncoveredRanges => _uncovered
      .map(Range.single)
      .fold<List<Range>>([], (list, range) => list..merge(range));
}

extension _Merge on List<Range> {
  merge(Range range) {
    if (isNotEmpty && range.follows(last)) {
      replaceLast(range);
    } else {
      add(range);
    }
  }

  replaceLast(Range range) => this[length - 1] = Range(last.first, range.last);
}
