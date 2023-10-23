import 'package:equatable/equatable.dart';
import 'package:yaml/yaml.dart';

final class ConfigEntity extends Equatable {
  const ConfigEntity({
    required this.name,
    required this.username,
    required this.host,
    required this.password,
    required this.port,
  });

  final String name;
  final String username;
  final String host;
  final String password;
  final int port;

  factory ConfigEntity._encode(YamlMap doc) {
    if (doc
        case {
          'name': String name,
          'username': String username,
          'host': String host,
          'password': String password,
          'port': int port
        }) {
      return ConfigEntity(
        name: name,
        username: username,
        host: host,
        password: password,
        port: port,
      );
    } else {
      throw FormatException('Invalid YAML format $doc');
    }
  }

  static List<ConfigEntity> encode(YamlMap docs) {
    return List<ConfigEntity>.from(
      docs['configs'].map((e) => ConfigEntity._encode(e)),
    );
  }

  @override
  List<Object?> get props => [name, username, host, password, port];
}
