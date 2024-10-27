class Movie {
  bool? adult;
  String? backdropPath;
  List<int>? genreIds;
  int? id;
  String? originalLanguage;
  String? originalTitle;
  String? overview;
  double? popularity;
  String? posterPath;
  String? releaseDate;
  String? title;
  bool? video;
  double? voteAverage;
  int? voteCount;

  Movie(
      {this.adult,
      this.backdropPath,
      this.genreIds,
      this.id,
      this.originalLanguage,
      this.originalTitle,
      this.overview,
      this.popularity,
      this.posterPath,
      this.releaseDate,
      this.title,
      this.video,
      this.voteAverage,
      this.voteCount});

  Movie.fromJson(Map<String, dynamic> json) {
    adult = json['adult'];
    backdropPath = json['backdrop_path'];
    genreIds = json['genre_ids'].cast<int>();
    id = json['id'];
    originalLanguage = json['original_language'];
    originalTitle = json['original_title'];
    overview = json['overview'];
    popularity = json['popularity'];
    posterPath = json['poster_path'];
    releaseDate = json['release_date'];
    title = json['title'];
    video = json['video'];
    voteAverage = json['vote_average'];
    voteCount = json['vote_count'];
  }

  Map<String, Object?> toJson() {
    final Map<String, Object?> data = <String, Object?>{};
    data['adult'] = adult;
    data['backdrop_path'] = backdropPath;
    data['genre_ids'] = genreIds;
    data['id'] = id;
    data['original_language'] = originalLanguage;
    data['original_title'] = originalTitle;
    data['overview'] = overview;
    data['popularity'] = popularity;
    data['poster_path'] = posterPath;
    data['release_date'] = releaseDate;
    data['title'] = title;
    data['video'] = video;
    data['vote_average'] = voteAverage;
    data['vote_count'] = voteCount;
    return data;
  }

  Map<String, Object?> toSqlInsert() {
    return {
      'adult': (adult ?? false) ? 1 : 0,
      'backdropPath': backdropPath,
      'genreIds': genreIds?.join(','),
      'id': id,
      'originalLanguage': originalLanguage,
      'originalTitle': originalTitle,
      'overview': overview,
      'popularity': popularity,
      'posterPath': posterPath,
      'releaseDate': releaseDate,
      'title': title,
      'video': (video ?? false) ? 1 : 0,
      'voteAverage': voteAverage,
      'voteCount': voteCount,
    };
  }

  factory Movie.fromSql(Map<String, dynamic> sql) {
    return Movie(
      adult: sql['adult'] == 1,
      backdropPath: sql['backdropPath'],
      id: sql['id'],
      originalLanguage: sql['originalLanguage'],
      originalTitle: sql['originalTitle'],
      overview: sql['overview'],
      popularity: sql['popularity'],
      posterPath: sql['posterPath'],
      releaseDate: sql['releaseDate'],
      title: sql['title'],
      video: sql['video'] == 1,
      voteAverage: sql['voteAverage'],
      voteCount: sql['voteCount'],
    );
  }

  @override
  int get hashCode => id.hashCode ^ title.hashCode ^ releaseDate.hashCode;



  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Movie &&
        other.id == id &&
        other.title == title &&
        other.releaseDate == releaseDate;
  }
}
