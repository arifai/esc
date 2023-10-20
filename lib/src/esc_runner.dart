import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:esc/commands/add_command.dart';
import 'package:esc/commands/config_entity.dart';
import 'package:esc/commands/list_command.dart';
import 'package:esc/src/commons.dart';
import 'package:io/ansi.dart';

final List<Command<void>> commands = [ListCommand(), AddCommand()];

class ESCRunner extends CommandRunner<void> {
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
    final bool version = topLevelResults.wasParsed('version');
    final bool name = topLevelResults.wasParsed('name');
    final bool verbose = topLevelResults['verbose'] as bool;

    if (version) print('Version: 1.0.0');

    if (name) _runSsh('${results['name']}');

    try {
      await super.runCommand(topLevelResults);
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
    } catch (e) {
      print(red.wrap('No server with name $value.'));
    }
  }
}
