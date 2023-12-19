// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, unnecessary_brace_in_string_interps, unused_local_variable

import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_web_appwrite/common/error_text.dart';
import 'package:flutter_web_appwrite/common/loading_page.dart';
import 'package:flutter_web_appwrite/constants/assets_constants.dart';
import 'package:flutter_web_appwrite/core/enums/tweet_type.dart';
import 'package:flutter_web_appwrite/features/auth/controllers/auth_controllers.dart';
import 'package:flutter_web_appwrite/features/tweets/controller/tweet_controller.dart';
import 'package:flutter_web_appwrite/features/tweets/views/tweet_reply_view.dart';
import 'package:flutter_web_appwrite/features/tweets/widgets/carousel_images.dart';
import 'package:flutter_web_appwrite/features/tweets/widgets/hashtag_text.dart';
import 'package:flutter_web_appwrite/features/tweets/widgets/tweet_button.dart';
import 'package:flutter_web_appwrite/features/users/views/user_profile_view.dart';
// import 'package:flutter_web_appwrite/features/users/widgets/user_profile.dart';
import 'package:flutter_web_appwrite/models/tweet_model.dart';
import 'package:flutter_web_appwrite/theme/pallete.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:like_button/like_button.dart';

class TweetCard extends ConsumerWidget {
  final Tweet tweet;
  TweetCard({
    super.key,
    required this.tweet,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserDetailsProvider).value;
    return currentUser == null ? SizedBox() : ref.watch(userDetailsProvider(tweet.uid)).when(
      data: (user) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context, 
              TweetReplyView.route(tweet),
            );
          },
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.all(10),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context, 
                          UserView.route(user),
                        );
                      },
                      child: CircleAvatar(
                        backgroundImage: user.profilePic.isEmpty
                          ? NetworkImage('data:image/jpeg;base64,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')
                          : NetworkImage(user.profilePic),
                        radius: 35,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if(tweet.retweetedBy.isNotEmpty)
                        Row(
                          children: [
                            SvgPicture.asset(
                              AssetsConstants.retweetIcon,
                              color: Pallete.greyColor,
                              height: 20,
                            ),
                            SizedBox(width: 2),
                            Text(
                              '${tweet.retweetedBy} retweeted',
                              style: TextStyle(
                                color: Pallete.greyColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(right: user.isTwitterBlue ? 1 : 5),
                              child: Text(
                                user.name,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 19,
                                ),
                              ),
                            ),
                            if(user.isTwitterBlue)
                              Padding(
                                padding: const EdgeInsets.only(right: 5.0),
                                child: SvgPicture.asset(
                                  AssetsConstants.verifiedIcon,
                                ),
                              ),
                            Text(
                                '@${user.name} . ${timeago.format(
                                  tweet.tweetedAt,
                                  locale: 'en_short',
                                )}',
                                style: TextStyle(
                                  color: Pallete.greyColor,
                                  fontSize: 17,
                                ),
                              ),
                          ],
                        ),
                        if(tweet.repliedTo.isNotEmpty)
                        ref.watch(getTweetByIdProvider(tweet.repliedTo)).when(
                          data: (repliedToTweet) {
                            final replyingToUser = ref.watch(
                              userDetailsProvider(
                                repliedToTweet.uid,
                              ),
                            ).value;
                            return RichText(
                              text: TextSpan(
                                text: 'Replying to',
                                style: TextStyle(
                                  color: Pallete.greyColor,
                                  fontSize: 16,
                                ),
                                children: [
                                  TextSpan(
                                    text: ' @${replyingToUser?.name}',
                                    style: TextStyle(
                                      color: Pallete.blueColor,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }, 
                          error: (error, stackTrace) => ErrorText(error: error.toString()),
                          loading: () => LoadingPage(),
                        ),
                        HashtagText(text: tweet.text),
                        if(tweet.tweetType == TweetType.image)
                        CarouselImage(imageLinks: tweet.imageLinks),
                        if(tweet.link.isNotEmpty) ...[
                          SizedBox(height: 4),
                          AnyLinkPreview(
                            displayDirection: UIDirection.uiDirectionHorizontal,
                            link: 'https://${tweet.link}',
                          ),
                        ],
                        Container(
                          margin: EdgeInsets.only(
                            top: 10,
                            right: 20,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TweetIconButton(
                                pathName: AssetsConstants.viewsIcon, 
                                text: (tweet.commentIds.length +
                                    tweet.reshareCount +
                                    tweet.likes.length)
                                  .toString(), 
                                onTap: () {},
                              ),
                              TweetIconButton(
                                pathName: AssetsConstants.commentIcon, 
                                text: tweet.commentIds.length.toString(), 
                                onTap: () {},
                              ),
                              TweetIconButton(
                                pathName: AssetsConstants.retweetIcon, 
                                text: tweet.reshareCount.toString(), 
                                onTap: () {
                                  ref.read(tweetControllerProvider.notifier).reshareTweet(
                                    tweet, 
                                    currentUser, 
                                    context,
                                  );
                                },
                              ),
                              LikeButton(
                                size: 25,
                                onTap: (isLiked) async {
                                  ref.read(tweetControllerProvider.notifier)
                                    .likeTweet(tweet, currentUser);
                                  return !isLiked;
                                },
                                isLiked: tweet.likes.contains(currentUser.uid),
                                likeBuilder: (isLiked) {
                                  return isLiked
                                    ? SvgPicture.asset(
                                      AssetsConstants.likeFilledIcon,
                                      color: Pallete.redColor,
                                    )
                                    : SvgPicture.asset(
                                      AssetsConstants.likeOutlinedIcon,
                                      color: Pallete.greyColor,
                                    );
                                },
                                likeCount: tweet.likes.length,
                                countBuilder: (likeCount, isLiked, text) {
                                  return Padding(
                                    padding: EdgeInsets.only(left: 2.0),
                                    child: Text(
                                      text,
                                      style: TextStyle(
                                        color: isLiked
                                          ? Pallete.redColor
                                          : Pallete.whiteColor,
                                        fontSize: 16,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              IconButton(
                                onPressed: () {}, 
                                icon: Icon(
                                  Icons.share_outlined,
                                  size: 25,
                                  color: Pallete.greyColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 1)
                      ],
                    ),
                  ),
                ],
              ),
              Divider(color: Pallete.greyColor),
            ],
          ),
        );
      }, 
      error: (error, stackTrace) => ErrorText(error: error.toString()), 
      loading: () => Loader(),
    );
  }
}