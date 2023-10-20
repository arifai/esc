import 'dart:async';

import 'package:esc/src/commons.dart';

class AddCommand extends ESCCommand {
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
    final Map<String, dynamic> configs = {};

    if (argResults!.wasParsed('name')) {
      configs['name'] = argResults?['name'];
    }

    if (argResults!.wasParsed('host')) {
      configs['host'] = argResults?['host'];
    }

    if (argResults!.wasParsed('username')) {
      configs['username'] = argResults?['username'];
    }

    if (argResults!.wasParsed('password')) {
      configs['password'] = argResults?['password'];
    }

    if (argResults!.wasParsed('port')) {
      configs['port'] = int.tryParse(argResults?['port']);
    }

    writeConfig(
      name: configs['name'],
      host: configs['host'],
      username: configs['username'],
      password: configs['password'],
      port: configs['port'] ?? 22,
    );
  }
}
