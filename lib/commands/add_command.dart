import 'dart:async';

import 'package:args/args.dart';
import 'package:esc/src/commons.dart';
import 'package:io/ansi.dart';

final class AddCommand extends ESCCommand {
  AddCommand() {
    argParser
      ..addOption(
        'name',
        abbr: 'N',
        mandatory: true,
        valueHelp: 'ssh_name',
        help: 'To provide your SSH name.',
      )
      ..addOption(
        'host',
        abbr: 'H',
        mandatory: true,
        valueHelp: 'ssh_host',
        help: 'To provide your SSH host or IP.',
      )
      ..addOption(
        'username',
        abbr: 'u',
        mandatory: true,
        valueHelp: 'ssh_username',
        help: 'To provide your SSH username.',
      )
      ..addOption(
        'password',
        abbr: 'p',
        mandatory: true,
        valueHelp: 'ssh_password',
        help: 'To provide your SSH password.',
      )
      ..addOption(
        'port',
        abbr: 'P',
        valueHelp: 'ssh_port',
        defaultsTo: '22',
        help: 'To provide your SSH port.',
      );
  }

  @override
  String get name => 'add';

  @override
  String get description => 'To add ESC configurations.';

  @override
  FutureOr<void>? run() async => _add();

  void _add() async {
    try {
      final ArgResults results = argParser.parse(argResults!.arguments);

      writeConfig(
        name: results['name'],
        host: results['host'],
        username: results['username'],
        password: results['password'],
        port: int.tryParse(results['port']) ?? 22,
      );
    } catch (e) {
      print(red.wrap('$e'));
    }
  }
}
