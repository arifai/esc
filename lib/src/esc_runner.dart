import 'dart:io';

import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:esc/commands/add_command.dart';
import 'package:esc/commands/config_entity.dart';
import 'package:esc/commands/init_command.dart';
import 'package:esc/commands/list_command.dart';
import 'package:esc/src/commons.dart';
import 'package:io/ansi.dart';

final List<Command<void>> commands = [
  ListCommand(),
  AddCommand(),
  InitCommand(),
];

final class ESCRunner extends CommandRunner<void> {
  ESCRunner() : super('esc', 'Easy SSH Connection.') {
    commands.forEach(addCommand);
    argParser
      ..addFlag(
        'version',
        abbr: 'v',
        negatable: false,
        help: 'Display the application version.',
      )
      ..addFlag(
        'verbose',
        abbr: 'd',
        negatable: false,
        help: 'Show full stack trace on error (useful for debugging).',
      )
      ..addOption(
        'name',
        abbr: 'n',
        mandatory: true,
        valueHelp: 'ssh_name',
        help: 'Use your SSH name inside `$configFile` file.',
      );
  }

  @override
  Future<void> runCommand(topLevelResults) async {
    final ArgResults results = parse(topLevelResults.arguments);
    final bool version = results.wasParsed('version');
    final bool name = results.wasParsed('name');
    final bool verbose = results['verbose'] as bool;

    if (version) print('Version: 1.0.0');

    if (name) _runSsh('${results['name']}');

    try {
      await super.runCommand(results);
    } catch (e, s) {
      if (verbose) {
        print(e);
        print(s);
      }

      rethrow;
    }
  }

  void _runSsh(String? value) async {
    try {
      final List<ConfigEntity> configs = await readConfigFile();
      final ConfigEntity item =
          configs.firstWhere((e) => value != null && e.name.contains(value));

      print(yellow.wrap('Connecting to $value...'));
      connectSSH(
        username: item.username,
        host: item.host,
        port: item.port,
        password: item.password,
      );
    } on PathNotFoundException catch (e) {
      print(yellow.wrap('${e.osError?.message}. $warning'));
      exit(1);
    } catch (e) {
      print(red.wrap('No server with name $value.'));
      exit(2);
    }
  }
}
