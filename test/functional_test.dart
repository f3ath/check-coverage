import 'dart:convert';
import 'dart:io';

import 'package:test/test.dart';

Future<void> main() async {
  test('Terminates successfully', () async {
    final proc = await Process.start('dart', ['bin/check_coverage.dart', '90']);
    await File('test/cov.lcov')
        .openRead()
        .transform(utf8.decoder)
        .transform(const LineSplitter())
        .forEach(proc.stdin.writeln);
    await proc.stdin.close();

    expect(await proc.exitCode, 0);
  });

  test('Coverage below expected', () async {
    final proc = await Process.start('dart', ['bin/check_coverage.dart']);
    await File('test/cov.lcov')
        .openRead()
        .transform(utf8.decoder)
        .transform(const LineSplitter())
        .forEach(proc.stdin.writeln);
    await proc.stdin.close();

    expect(await proc.exitCode, 1);
    expect(
        await proc.stderr
            .transform(utf8.decoder)
            .transform(const LineSplitter())
            // .take(1)
            .join('\n'),
        equals([
          'Total coverage of 91% is below expected 100%.',
          'Top uncovered files:',
          '/home/f3ath/project/marker/lib/flavors.dart',
          'Lines (12): 36-38, 40-42, 45-49, 51',
          '/home/f3ath/project/marker/lib/ast.dart',
          'Lines (1): 116',
          '/home/f3ath/project/marker/lib/src/flavors/changelog.dart',
          'Lines (1): 10',
        ].join('\n')));
  });

  test('Coverage not found', () async {
    final proc = await Process.start('dart', ['bin/check_coverage.dart']);
    await proc.stdin.close();

    expect(await proc.exitCode, 128);
    expect(
        await proc.stderr
            .transform(utf8.decoder)
            .transform(const LineSplitter())
            .take(1)
            .join(),
        'Bad state: No coverage found');
  });
}
