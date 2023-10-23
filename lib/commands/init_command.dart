import 'dart:async';

import 'package:esc/src/commons.dart';

final class InitCommand extends ESCCommand {
  @override
  String get name => 'init';
  @override
  String get description => 'To initialize configuration file.';

  @override
  FutureOr<void>? run() => ensureConfigDir();
}
