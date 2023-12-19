// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_web_appwrite/common/loading_page.dart';
import 'package:flutter_web_appwrite/common/rounded_small_button.dart';
import 'package:flutter_web_appwrite/constants/assets_constants.dart';
import 'package:flutter_web_appwrite/core/utils.dart';
import 'package:flutter_web_appwrite/features/auth/controllers/auth_controllers.dart';
import 'package:flutter_web_appwrite/features/tweets/controller/tweet_controller.dart';
import 'package:flutter_web_appwrite/theme/pallete.dart';

class CreateTweet extends ConsumerStatefulWidget {
  static route() => MaterialPageRoute(
    builder: (context) => CreateTweet(),
  );
  const CreateTweet({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CreateTweetState();
}

class _CreateTweetState extends ConsumerState<CreateTweet> {
  final TextEditingController tweetTextController = TextEditingController();
  List<File> images = [];

  @override
  void dispose() {
    super.dispose();
    tweetTextController.dispose();
  }

  void shareTweet() {
    ref.read(tweetControllerProvider.notifier).shareTweet(
      images: images, 
      text: tweetTextController.text, 
      context: context,
      repliedTo: '',
      repliedToUserId: '',
    );
  }

  void onPickImages() async {
    images = await pickImages();
    setState(() {
      
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserDetailsProvider).value;
    final isLoading = ref.watch(tweetControllerProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          }, 
          icon: Icon(
            Icons.close,
            size: 30,
          ),
        ),
        actions: [
          RoundedSmallButton(
            onTap: shareTweet, 
            label: 'Tweet',
            backgroundColor: Pallete.blueColor,
            textColor: Pallete.whiteColor,
          ),
        ],
      ),
      body: isLoading || currentUser == null 
        ? Loader()
        : SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  // CircleAvatar(
                  //   backgroundImage: NetworkImage(currentUser.profilePic),
                  //   radius: 30,
                  // ),
                  SizedBox(width: 15),
                  Expanded(
                    child: TextField(
                      controller: tweetTextController,
                      style: TextStyle(
                        fontSize: 22,
                      ),
                      decoration: InputDecoration(
                        hintText: "What's happening?",
                        hintStyle: TextStyle(
                          color: Pallete.greyColor,
                          fontSize: 22,
                        ),
                        border: InputBorder.none
                      ),
                      maxLines: null,
                    ),
                  ),
                ],
              ),
              if(images.isNotEmpty)
              CarouselSlider(
                items: images.map(
                  (file) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.symmetric(
                        horizontal: 5,
                      ),
                      child: Image.file(file),
                    );
                  }
                ).toList(),
                options: CarouselOptions(
                  height: 400,
                  enableInfiniteScroll: false,
                ),
              ),
            ],
          ),
        ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(bottom: 10),
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Pallete.greyColor,
              width: 0.3,
            ),
          ),
        ),
        child:
          Row(
            children: [
              Padding(
                padding: EdgeInsets.all(8).copyWith(
                  left: 15,
                  right: 15,
                ),
                child: GestureDetector(
                  onTap: onPickImages,
                  child: SvgPicture.asset(
                    AssetsConstants.galleryIcon,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8).copyWith(
                  left: 15,
                  right: 15,
                ),
                child: SvgPicture.asset(AssetsConstants.gifIcon),
              ),
              Padding(
                padding: EdgeInsets.all(8).copyWith(
                  left: 15,
                  right: 15,
                ),
                child: SvgPicture.asset(AssetsConstants.emojiIcon),
              ),
            ],
          ),
      ),
    );
  }
}