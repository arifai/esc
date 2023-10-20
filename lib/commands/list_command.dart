import 'dart:async';

import 'package:esc/commands/config_entity.dart';
import 'package:esc/src/commons.dart';
import 'package:io/ansi.dart';

class ListCommand extends ESCCommand {
  @override
  String get name => 'ls';

  @override
  String get description =>
      'To listing all registered servers inside `$configFile` file.';

  @override
  FutureOr<void>? run() async => _lsCommand();

  void _lsCommand() async {
    final List<ConfigEntity> configs = await readConfigFile();

    print(green.wrap('Available registered servers: \n'));
    for (var conf in configs) {
      print(conf.name);
    }
  }
}
