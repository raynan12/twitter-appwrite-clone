// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_appwrite/common/loading_page.dart';
import 'package:flutter_web_appwrite/features/auth/controllers/auth_controllers.dart';
import 'package:flutter_web_appwrite/features/users/controllers/user_controllers.dart';
import 'package:flutter_web_appwrite/features/users/views/user_profile_view.dart';

class SideDrawer extends ConsumerWidget {
  const SideDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserDetailsProvider).value;

    if(currentUser == null) {
      return Loader();
    }

    return SafeArea(
      child: Drawer(
        backgroundColor: Colors.black,
        child: Column(
          children: [
            SizedBox(height: 50),
            ListTile(
              leading: Icon(
                Icons.person,
                size: 30,
              ),
              title: Text(
                'My Profile',
                style: TextStyle(
                  fontSize: 22,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context, 
                  UserView.route(currentUser),
                );
              },
            ),
            ListTile(
              leading: Icon(
                Icons.payment,
                size: 30,
              ),
              title: Text(
                'Twitter Blue',
                style: TextStyle(
                  fontSize: 22,
                ),
              ),
              onTap: () {
                ref.read(userProfileControllerProvider.notifier)
                  .updateUserProfile(
                    userModel: currentUser.copyWith(isTwitterBlue: true), 
                    context: context, 
                    bannerFile: null, 
                    profileFile: null,
                  );
              },
            ),
            ListTile(
              leading: Icon(
                Icons.logout,
                size: 30,
              ),
              title: Text(
                'Log out',
                style: TextStyle(
                  fontSize: 22,
                ),
              ),
              onTap: () {
                ref.read(authControllerProvider.notifier).logout(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}