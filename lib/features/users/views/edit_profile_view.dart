// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_appwrite/common/loading_page.dart';
import 'package:flutter_web_appwrite/core/utils.dart';
import 'package:flutter_web_appwrite/features/auth/controllers/auth_controllers.dart';
import 'package:flutter_web_appwrite/features/users/controllers/user_controllers.dart';
import 'package:flutter_web_appwrite/theme/pallete.dart';

class EditProfile extends ConsumerStatefulWidget {
  static route() => MaterialPageRoute(
    builder: (context) => EditProfile(),
  );
  const EditProfile({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditProfileState();
}

class _EditProfileState extends ConsumerState<EditProfile> {
  late  TextEditingController nameController;
  late  TextEditingController bioController;
  File? bannerFile;
  File? profileFile;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameController = TextEditingController(
      text: ref.read(currentUserDetailsProvider).value?.name ?? '',
    );
    bioController = TextEditingController(
      text: ref.read(currentUserDetailsProvider).value?.bio ?? '',
    );
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    bioController.dispose();
  }

  void selectBannerImage() async {
    final banner = await pickImage();
    if(banner != null) {
      setState(() {
        bannerFile = banner;
      });
    }
  }

  void selectProfileImage() async {
    final profileImage = await pickImage();
    if(profileFile != null) {
      setState(() {
        profileFile = profileImage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserDetailsProvider).value;
    final isLoading = ref.watch(userProfileControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        actions: [
          TextButton(
            onPressed: () {
              ref
                .read(userProfileControllerProvider.notifier)
                .updateUserProfile(
                  userModel: user!.copyWith(
                    bio: bioController.text,
                    name: nameController.text,
                  ), 
                  context: context, 
                  bannerFile: bannerFile, 
                  profileFile: profileFile,
                );
            }, 
            child: Text('data'),
          ),
        ],
      ),
      body: isLoading || user == null ? Loader() : Column(
        children: [
          SizedBox(
            height: 200,
            child: Stack(
                children: [
                  GestureDetector(
                    onTap: selectBannerImage,
                    child: Container(
                      width: double.infinity,
                      height: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: bannerFile != null
                        ? Image.file(bannerFile!, fit: BoxFit.fitWidth,)
                        : user.bannerPic.isEmpty
                          ? Container(
                            color: Pallete.blueColor,
                          )
                        : Image.network(user.bannerPic, fit: BoxFit.fitWidth),
                    ),
                  ),
                  GestureDetector(
                    onTap: selectProfileImage,
                    child: Positioned(
                      bottom: 20,
                      left: 20,
                      child: profileFile != null ? CircleAvatar(
                        backgroundImage: FileImage(profileFile!),
                        radius: 40,
                      ) : CircleAvatar(
                        backgroundImage: user.profilePic.isEmpty
                          ? NetworkImage('data:image/jpeg;base64,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')
                          : NetworkImage(user.profilePic),
                        radius: 45,
                      ),
                    ),
                  ),
                ],
            ),
          ),
          TextField(
            controller: nameController,
            decoration: InputDecoration(
              hintText: 'Name',
              contentPadding: EdgeInsets.all(18),
            ),
          ),
          SizedBox(height: 20),
          TextField(
            controller: nameController,
            decoration: InputDecoration(
              hintText: 'Name',
              contentPadding: EdgeInsets.all(18),
            ),
            maxLines: 4,
          ),
        ],
      ),
    );
  }
}