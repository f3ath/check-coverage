import 'dart:convert';
import 'dart:io';

import 'package:check_coverage/src/trace_file.dart';

Future<void> main(List<String> args) async {
  try {
    final lines = stdin.transform(utf8.decoder).transform(const LineSplitter());
    final traceFile = await TraceFile.readLines(lines);
    final expected = args.isEmpty ? 100 : num.parse(args.first);
    final coverage = (100 * traceFile.coveredRatio).floor();
    if (coverage < expected) {
      stderr.writeln(
          'Total coverage of $coverage% is below expected $expected%.');
      stderr.writeln('Top uncovered files:');
      traceFile.uncovered.take(3).forEach((file) {
        stderr.writeln(file.name);
        stderr.writeln(
            'Lines (${file.uncovered.length}): ${file.uncoveredRanges.join(', ')}');
      });

      exit(1);
    }
  } on Object catch (e) {
    stderr.writeln(e);
    exit(128);
  }
}
