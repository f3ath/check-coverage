import 'dart:convert';
import 'dart:io';

import 'package:check_coverage/src/app.dart';

Future<void> main(List<String> args) async {
  try {
    final lines = stdin.transform(utf8.decoder).transform(const LineSplitter());
    final code = await app(args, lines, stderr.writeln);
    exit(code);
  } on Object catch (e) {
    stderr.writeln(e);
    exit(128);
  }
}
