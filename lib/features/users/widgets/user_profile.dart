// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_web_appwrite/common/error_text.dart';
import 'package:flutter_web_appwrite/common/loading_page.dart';
import 'package:flutter_web_appwrite/constants/assets_constants.dart';
import 'package:flutter_web_appwrite/features/auth/controllers/auth_controllers.dart';
import 'package:flutter_web_appwrite/features/tweets/widgets/tweet_card.dart';
import 'package:flutter_web_appwrite/features/users/controllers/user_controllers.dart';
import 'package:flutter_web_appwrite/features/users/views/edit_profile_view.dart';
import 'package:flutter_web_appwrite/features/users/widgets/follow_button.dart';
import 'package:flutter_web_appwrite/models/user_model.dart';
import 'package:flutter_web_appwrite/theme/pallete.dart';

class UserProfile extends ConsumerWidget {
  final UserModel user;
  const UserProfile({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserDetailsProvider).value; 

    return currentUser == null ? Loader() : NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          SliverAppBar(
            expandedHeight: 150,
            floating: true,
            snap: true,
            flexibleSpace: Stack(
              children: [
                Positioned.fill(
                  child: user.bannerPic.isEmpty
                    ? Container(
                      color: Pallete.blueColor,
                    ) : Image.network(user.bannerPic, fit: BoxFit.fitWidth,)
                ),
                Positioned(
                  bottom: 0,
                  child: CircleAvatar(
                    backgroundImage: user.profilePic.isEmpty
                      ? NetworkImage('data:image/jpeg;base64,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')
                      : NetworkImage(
                        user.profilePic,
                      ),
                    radius: 45,
                  ),
                ),
                Container(
                  alignment: Alignment.bottomRight,
                  margin: EdgeInsets.all(20),
                  child: OutlinedButton(
                    onPressed: () {
                      if(currentUser.uid == user.uid) {
                        Navigator.push(context, EditProfile.route());
                      } else {
                        ref.read(userProfileControllerProvider.notifier)
                            .followUser(
                              user: user, 
                              context: context, 
                              currentUser: currentUser,
                          );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: Pallete.whiteColor,
                        ),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 25)
                    ), 
                    child: Text(
                      currentUser.uid == user.uid ?
                      'Edit Profile' 
                      : currentUser.following.contains(user.uid) ? 'Unfollow' : 'Follow',
                      style: TextStyle(
                        color: Pallete.whiteColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.all(8),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  Row(
                    children: [
                      Text(
                        user.name,
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if(user.isTwitterBlue)
                              Padding(
                                padding: const EdgeInsets.only(left: 3.0),
                                child: SvgPicture.asset(
                                  AssetsConstants.verifiedIcon,
                                ),
                              ),
                    ],
                  ),
                  Text(
                    '@${user.name}',
                    style: TextStyle(
                      fontSize: 17,
                      color: Pallete.greyColor,
                    ),
                  ),
                  Text(
                    user.bio,
                    style: TextStyle(
                      fontSize: 17,
                      color: Pallete.greyColor,
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      FollowCount(
                        count: user.following.length - 1, 
                        text: 'Following',
                      ),
                      SizedBox(width: 15),
                      FollowCount(
                        count: user.followers.length - 1, 
                        text: 'Followers',
                      ),
                    ],
                  ),
                  SizedBox(height: 2),
                  Divider(color: Pallete.whiteColor,)
                ],
              ),
            ),
          ),
        ];
      }, 
      body: ref.watch(getUserTweetsProvider(user.uid)).when(
        data: (tweets) {
          return ListView.builder(
            itemCount: tweets.length,
            itemBuilder: (BuildContext context, int index) {
              final tweet = tweets[index];
              return TweetCard(tweet: tweet);
            },
          );
        }, 
        error: (error, stackTrace) => ErrorText(error: error.toString()),
        loading: () => LoadingPage(),
      ),
    );
  }
}