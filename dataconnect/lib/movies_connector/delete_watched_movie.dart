part of movies_connector;

class DeleteWatchedMovieVariablesBuilder {
  String movieId;

  
  FirebaseDataConnect _dataConnect;
  
  DeleteWatchedMovieVariablesBuilder(this._dataConnect, {required String this.movieId,});
  Deserializer<DeleteWatchedMovieData> dataDeserializer = (dynamic json)  => DeleteWatchedMovieData.fromJson(jsonDecode(json));
  Serializer<DeleteWatchedMovieVariables> varsSerializer = (DeleteWatchedMovieVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<DeleteWatchedMovieData, DeleteWatchedMovieVariables>> execute() {
    return this.ref().execute();
  }
  MutationRef<DeleteWatchedMovieData, DeleteWatchedMovieVariables> ref() {
    DeleteWatchedMovieVariables vars=DeleteWatchedMovieVariables(movieId: movieId,);

    return _dataConnect.mutation("DeleteWatchedMovie", dataDeserializer, varsSerializer, vars);
  }
}


  class DeleteWatchedMovieWatchedMovieDelete {
  
   String userId;

  
   String movieId;

  
  
    
    
    
    DeleteWatchedMovieWatchedMovieDelete.fromJson(dynamic json):
        userId = 
 
    nativeFromJson<String>(json['userId'])
  

        
        ,
      
        movieId = 
 
    nativeFromJson<String>(json['movieId'])
  

        
        
       {
      
        
      
        
      
    }


  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    
      
      json['userId'] = 
  
    nativeToJson<String>(userId)
    
;
      
    
      
      json['movieId'] = 
  
    nativeToJson<String>(movieId)
    
;
      
    
    return json;
  }

  DeleteWatchedMovieWatchedMovieDelete({
    
      required this.userId,
    
      required this.movieId,
    
  });
}



  class DeleteWatchedMovieData {
  
   DeleteWatchedMovieWatchedMovieDelete? watched_movie_delete;

  
  
    
    
    
    DeleteWatchedMovieData.fromJson(dynamic json):
        watched_movie_delete = json['watched_movie_delete'] == null ? null : 
 
    DeleteWatchedMovieWatchedMovieDelete.fromJson(json['watched_movie_delete'])
  

        
        
       {
      
        
      
    }


  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    
      
        if (watched_movie_delete != null) {
          json['watched_movie_delete'] = 
  
      watched_movie_delete!.toJson()
  
;
        }
      
    
    return json;
  }

  DeleteWatchedMovieData({
    
       this.watched_movie_delete,
    
  });
}



  class DeleteWatchedMovieVariables {
  
   String movieId;

  
  
    
    
     @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
    
    
    DeleteWatchedMovieVariables.fromJson(Map<String, dynamic> json):
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

  DeleteWatchedMovieVariables({
    
      required this.movieId,
    
  });
}







