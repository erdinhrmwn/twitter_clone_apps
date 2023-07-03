import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:twitter_clone_apps/core/enums/tweet_type.dart';

part 'tweet_model.freezed.dart';
part 'tweet_model.g.dart';

@freezed
class Tweet with _$Tweet {
  const factory Tweet({
    @Default('') @JsonKey(name: "\$id", includeToJson: false) String id,
    required String uid,
    @Default('') String text,
    @TweetTypeConverter() required TweetType tweetType,
    @DateTimeConverter() required DateTime tweetedAt,
    @Default([]) List<String> hashtags,
    @Default('') String link,
    @Default([]) List<String> imageLinks,
    @Default([]) List<String> likes,
    @Default([]) List<String> commentIds,
    @Default(0) int shareCount,
    @Default('') String retweetedBy,
    @Default('') String repliedTo,
    @JsonKey(name: "\$createdAt", includeToJson: false) DateTime? createdAt,
    @JsonKey(name: "\$updatedAt", includeToJson: false) DateTime? updatedAt,
  }) = _Tweet;

  factory Tweet.fromJson(Map<String, dynamic> json) => _$TweetFromJson(json);
}

class TweetTypeConverter implements JsonConverter<TweetType, String> {
  const TweetTypeConverter();

  @override
  TweetType fromJson(String json) {
    return json.toTweetTypeEnum();
  }

  @override
  String toJson(TweetType object) {
    return object.type;
  }
}

class DateTimeConverter implements JsonConverter<DateTime, int> {
  const DateTimeConverter();

  @override
  DateTime fromJson(int json) {
    return DateTime.fromMillisecondsSinceEpoch(json);
  }

  @override
  int toJson(DateTime object) {
    return object.millisecondsSinceEpoch;
  }
}
