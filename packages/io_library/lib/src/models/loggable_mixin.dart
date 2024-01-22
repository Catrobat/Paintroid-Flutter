import 'package:logging/logging.dart';

mixin LoggableMixin {
  late final logger = Logger(runtimeType.toString());
}
