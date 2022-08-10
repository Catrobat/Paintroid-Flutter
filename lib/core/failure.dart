abstract class Failure {
  const Failure(this.message);

  final String message;

  @override
  String toString() => '$runtimeType{message: $message}';
}
