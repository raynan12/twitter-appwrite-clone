import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
// import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_appwrite/constants/appwrite_contants.dart';
import 'package:flutter_web_appwrite/core/failure.dart';
import 'package:flutter_web_appwrite/core/providers.dart';
import 'package:flutter_web_appwrite/core/type_defs.dart';
import 'package:flutter_web_appwrite/models/tweet_model.dart';
import 'package:fpdart/fpdart.dart';

final tweetAPIProvider = Provider((ref) {
  return TweetAPI(
    db: ref.watch(appwriteDatabseProvider),
    realtime: ref.watch(appwriteRealtimeProvider)
  );
});

abstract class ITweetAPI {
  FutureEither<Document> shareTweet(Tweet tweet);
  Future<List<Document>> getTweets();
  Stream<RealtimeMessage> getLatestTweet();
  FutureEither<Document> likeTweet(Tweet tweet);
  FutureEither<Document> uptadeReshareCount(Tweet tweet);
  Future<List<Document>> getRepliesToTweet(Tweet tweet);
  Future<Document> getTweetById(String id);
  Future<List<Document>> getUserTweets(String uid);
  Future<List<Document>> getTweetsByHashtag(String hashtag);
}

class TweetAPI implements ITweetAPI {
  final Databases _db;
  final Realtime _realtime;
  TweetAPI({
    required Databases db,
    required Realtime realtime,
  }) 
  : _db = db,
  _realtime = realtime;
  @override
  FutureEither<Document> shareTweet(Tweet tweet) async {
    try {
      final document = await _db.createDocument(
        databaseId: AppWriteConstants.databaseId, 
        collectionId: AppWriteConstants.tweetsCollection, 
        documentId: ID.unique(), 
        data: tweet.toMap(),
      );
      return right(document);
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
  Future<List<Document>> getTweets() async {
    final documents = await _db.listDocuments(
      databaseId: AppWriteConstants.databaseId, 
      collectionId: AppWriteConstants.tweetsCollection,
      queries: [
        Query.orderDesc('tweetedAt'),
      ]
    );
    return documents.documents;
  }
  
  @override
  Stream<RealtimeMessage> getLatestTweet() {
    return _realtime.subscribe([
      'databases.${AppWriteConstants.databaseId}.collections.${AppWriteConstants.tweetsCollection}.documents'
    ]).stream;
  }
  
  @override
  FutureEither<Document> likeTweet(Tweet tweet) async {
    try {
      final document = await _db.updateDocument(
        databaseId: AppWriteConstants.databaseId, 
        collectionId: AppWriteConstants.tweetsCollection, 
        documentId: tweet.id, 
        data: {
          'likes': tweet.likes,
        },
      );
      return right(document);
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
  FutureEither<Document> uptadeReshareCount(Tweet tweet) async {
    try {
      final document = await _db.updateDocument(
        databaseId: AppWriteConstants.databaseId, 
        collectionId: AppWriteConstants.tweetsCollection, 
        documentId: tweet.id, 
        data: {
          'reshareCount': tweet.reshareCount,
        },
      );
      return right(document);
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
  Future<List<Document>> getRepliesToTweet(Tweet tweet) async {
    final document = await _db.listDocuments(
      databaseId: AppWriteConstants.databaseId, 
      collectionId: AppWriteConstants.tweetsCollection,
      queries: [
        Query.equal('repliedTo', tweet.id),
      ],
    );
    return document.documents;
  }
  
  @override
  Future<Document> getTweetById(String id) async {
    return _db.getDocument(
      databaseId: AppWriteConstants.databaseId, 
      collectionId: AppWriteConstants.tweetsCollection, 
      documentId: id,
    );
  }
  
  @override
  Future<List<Document>> getUserTweets(String uid) async {
    final documents = await _db.listDocuments(
      databaseId: AppWriteConstants.databaseId, 
      collectionId: AppWriteConstants.tweetsCollection,
      queries: [
        Query.equal('uid', uid),
      ]
    );
    return documents.documents;
  }
  
  @override
  Future<List<Document>> getTweetsByHashtag(String hashtag) async {
    final documents = await _db.listDocuments(
      databaseId: AppWriteConstants.databaseId, 
      collectionId: AppWriteConstants.tweetsCollection,
      queries: [
        Query.equal('hashtags', hashtag),
      ]
    );
    return documents.documents;
  }
}