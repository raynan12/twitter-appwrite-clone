// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_web_appwrite/constants/assets_constants.dart';
import 'package:flutter_web_appwrite/core/enums/notification_type.dart';
import 'package:flutter_web_appwrite/models/notification_model.dart';
import 'package:flutter_web_appwrite/theme/pallete.dart';

class NotificationTile extends ConsumerWidget {
  final Notifications notifications;
  const NotificationTile({
    super.key,
    required this.notifications,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: notifications.notificationType == NotificationType.follow
        ? Icon(
            Icons.person,
            color: Pallete.blueColor,
        )
        : notifications.notificationType == NotificationType.like
          ? SvgPicture.asset(
            AssetsConstants.likeFilledIcon,
            color: Pallete.redColor,
            height: 20,
          )
        : notifications.notificationType == NotificationType.retweet
          ? SvgPicture.asset(
            AssetsConstants.retweetIcon,
            color: Pallete.whiteColor,
            height: 20,
          )
          : null,
      title: Text(notifications.text),
    );
  }
}