// ignore_for_file: unused_field

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_appwrite/api/storage_api.dart';
import 'package:flutter_web_appwrite/api/tweet_api.dart';
import 'package:flutter_web_appwrite/api/user_api.dart';
import 'package:flutter_web_appwrite/core/enums/notification_type.dart';
import 'package:flutter_web_appwrite/core/utils.dart';
// import 'package:flutter_web_appwrite/features/notifications/controller/notification_controller.dart';
// import 'package:flutter_web_appwrite/api/user_api.dart';
import 'package:flutter_web_appwrite/models/tweet_model.dart';
import 'package:flutter_web_appwrite/models/user_model.dart';

import '../../notifications/controller/notification_controller.dart';
// import 'package:flutter_web_appwrite/models/user_model.dart';

final userProfileControllerProvider = StateNotifierProvider<UserProfileController, bool>((ref) {
  return UserProfileController(
    tweetAPI: ref.watch(tweetAPIProvider),
    storageAPI: ref.watch(storageAPIProvider),
    userAPI: ref.watch(userAPIProvider),
    notificationController: ref.watch(notificationControllerProvider.notifier)
  );
});

final getUserTweetsProvider = FutureProvider.family((ref, String uid) async {
  final userProfileController = ref.watch(userProfileControllerProvider.notifier);
  return userProfileController.getUserTweet(uid);
});

final getLatestUserProfileProvider = StreamProvider((ref) {
  final userAPI = ref.watch(userAPIProvider);
  return userAPI.getLatestUserProfileData();
});

class UserProfileController extends StateNotifier<bool> {
  final TweetAPI _tweetAPI;
  final StorageAPI _storageAPI;
  final UserAPI _userAPI;
    final NotificationController _notificationController;
  UserProfileController({
    required StorageAPI storageAPI,
    required TweetAPI tweetAPI,
    required UserAPI userAPI,
    required NotificationController notificationController,
  }) : 
  _storageAPI = storageAPI,
  _tweetAPI = tweetAPI, 
  _userAPI = userAPI,
  _notificationController = notificationController,
  super(false);

  Future<List<Tweet>> getUserTweet(String uid) async {
    final tweets = await _tweetAPI.getUserTweets(uid);
    return tweets.map((e) => Tweet.fromMap(e.data)).toList();
  }

  void updateUserProfile({
    required UserModel userModel,
    required BuildContext context,
    required File? bannerFile,
    required File? profileFile,
  }) async {
    state = true;
    if(bannerFile != null) {
      final bannerUrl = await _storageAPI.uploadImage([bannerFile]);
      userModel = userModel.copyWith(
        bannerPic: bannerUrl[0],
      );
    }

    if(profileFile != null) {
      final profileUrl = await _storageAPI.uploadImage([profileFile]);
      userModel = userModel.copyWith(
        bannerPic: profileUrl[0],
      );
    }

    final res = await _userAPI.updateUserData(userModel);
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message), 
      (r) => Navigator.pop(context),
    );
  }

  void followUser({
    required UserModel user,
    required BuildContext context,
    required UserModel currentUser
  }) async {
    if(currentUser.following.contains(user.uid)) {
      user.followers.remove(currentUser.uid);
      currentUser.following.remove(user.uid);
    } else {
      user.followers.add(currentUser.uid);
      currentUser.following.add(user.uid);
    }

    user = user.copyWith(followers: user.followers);
    currentUser = currentUser.copyWith(
      following: currentUser.following,
    );
  
    final res = await  _userAPI.followUser(user);
    res.fold((l) => showSnackBar(context, l.message), (r) async {
      final res2 = await _userAPI.addToFollowing(currentUser);
      res2.fold((l) => showSnackBar(context, l.message), (r) {
         _notificationController.createNotification(
          text: '${currentUser.name} followed you', 
          postId: '', 
          notificationType: NotificationType.follow, 
          uid: user.uid,
        );
      });
    });
  }

}