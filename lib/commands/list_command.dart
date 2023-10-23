import 'dart:async';
import 'dart:io';

import 'package:esc/commands/config_entity.dart';
import 'package:esc/src/commons.dart';
import 'package:io/ansi.dart';

final class ListCommand extends ESCCommand {
  @override
  String get name => 'ls';

  @override
  String get description =>
      'To listing all registered servers inside `$configFile` file.';

  @override
  FutureOr<void>? run() async => _lsCommand();

  void _lsCommand() async {
    try {
      final List<ConfigEntity> configs = await readConfigFile();

      print(green.wrap('Available registered servers:\n'));
      for (var conf in configs) {
        print(conf.name);
      }
    } on PathNotFoundException catch (e) {
      print(yellow.wrap('${e.osError?.message}. $warning'));
      exit(1);
    } catch (e) {
      print(red.wrap('$e'));
      exit(2);
    }
  }
}
