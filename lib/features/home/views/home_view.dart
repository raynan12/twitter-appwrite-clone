// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_final_fields, unused_field

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_web_appwrite/constants/assets_constants.dart';
import 'package:flutter_web_appwrite/constants/ui_constants.dart';
import 'package:flutter_web_appwrite/features/home/widgets/side_drawer.dart';
// import 'package:flutter_web_appwrite/features/auth/controllers/auth_controllers.dart';
import 'package:flutter_web_appwrite/features/tweets/views/create_tweet.dart';
import 'package:flutter_web_appwrite/theme/pallete.dart';

class HomeView extends ConsumerStatefulWidget {
  static route() => MaterialPageRoute(
    builder: (context) => HomeView(),
  );
  const HomeView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  int _page = 0;
  final appbar = UIConstants.appBar();

  void onPageChange(int index) {
    setState(() {
      _page = index;
    });
  }

  onCreateTweet() {
    Navigator.push(
      context, 
      CreateTweet.route(),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: _page == 0 ? appbar : null,
      body: IndexedStack(
        index: _page,
        children: UIConstants.bottomTabBarPages,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: onCreateTweet,
        child: Icon(
          Icons.add,
          color: Pallete.whiteColor,
          size: 28,
        ),
      ),
      drawer: SideDrawer(),
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: _page,
        onTap: onPageChange,
        backgroundColor: Pallete.backgroundColor,
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              _page == 0 
              ? AssetsConstants.homeFilledIcon
              : AssetsConstants.homeOutlinedIcon,
              color: Pallete.whiteColor,
            ),
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              _page == 1 
              ? AssetsConstants.searchIcon
              : AssetsConstants.searchIcon,
              color: Pallete.whiteColor,
            ),
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              _page == 2 
              ? AssetsConstants.notifFilledIcon
              : AssetsConstants.notifOutlinedIcon,
              color: Pallete.whiteColor,
            ),
          ),
        ],
      ),
    );
  }
}