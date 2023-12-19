// ignore_for_file: unused_local_variable

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_appwrite/api/notification_api.dart';
import 'package:flutter_web_appwrite/core/enums/notification_type.dart';
import 'package:flutter_web_appwrite/models/notification_model.dart' as model;

final notificationControllerProvider = StateNotifierProvider<NotificationController, bool>((ref) {
  return NotificationController(
    notificationAPI: ref.watch(notificationAPIProvider),
  ); 
});

final getLatestNotificationProvider = StreamProvider((ref) {
  final notificationAPI = ref.watch(notificationAPIProvider);
  return notificationAPI.getLatestNotification();
});

final getNotificationProvider = FutureProvider.family((ref, String uid) async {
  final notificationController = ref.watch(notificationControllerProvider.notifier);
  return notificationController.getNotifications(uid);
});

class NotificationController extends StateNotifier<bool> {
  final NotificationAPI _notificationAPI;
  NotificationController({
    required NotificationAPI notificationAPI
  }) : _notificationAPI = notificationAPI, super(false);

  void createNotification({
    required String text,
    required String postId,
    required NotificationType notificationType,
    required String uid,
  }) async {
    final notification = model.Notifications(
      text: text, 
      postId: postId, 
      id: '', 
      uid: uid, 
      notificationType: notificationType,
    );
    final res = await _notificationAPI.createNotification(notification);
  }
  Future<List<model.Notifications>> getNotifications(String uid) async {
    final notifications = await _notificationAPI.getNotifications(uid);
    return notifications.map((e) => model.Notifications.fromMap(e.data)).toList();
  }
}