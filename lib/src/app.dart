import 'package:check_coverage/src/trace_file.dart';

Future<int> app(List<String> args, Stream<String> lines,
    Function([Object? object]) writeln) async {
  final traceFile = await TraceFile.readLines(lines);
  final expected = args.isEmpty ? 100 : num.parse(args.first);
  final coverage = (100 * traceFile.coveredRatio).floor();
  if (coverage >= expected) return 0;
  writeln('Total coverage of $coverage% is below expected $expected%.');
  writeln('Top uncovered files:');
  traceFile.uncovered.take(10).forEach((file) {
    writeln(file.name);
    writeln(
        'Lines (${file.uncovered.length}): ${file.uncoveredRanges.join(', ')}');
  });
  return 1;
}
