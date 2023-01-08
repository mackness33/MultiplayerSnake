abstract class DatabaseException implements Exception {}

class GenericDatabaseException implements DatabaseException {}

abstract class DatabaseGamesException implements Exception {}

class CouldNotFindGamesException implements DatabaseGamesException {}
