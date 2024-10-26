class LocalException implements Exception {
  LocalException({
    required this.message,
    required this.arguments,
    required this.stackTrace,
  });

  LocalException.drift({
    required String remoteCause,
    required Type exceptionType,
    required StackTrace trace,
  })  : message = 'Drift error: $remoteCause',
        arguments = {'exceptionType': exceptionType},
        stackTrace = trace;

  LocalException.sqlite({
    required String message,
    required String causingStatement,
    required String explanation,
    required List<Object?> parametersToStatement,
    required StackTrace trace,
  })  : message = 'Sqlite error: $message',
        arguments = {
          'statement': causingStatement,
          'parameters': parametersToStatement,
          'explanation': explanation,
        },
        stackTrace = trace;

  LocalException.unknown({
    required Map<String, dynamic> args,
    required StackTrace trace,
  })  : message = 'Unknown error',
        arguments = args,
        stackTrace = trace;

  final String message;
  final Map<String, dynamic> arguments;
  final StackTrace stackTrace;

  @override
  String toString() {
    final buffer = StringBuffer()
      ..write('\nLocal Exception\n===============\n'
          '$message');

    if (arguments.isNotEmpty) {
      arguments.forEach((key, value) {
        buffer.write('$key: $value\n');
      });
    }
    buffer.write('$stackTrace');

    return buffer.toString();
  }
}
