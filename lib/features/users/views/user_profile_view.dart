// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_appwrite/common/error_text.dart';
// import 'package:flutter_web_appwrite/common/loading_page.dart';
import 'package:flutter_web_appwrite/constants/appwrite_contants.dart';
import 'package:flutter_web_appwrite/features/users/controllers/user_controllers.dart';
import 'package:flutter_web_appwrite/features/users/widgets/user_profile.dart';
import 'package:flutter_web_appwrite/models/user_model.dart';

class UserView extends ConsumerWidget {
  static route(UserModel userModel) => MaterialPageRoute(
    builder: (context) => UserView(
      userModel: userModel,
    ),
  );
  final UserModel userModel;
  const UserView({
    super.key,
    required this.userModel,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    UserModel copy0fUser = userModel;

    return Scaffold(
      body: ref.watch(getLatestUserProfileProvider).when(
        data: (data) {
          if (data.events.contains(
            'databases.*.collections.${AppWriteConstants.userCollection}.documents.${copy0fUser.uid}.update',
          )) {
            copy0fUser = UserModel.fromMap(data.payload);
          }
          return UserProfile(user: copy0fUser);
        }, 
        error: (error, stackTrace) => ErrorText(error: error.toString()), 
        loading: () {
          return UserProfile(user: copy0fUser);
        },
      ),
    );
  }
}