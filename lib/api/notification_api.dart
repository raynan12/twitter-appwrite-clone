// ignore_for_file: override_on_non_overriding_member

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_appwrite/constants/appwrite_contants.dart';
import 'package:flutter_web_appwrite/core/failure.dart';
import 'package:flutter_web_appwrite/core/providers.dart';
import 'package:flutter_web_appwrite/core/type_defs.dart';
import 'package:flutter_web_appwrite/models/notification_model.dart';
import 'package:fpdart/fpdart.dart';

final notificationAPIProvider = Provider((ref) {
  return NotificationAPI(
    db: ref.watch(appwriteDatabseProvider),
    realtime: ref.watch(appwriteRealtimeProvider)
  );
});

abstract class INotificationAPI {
  FutureEitherVoid createNotification(Notifications notification);
  Future<List<Document>> getNotifications(String uid);
  Stream<RealtimeMessage> getLatestNotification();
}

class NotificationAPI implements INotificationAPI {
  final Databases _db;
  final Realtime _realtime;
  NotificationAPI({
    required Databases db,
    required Realtime realtime,
  }) :
  _realtime = realtime, 
  _db = db;
  
  @override
  FutureEitherVoid createNotification(Notifications notification) async {
    try {
      await _db.updateDocument(
        databaseId: AppWriteConstants.databaseId, 
        collectionId: AppWriteConstants.notificationCollection, 
        documentId: ID.unique(), 
        data: notification.toMap(),
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
  Future<List<Document>> getNotifications(String uid) async {
    final documents = await _db.listDocuments(
      databaseId: AppWriteConstants.databaseId, 
      collectionId: AppWriteConstants.notificationCollection,
      queries: [
        Query.equal('uid', uid),
      ]
    );
    return documents.documents;
  }

  @override
  Stream<RealtimeMessage> getLatestNotification() {
    return _realtime.subscribe([
      'databases.${AppWriteConstants.databaseId}.collections.${AppWriteConstants.notificationCollection}.documents'
    ]).stream;
  }

}