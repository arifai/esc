import 'package:args/command_runner.dart';
import 'package:esc/esc.dart';
import 'package:io/ansi.dart';

void main(List<String> args) async {
  try {
    await run(args);
  } on UsageException catch (e) {
    print(red.wrap(e.message));
  }
}
