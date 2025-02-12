part of 'movies.dart';

class GetMovieInfoForUserVariablesBuilder {
  String movieId;

  final FirebaseDataConnect _dataConnect;
  GetMovieInfoForUserVariablesBuilder(this._dataConnect, {required  this.movieId,});
  Deserializer<GetMovieInfoForUserData> dataDeserializer = (dynamic json)  => GetMovieInfoForUserData.fromJson(jsonDecode(json));
  Serializer<GetMovieInfoForUserVariables> varsSerializer = (GetMovieInfoForUserVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<GetMovieInfoForUserData, GetMovieInfoForUserVariables>> execute() {
    return ref().execute();
  }

  QueryRef<GetMovieInfoForUserData, GetMovieInfoForUserVariables> ref() {
    GetMovieInfoForUserVariables vars= GetMovieInfoForUserVariables(movieId: movieId,);
    return _dataConnect.query("GetMovieInfoForUser", dataDeserializer, varsSerializer, vars);
  }
}

class GetMovieInfoForUserFavoriteMovie {
  String movieId;
  GetMovieInfoForUserFavoriteMovie.fromJson(dynamic json):
  movieId = nativeFromJson<String>(json['movieId']);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['movieId'] = nativeToJson<String>(movieId);
    return json;
  }

  GetMovieInfoForUserFavoriteMovie({
    required this.movieId,
  });
}

class GetMovieInfoForUserData {
  GetMovieInfoForUserFavoriteMovie? favorite_movie;
  GetMovieInfoForUserData.fromJson(dynamic json):
  favorite_movie = json['favorite_movie'] == null ? null : GetMovieInfoForUserFavoriteMovie.fromJson(json['favorite_movie']);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (favorite_movie != null) {
      json['favorite_movie'] = favorite_movie!.toJson();
    }
    return json;
  }

  GetMovieInfoForUserData({
    this.favorite_movie,
  });
}

class GetMovieInfoForUserVariables {
  String movieId;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  GetMovieInfoForUserVariables.fromJson(Map<String, dynamic> json):
  movieId = nativeFromJson<String>(json['movieId']);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['movieId'] = nativeToJson<String>(movieId);
    return json;
  }

  GetMovieInfoForUserVariables({
    required this.movieId,
  });
}

