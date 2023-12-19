import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_appwrite/common/error_text.dart';
import 'package:flutter_web_appwrite/common/loading_page.dart';
import 'package:flutter_web_appwrite/constants/appwrite_contants.dart';
import 'package:flutter_web_appwrite/features/tweets/controller/tweet_controller.dart';
import 'package:flutter_web_appwrite/features/tweets/widgets/tweet_card.dart';
import 'package:flutter_web_appwrite/models/tweet_model.dart';

class TweetList extends ConsumerStatefulWidget {
  const TweetList({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TweetListState();
}

class _TweetListState extends ConsumerState<TweetList> {

  @override
  Widget build(BuildContext context) {
    return ref.watch(getTweetsProvider).when(
      data: (tweets) {
        return ref.watch(getLatestTweetProvider).when(
          data: (data) {
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
            return ListView.builder(
              itemCount: tweets.length,
              itemBuilder: (BuildContext context, int index) {
                final tweet = tweets[index];
                return Text(
                  tweet.text,
                  style: TextStyle(color: Colors.white),
                );
              },
            );
          }, 
          error: (error, stackTrace) => ErrorText(
            error: error.toString(),
          ), 
          loading: () {
            return ListView.builder(
            itemCount: tweets.length,
            itemBuilder: (BuildContext context, int index) {
              final tweet = tweets[index];
              return TweetCard(tweet: tweet);
            },
          );
          },
        );
        
      }, 
      error: (error, stackTrace) => ErrorText(
        error: error.toString(),
      ), 
      loading: () => Loader(),
    );
  }
}