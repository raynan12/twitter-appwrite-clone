// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_web_appwrite/constants/assets_constants.dart';
import 'package:flutter_web_appwrite/features/explore/views/explore_view.dart';
import 'package:flutter_web_appwrite/features/notifications/views/notification_view.dart';
import 'package:flutter_web_appwrite/features/tweets/widgets/tweets_list.dart';
import 'package:flutter_web_appwrite/theme/pallete.dart';

class UIConstants {
  static AppBar appBar() {
    return AppBar(
      title: SvgPicture.asset(
        AssetsConstants.twitterLogo,
        color: Pallete.blueColor,
        height: 33,
      ),
      centerTitle: true,
    );
  }

  static List<Widget> bottomTabBarPages = [
    TweetList(),
    ExploreView(),
    NotificationView(),
  ];
}