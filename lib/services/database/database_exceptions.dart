abstract class DatabaseException implements Exception {}

class GenericDatabaseException implements DatabaseException {}

class NoBasicTableException implements DatabaseException {}

abstract class DatabaseGamesException implements Exception {}

class CouldNotFindGameException implements DatabaseGamesException {}
