// ignore_for_file: prefer_const_constructors, body_might_complete_normally_nullable, unused_import

import 'package:flutter/material.dart';
// import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_appwrite/common/loading_page.dart';
import 'package:flutter_web_appwrite/features/auth/controllers/auth_controllers.dart';
import 'package:flutter_web_appwrite/features/auth/views/signup_view.dart';
import 'package:flutter_web_appwrite/features/home/views/home_view.dart';
import 'package:flutter_web_appwrite/theme/theme.dart';

void main() {
  runApp(ProviderScope(child: const MyApp()));
}
/*
import 'package:appwrite/appwrite.dart';

Client client = Client();
client
    .setEndpoint('http://localhost/v1')
    .setProject('64fced6d665b79b540c8')
    .setSelfSigned(status: true); // For self signed certificates, only use for development
*/
/*
import 'package:appwrite/appwrite.dart';

Client client = Client();
client
    .setEndpoint('http://localhost/v1')
    .setProject('64fced6d665b79b540c8')
    .setSelfSigned(status: true); // For self signed certificates, only use for development
*/

// Client client = Client()
//     .setEndpoint('http://localhost/v1')
//     .setProject('64fced6d665b79b540c8')
//     .setSelfSigned(status: true); //        // Your project ID

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppTheme.theme,
      home: ref.watch(currentUserAccountProvider).when(
        data: (user) {
          if(user!=null) {
            return HomeView();
          }
          return SignUpView();
        }, 
        error: (error, stackTrace) {
          error.toString();
        }, 
        loading: () => LoadingPage(),
      ),
    );
  }
}