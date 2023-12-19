import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_appwrite/common/error_text.dart';
import 'package:flutter_web_appwrite/common/loading_page.dart';
import 'package:flutter_web_appwrite/features/tweets/controller/tweet_controller.dart';
import 'package:flutter_web_appwrite/features/tweets/widgets/tweet_card.dart';

class HashtagView extends ConsumerWidget {
  static route(String hashtag) => MaterialPageRoute(
    builder: (context) => HashtagView(hashtag: hashtag),
  );
  final String hashtag;
  const HashtagView({
    super.key,
    required this.hashtag,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(hashtag),
      ),
      body: ref.watch(getTweetsByHashtagProvider(hashtag)).when(
      data: (tweets) {
            return ListView.builder(
              itemCount: tweets.length,
              itemBuilder: (BuildContext context, int index) {
                final tweet = tweets[index];
                return TweetCard(tweet: tweet);
              },
            );
          }, 
      error: (error, stackTrace) => ErrorText(
        error: error.toString(),
      ), 
      loading: () => Loader(),
      ),
    );
  }
}