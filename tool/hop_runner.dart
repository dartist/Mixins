library hop_runner;

import 'dart:async';
import 'dart:io';
import 'package:bot/bot.dart';
import 'package:hop/hop.dart';
import 'package:hop/hop_tasks.dart';

void main() {

  addTask('test', createProcessTask('dart', args: ['test/MixinTestSuite.dart'],
      description: 'DUnit test'));

  addTask('analyze_libs', createDartAnalyzerTask(_getLibs));

  runHop();
}

Future<List<String>> _getLibs() {
  return new Directory('lib').list()
      .where((FileSystemEntity fse) => fse is File)
      .map((File file) => file.path)
      .toList();
}
