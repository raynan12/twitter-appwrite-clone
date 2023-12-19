import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as model;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_appwrite/constants/appwrite_contants.dart';
import 'package:flutter_web_appwrite/core/failure.dart';
import 'package:flutter_web_appwrite/core/providers.dart';
import 'package:flutter_web_appwrite/core/type_defs.dart';
import 'package:flutter_web_appwrite/models/user_model.dart';
import 'package:fpdart/fpdart.dart';

final userAPIProvider = Provider((ref) {
  return UserAPI(
    db: ref.watch(appwriteDatabseProvider),
    realtime: ref.watch(appwriteRealtimeProvider), 
  );
});

abstract class IUserAPI {
  FutureEitherVoid saveUserData(UserModel userModel);
  Future<model.Document> getUserData(String uid);
  Future<List<model.Document>> searchUserByName(String name);
  FutureEitherVoid updateUserData(UserModel userModel);
  Stream<RealtimeMessage> getLatestUserProfileData();
  FutureEitherVoid followUser(UserModel userModel);
  FutureEitherVoid addToFollowing(UserModel user);
}

class UserAPI implements IUserAPI {
  final Databases _db;
  final Realtime _realTime;
  UserAPI({
    required Databases db,
    required Realtime realtime,
  }) : 
  _realTime = realtime,
  _db = db;
  
  @override
  FutureEitherVoid saveUserData(UserModel userModel) async {
    try {
      await _db.createDocument(
        databaseId: AppWriteConstants.databaseId, 
        collectionId: AppWriteConstants.userCollection, 
        documentId: userModel.uid, 
        data: userModel.toMap(),
      );
      return right(null);
    } on AppwriteException catch(e, st) {
      return left(
        Failure(
          e.message ?? 'Some unexpected error occurred', 
          st,
        ),
      );
    } catch (e, st) {
      return left(
        Failure(
          e.toString(), 
          st,
        ),
      );
    }
  }
  
  @override
  Future<model.Document> getUserData(String uid) {
    return _db.getDocument(
      databaseId: AppWriteConstants.databaseId, 
      collectionId: AppWriteConstants.userCollection, 
      documentId: uid,
    );
  }
  
  @override
  Future<List<model.Document>> searchUserByName(String name) async {
    final documents = await _db.listDocuments(
      databaseId: AppWriteConstants.databaseId, 
      collectionId: AppWriteConstants.userCollection,
      queries: [
        Query.search('name', name),
      ],
    );
    return documents.documents;
  }
  
  @override
  FutureEitherVoid updateUserData(UserModel userModel) async {
    try {
      await _db.updateDocument(
        databaseId: AppWriteConstants.databaseId, 
        collectionId: AppWriteConstants.userCollection, 
        documentId: userModel.uid, 
        data: userModel.toMap(),
      );
      return right(null);
    } on AppwriteException catch(e, st) {
      return left(
        Failure(
          e.message ?? 'Some unexpected error occurred', 
          st,
        ),
      );
    } catch (e, st) {
      return left(
        Failure(
          e.toString(), 
          st,
        ),
      );
    }
  }
  
  @override
  Stream<RealtimeMessage> getLatestUserProfileData() {
    return _realTime.subscribe([
      'databases.${AppWriteConstants.databaseId}.collections.${AppWriteConstants.userCollection}.documents'
    ]).stream;
  }
  
  @override
  FutureEitherVoid followUser(UserModel user) async {
    try {
      await _db.updateDocument(
        databaseId: AppWriteConstants.databaseId, 
        collectionId: AppWriteConstants.userCollection, 
        documentId: user.uid, 
        data: {
          'followers': user.followers,
        },
      );
      return right(null);
    } on AppwriteException catch(e, st) {
      return left(
        Failure(
          e.message ?? 'Some unexpected error occurred', 
          st,
        ),
      );
    } catch (e, st) {
      return left(
        Failure(
          e.toString(), 
          st,
        ),
      );
    }
  }
  
  @override
  FutureEitherVoid addToFollowing(UserModel user) async {
    try {
      await _db.updateDocument(
        databaseId: AppWriteConstants.databaseId, 
        collectionId: AppWriteConstants.userCollection, 
        documentId: user.uid, 
        data: {
          'following': user.following,
        },
      );
      return right(null);
    } on AppwriteException catch(e, st) {
      return left(
        Failure(
          e.message ?? 'Some unexpected error occurred', 
          st,
        ),
      );
    } catch (e, st) {
      return left(
        Failure(
          e.toString(), 
          st,
        ),
      );
    }
  }
}