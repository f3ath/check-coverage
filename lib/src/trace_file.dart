class TraceFile {
  static Future<TraceFile> readLines(Stream<String> lines) async {
    var name = '';
    final hits = <int, int>{};
    final files = <FileCoverage>[];

    await lines.forEach((line) {
      if (line.startsWith('SF:')) {
        name = line.substring(3);
      } else if (line.startsWith('DA:')) {
        final values = line.substring(3).split(',').map(int.parse).toList();
        hits[values.first] = values.last;
      } else if (line == 'end_of_record') {
        if (name.isEmpty) throw StateError('Unknown file name');
        if (hits.isEmpty) throw StateError('No coverage found for file $name');
        files.add(FileCoverage(name, hits));
        name = '';
        hits.clear();
      }
    });
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
}
