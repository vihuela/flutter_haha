import 'package:json_annotation/json_annotation.dart';

part 'HahaListResponse.g.dart';

@JsonSerializable()
class HahaListResponse {
  @JsonKey(name: 'page')
  String page;

  @JsonKey(name: 'joke')
  List<Joke> joke;

  HahaListResponse(
    this.page,
    this.joke,
  );

  factory HahaListResponse.fromJson(Map<String, dynamic> srcJson) =>
      _$HahaListResponseFromJson(srcJson);
}

@JsonSerializable()
class Joke {
  @JsonKey(name: 'root', nullable: true, includeIfNull: true)
  Root root;

  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'content')
  String content;

  @JsonKey(name: 'type')
  int type;

  @JsonKey(name: 'uid')
  int uid;

  @JsonKey(name: 'time')
  String time;

  @JsonKey(name: 'good')
  int good;

  @JsonKey(name: 'bad')
  int bad;

  @JsonKey(name: 'vote')
  int vote;

  @JsonKey(name: 'comment_num')
  int commentNum;

  @JsonKey(name: 'anonymous')
  int anonymous;

  @JsonKey(name: 'appid')
  int appid;

  @JsonKey(name: 'topic')
  int topic;

  @JsonKey(name: 'topic_content')
  String topicContent;

  @JsonKey(name: 'pic', nullable: true, includeIfNull: true)
  Pic pic;

  @JsonKey(name: 'user_name')
  String userName;

  @JsonKey(name: 'user_pic')
  String userPic;

  Joke(
    this.id,
    this.content,
    this.type,
    this.uid,
    this.time,
    this.good,
    this.bad,
    this.vote,
    this.commentNum,
    this.anonymous,
    this.appid,
    this.topic,
    this.topicContent,
    this.pic,
    this.userName,
    this.userPic,
  );

  factory Joke.fromJson(Map<String, dynamic> srcJson) =>
      _$JokeFromJson(srcJson);
}

@JsonSerializable()
class Pic {
  @JsonKey(name: 'path')
  String path;

  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'width')
  int width;

  @JsonKey(name: 'height')
  int height;

  @JsonKey(name: 'animated')
  int animated;

  Pic(
    this.path,
    this.name,
    this.width,
    this.height,
    this.animated,
  );

  factory Pic.fromJson(Map<String, dynamic> srcJson) => _$PicFromJson(srcJson);
}

@JsonSerializable()
class Root {
  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'content')
  String content;

  @JsonKey(name: 'time')
  String time;

  @JsonKey(name: 'pic', nullable: true, includeIfNull: true)
  Pic pic;

  Root(this.id, this.content, this.time, this.pic);

  factory Root.fromJson(Map<String, dynamic> srcJson) =>
      _$RootFromJson(srcJson);
}
