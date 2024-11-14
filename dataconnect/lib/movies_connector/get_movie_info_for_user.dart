part of movies_connector;

class GetMovieInfoForUserVariablesBuilder {
  String movieId;

  
  FirebaseDataConnect _dataConnect;
  
  GetMovieInfoForUserVariablesBuilder(this._dataConnect, {required String this.movieId,});
  Deserializer<GetMovieInfoForUserData> dataDeserializer = (dynamic json)  => GetMovieInfoForUserData.fromJson(jsonDecode(json));
  Serializer<GetMovieInfoForUserVariables> varsSerializer = (GetMovieInfoForUserVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<GetMovieInfoForUserData, GetMovieInfoForUserVariables>> execute() {
    return this.ref().execute();
  }
  QueryRef<GetMovieInfoForUserData, GetMovieInfoForUserVariables> ref() {
    GetMovieInfoForUserVariables vars=GetMovieInfoForUserVariables(movieId: movieId,);

    return _dataConnect.query("GetMovieInfoForUser", dataDeserializer, varsSerializer, vars);
  }
}


  class GetMovieInfoForUserFavoriteMovie {
  
   String movieId;

  
  
    
    
    
    GetMovieInfoForUserFavoriteMovie.fromJson(dynamic json):
        movieId = 
 
    nativeFromJson<String>(json['movieId'])
  

        
        
       {
      
        
      
    }


  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    
      
      json['movieId'] = 
  
    nativeToJson<String>(movieId)
    
;
      
    
    return json;
  }

  GetMovieInfoForUserFavoriteMovie({
    
      required this.movieId,
    
  });
}



  class GetMovieInfoForUserWatchedMovie {
  
   String movieId;

  
  
    
    
    
    GetMovieInfoForUserWatchedMovie.fromJson(dynamic json):
        movieId = 
 
    nativeFromJson<String>(json['movieId'])
  

        
        
       {
      
        
      
    }


  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    
      
      json['movieId'] = 
  
    nativeToJson<String>(movieId)
    
;
      
    
    return json;
  }

  GetMovieInfoForUserWatchedMovie({
    
      required this.movieId,
    
  });
}



  class GetMovieInfoForUserData {
  
   GetMovieInfoForUserFavoriteMovie? favorite_movie;

  
   GetMovieInfoForUserWatchedMovie? watched_movie;

  
  
    
    
    
    GetMovieInfoForUserData.fromJson(dynamic json):
        favorite_movie = json['favorite_movie'] == null ? null : 
 
    GetMovieInfoForUserFavoriteMovie.fromJson(json['favorite_movie'])
  

        
        ,
      
        watched_movie = json['watched_movie'] == null ? null : 
 
    GetMovieInfoForUserWatchedMovie.fromJson(json['watched_movie'])
  

        
        
       {
      
        
      
        
      
    }


  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    
      
        if (favorite_movie != null) {
          json['favorite_movie'] = 
  
      favorite_movie!.toJson()
  
;
        }
      
    
      
        if (watched_movie != null) {
          json['watched_movie'] = 
  
      watched_movie!.toJson()
  
;
        }
      
    
    return json;
  }

  GetMovieInfoForUserData({
    
       this.favorite_movie,
    
       this.watched_movie,
    
  });
}



  class GetMovieInfoForUserVariables {
  
   String movieId;

  
  
    
    
     @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
    
    
    GetMovieInfoForUserVariables.fromJson(Map<String, dynamic> json):
        movieId = 
 
    nativeFromJson<String>(json['movieId'])
  

        
        
       {
      
        
      
    }


  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    
      
      json['movieId'] = 
  
    nativeToJson<String>(movieId)
    
;
      
    
    return json;
  }

  GetMovieInfoForUserVariables({
    
      required this.movieId,
    
  });
}







