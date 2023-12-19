// ignore_for_file: prefer_const_constructors, unnecessary_string_interpolations

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_appwrite/features/tweets/views/hashtag_view.dart';
import 'package:flutter_web_appwrite/theme/pallete.dart';

class HashtagText extends StatelessWidget {
  final String text;
  const HashtagText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    List<TextSpan> textSpan = [];

    text.split(' ').forEach((element) {
      if(element.startsWith('#')) {
        textSpan.add(
          TextSpan(
            text: '$element',
            style: TextStyle(
              color: Pallete.blueColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.push(
                    context, 
                    HashtagView.route(element),
                  );
                }
          ),
        );
      } else if(element.startsWith('www.') || element.startsWith('https://')) {
        textSpan.add(
          TextSpan(
            text: '$element',
            style: TextStyle(
              color: Pallete.blueColor,
              fontSize: 18,
            ),
          ),
        );
      } else {
        textSpan.add(
          TextSpan(
            text: '$element',
            style: TextStyle(
              fontSize: 18,
            )
          ),
        );
      }
    });
    return RichText(
      text: TextSpan(
        children: textSpan,
      ),
    );
  }
}