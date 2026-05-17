class DatabaseException implements Exception {
  final String message;
  const DatabaseException(this.message);

  @override
  String toString() => 'DatabaseException: $message';
}

class UnknownException implements Exception {
  final String message;
  const UnknownException(this.message);

  @override
  String toString() => 'UnknownException: $message';
}
