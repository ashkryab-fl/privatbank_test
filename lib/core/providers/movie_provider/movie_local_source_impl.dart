import 'package:test_ashkryab/core/entity/movie.dart';
import 'package:test_ashkryab/core/providers/movie_provider/local_saver.dart';
import 'package:test_ashkryab/core/providers/movie_provider/movie_source.dart';
import 'package:test_ashkryab/core/sources/sql/sql_data_source.dart';

class MovieLocalProviderImpl implements MovieProvider, LocalSaver<List<Movie>> {
  MovieLocalProviderImpl._();

  static final MovieLocalProviderImpl _instance =
      MovieLocalProviderImpl._();

  factory MovieLocalProviderImpl() {
    return _instance;
  }

  static String sqlTableName = 'Movie';

  static String sqlTableSchema = '''
  CREATE TABLE $sqlTableName (
    adult INTEGER,
    backdropPath TEXT,
    id INTEGER PRIMARY KEY,
    originalLanguage TEXT,
    originalTitle TEXT,
    overview TEXT,
    popularity REAL,
    posterPath TEXT,
    releaseDate TEXT,
    title TEXT,
    video INTEGER,
    voteAverage REAL,
    voteCount INTEGER
  )
  ''';

  final SqlDataSource _sqlService = SqlDataSource();

  @override
  Future<List<Movie>> searchMovies(String query) async {
    return (await _sqlService.query(
            '''SELECT * FROM $sqlTableName WHERE LOWER(title) LIKE '%$query%' 
            ORDER BY popularity DESC 
            LIMIT ${MovieProvider.limit}'''))
        .map((e) => Movie.fromSql(e))
        .toList();
  }

  @override
  Future<List<Movie>> getMovies(int page) async {
    return (await _sqlService.query('''SELECT * FROM $sqlTableName 
            ORDER BY popularity DESC 
            LIMIT ${MovieProvider.limit} 
            OFFSET ${(page - 1) * MovieProvider.limit}'''))
        .map((e) => Movie.fromSql(e))
        .toList();
  }

  @override
  Future<Movie?> getById(String id) {
    return _sqlService
        .query('SELECT * FROM $sqlTableName WHERE id = $id')
        .then((value) => value.isNotEmpty ? Movie.fromSql(value.first) : null);
  }

  @override
  Future<bool> cache(List<Movie> value) async {
    _sqlService.insertAll(
        sqlTableName, value.map((e) => e.toSqlInsert()).toList());
    return true;
  }
}
