import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:args/command_runner.dart';
import 'package:dartssh2/dartssh2.dart';
import 'package:esc/commands/config_entity.dart';
import 'package:io/ansi.dart';
import 'package:yaml/yaml.dart';
import 'package:yaml_edit/yaml_edit.dart';

abstract class ESCCommand extends Command<void> {}

final String configDir = '$_homeDir/.esc';
final String configFile = 'esc-config.yaml';
final File file = File('$configDir/$configFile');

void connectSSH({
  required String username,
  required String host,
  required String password,
  int? port,
}) async {
  try {
    final SSHSocket socket = await SSHSocket.connect(host, port ?? 22);
    final SSHClient client = SSHClient(
      socket,
      username: username,
      onPasswordRequest: () {
        stdin.echoMode = false;

        return password;
      },
    );
    final SSHSession shell = await client.shell(
      pty: SSHPtyConfig(width: 100, height: 50),
    );

    stdin.echoMode = true;

    stdout.addStream(shell.stdout);
    stderr.addStream(shell.stderr);
    stdin.cast<Uint8List>().listen(shell.write);

    await shell.done;
    client.close();
    await client.done;

    exit(0);
  } on SocketException catch (e) {
    print(red.wrap('${e.message} (${e.address?.address})'));
    exit(1);
  } catch (e) {
    print('$e');
    print(
      red.wrap('Can not connect to SSH server, please check your credential.'),
    );
    exit(1);
  }
}

String? get _homeDir {
  final Map<String, String> envVars = Platform.environment;

  switch (Platform.operatingSystem) {
    case 'macos':
    case 'linux':
      return envVars['HOME'];
    case 'windows':
      return envVars['USERPROFILE'];
    default:
      return null;
  }
}

Future<void> ensureConfigDir() async {
  final Directory dir = Directory(configDir);
  final File file = File('$configDir/$configFile');

  if (!await dir.exists()) {
    await dir.create();
    if (!await file.exists()) await file.create();
  } else {
    await file.create();
  }
}

Future<List<ConfigEntity>> readConfigFile() async {
  try {
    final String yamlString = file.readAsStringSync();
    final YamlMap doc = loadYaml(yamlString);
    final List<ConfigEntity> configs = ConfigEntity.encode(doc);

    return configs;
  } catch (e) {
    rethrow;
  }
}

void writeConfig({
  required String name,
  required String host,
  required String username,
  required String password,
  int? port,
}) async {
  try {
    final YamlEditor editor = YamlEditor(file.readAsStringSync());
    editor.update([
      'configs'
    ], [
      {
        'name': name,
        'host': host,
        'username': username,
        'password': password,
        'port': port,
      }
    ]);

    await file.writeAsString(
      editor.edits.first.replacement,
      mode: FileMode.append,
      flush: true,
    );
  } catch (e) {
    print(red.wrap('Can not add configuration with error: $e'));
    exit(1);
  }
}
