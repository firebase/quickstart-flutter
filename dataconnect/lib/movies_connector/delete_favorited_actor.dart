part of movies_connector;

class DeleteFavoritedActorVariablesBuilder {
  String actorId;

  
  FirebaseDataConnect _dataConnect;
  
  DeleteFavoritedActorVariablesBuilder(this._dataConnect, {required String this.actorId,});
  Deserializer<DeleteFavoritedActorData> dataDeserializer = (dynamic json)  => DeleteFavoritedActorData.fromJson(jsonDecode(json));
  Serializer<DeleteFavoritedActorVariables> varsSerializer = (DeleteFavoritedActorVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<DeleteFavoritedActorData, DeleteFavoritedActorVariables>> execute() {
    return this.ref().execute();
  }
  MutationRef<DeleteFavoritedActorData, DeleteFavoritedActorVariables> ref() {
    DeleteFavoritedActorVariables vars=DeleteFavoritedActorVariables(actorId: actorId,);

    return _dataConnect.mutation("DeleteFavoritedActor", dataDeserializer, varsSerializer, vars);
  }
}


  class DeleteFavoritedActorFavoriteActorDelete {
  
   String userId;

  
   String actorId;

  
  
    
    
    
    DeleteFavoritedActorFavoriteActorDelete.fromJson(dynamic json):
        userId = 
 
    nativeFromJson<String>(json['userId'])
  

        
        ,
      
        actorId = 
 
    nativeFromJson<String>(json['actorId'])
  

        
        
       {
      
        
      
        
      
    }


  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    
      
      json['userId'] = 
  
    nativeToJson<String>(userId)
    
;
      
    
      
      json['actorId'] = 
  
    nativeToJson<String>(actorId)
    
;
      
    
    return json;
  }

  DeleteFavoritedActorFavoriteActorDelete({
    
      required this.userId,
    
      required this.actorId,
    
  });
}



  class DeleteFavoritedActorData {
  
   DeleteFavoritedActorFavoriteActorDelete? favorite_actor_delete;

  
  
    
    
    
    DeleteFavoritedActorData.fromJson(dynamic json):
        favorite_actor_delete = json['favorite_actor_delete'] == null ? null : 
 
    DeleteFavoritedActorFavoriteActorDelete.fromJson(json['favorite_actor_delete'])
  

        
        
       {
      
        
      
    }


  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    
      
        if (favorite_actor_delete != null) {
          json['favorite_actor_delete'] = 
  
      favorite_actor_delete!.toJson()
  
;
        }
      
    
    return json;
  }

  DeleteFavoritedActorData({
    
       this.favorite_actor_delete,
    
  });
}



  class DeleteFavoritedActorVariables {
  
   String actorId;

  
  
    
    
     @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
    
    
    DeleteFavoritedActorVariables.fromJson(Map<String, dynamic> json):
        actorId = 
 
    nativeFromJson<String>(json['actorId'])
  

        
        
       {
      
        
      
    }


  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    
      
      json['actorId'] = 
  
    nativeToJson<String>(actorId)
    
;
      
    
    return json;
  }

  DeleteFavoritedActorVariables({
    
      required this.actorId,
    
  });
}







