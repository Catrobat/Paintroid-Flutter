import 'package:logging/logging.dart';

mixin LoggableMixin {
  late final log = Logger(runtimeType.toString());
}