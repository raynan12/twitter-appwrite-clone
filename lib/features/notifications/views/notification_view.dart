import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_appwrite/common/error_text.dart';
import 'package:flutter_web_appwrite/common/loading_page.dart';
import 'package:flutter_web_appwrite/constants/appwrite_contants.dart';
import 'package:flutter_web_appwrite/features/auth/controllers/auth_controllers.dart';
import 'package:flutter_web_appwrite/features/notifications/controller/notification_controller.dart';
import 'package:flutter_web_appwrite/features/notifications/widgets/notifications_tile.dart';
import 'package:flutter_web_appwrite/models/notification_model.dart';
// import 'package:flutter_web_appwrite/features/tweets/widgets/tweet_card.dart';

class NotificationView extends ConsumerWidget {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserDetailsProvider).value;

    return Scaffold(
      body: currentUser == null ? Loader() : ref.watch(getNotificationProvider(currentUser.uid)).when(
            data: (notifications) {
              return ref.watch(getLatestNotificationProvider).when(
                data: (data) {
                  
                    if(data.events.contains(
                    'databases.*.collections.${AppWriteConstants.notificationCollection}.documents.*.create',
                  )) {
                    final latesNotif = Notifications.fromMap(data.payload);
                    if(latesNotif.uid == currentUser.uid) {
                      notifications.insert(0, latesNotif);
                    }
                  } 
                
                  return ListView.builder(
                    itemCount: notifications.length,
                    itemBuilder: (BuildContext context, int index) {
                      final notofication = notifications[index];
                      return NotificationTile(notifications: notofication);
                    },
                  );
                }, 
                error: (error, stackTrace) => ErrorText(
                  error: error.toString(),
                ), 
                loading: () {
                  return ListView.builder(
                  itemCount: notifications.length,
                  itemBuilder: (BuildContext context, int index) {
                    final notofication = notifications[index];
                    return NotificationTile(notifications: notofication);
                  },
                                );
                },
              );
              
            }, 
            error: (error, stackTrace) => ErrorText(
              error: error.toString(),
            ), 
            loading: () => Loader(),
          ),
    );
  }
}