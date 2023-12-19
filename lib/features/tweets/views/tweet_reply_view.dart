// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_appwrite/common/error_text.dart';
import 'package:flutter_web_appwrite/common/loading_page.dart';
import 'package:flutter_web_appwrite/constants/appwrite_contants.dart';
import 'package:flutter_web_appwrite/features/tweets/controller/tweet_controller.dart';
import 'package:flutter_web_appwrite/features/tweets/widgets/tweet_card.dart';
import 'package:flutter_web_appwrite/models/tweet_model.dart';

class TweetReplyView extends ConsumerWidget {
  static route(Tweet tweet) => MaterialPageRoute(
    builder: (context) => TweetReplyView(tweet: tweet),
  );
  final Tweet tweet;
  const TweetReplyView({
    super.key,
    required this.tweet,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tweet'),
      ),
      body: Column(
        children: [
          TweetCard(tweet: tweet),
          ref.watch(getRepliesToTweetsProvider(tweet)).when(
            data: (tweets) {
              return ref.watch(getLatestTweetProvider).when(
                data: (data) {
                  final latestTweet = Tweet.fromMap(data.payload);

                  bool isTweetAlreadyPresent = false;
                  for (final tweetModel in tweets) {
                    if(tweetModel.id == latestTweet.id) {
                      isTweetAlreadyPresent = true;
                      break;
                    }
                  }

                  if(!isTweetAlreadyPresent && latestTweet.repliedTo == tweet.id) {
                    if(data.events.contains(
                    'databases.*.collections.${AppWriteConstants.tweetsCollection}.documents.*.create',
                  )) {
                    tweets.insert(0, Tweet.fromMap(data.payload));
                  } else if (data.events.contains(
                    'databases.*.collections.${AppWriteConstants.tweetsCollection}.documents.*.update',
                  )) {
                    final startingPoint = 
                        data.events[0].lastIndexOf('documents.');
                    final endPoint = data.events[0].lastIndexOf('.update');
                    final tweetId = data.events[0].substring(startingPoint + 10, endPoint);

                    var tweet = tweets.where((element) => element.id == tweetId).first;
                    
                    final tweetIndex = tweets.indexOf(tweet);
                    tweets.removeWhere((element) => element.id == tweetId);

                    tweet = Tweet.fromMap(data.payload);
                    tweets.insert(tweetIndex, tweet);
                  }
                  }
                  
                  return Expanded(
                    child: ListView.builder(
                      itemCount: tweets.length,
                      itemBuilder: (BuildContext context, int index) {
                        final tweet = tweets[index];
                        return Text(
                          tweet.text,
                          style: TextStyle(color: Colors.white),
                        );
                      },
                    ),
                  );
                }, 
                error: (error, stackTrace) => ErrorText(
                  error: error.toString(),
                ), 
                loading: () {
                  return Expanded(
                    child: ListView.builder(
                    itemCount: tweets.length,
                    itemBuilder: (BuildContext context, int index) {
                      final tweet = tweets[index];
                      return TweetCard(tweet: tweet);
                    },
                                  ),
                  );
                },
              );
              
            }, 
            error: (error, stackTrace) => ErrorText(
              error: error.toString(),
            ), 
            loading: () => Loader(),
          ),
        ],
      ),
      bottomNavigationBar: TextField(
        onSubmitted: (value) {
          ref.read(tweetControllerProvider.notifier).shareTweet(
            images: [], 
            text: value, 
            context: context,
            repliedTo: tweet.id,
            repliedToUserId: tweet.id,
          );
        },
        decoration: InputDecoration(
          hintText: 'Tweet your reply'
        ),
      ),
    );
  }
}