// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'HahaListResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HahaListResponse _$HahaListResponseFromJson(Map<String, dynamic> json) {
  return HahaListResponse(
      json['page'] as String,
      (json['joke'] as List)
          ?.map((e) =>
              e == null ? null : Joke.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$HahaListResponseToJson(HahaListResponse instance) =>
    <String, dynamic>{'page': instance.page, 'joke': instance.joke};

Joke _$JokeFromJson(Map<String, dynamic> json) {
  return Joke(
      json['id'] as int,
      json['content'] as String,
      json['type'] as int,
      json['uid'] as int,
      json['time'] as String,
      json['good'] as int,
      json['bad'] as int,
      json['vote'] as int,
      json['comment_num'] as int,
      json['anonymous'] as int,
      json['appid'] as int,
      json['topic'] as int,
      json['topic_content'] as String,
      json['pic'] == null
          ? null
          : Pic.fromJson(json['pic'] as Map<String, dynamic>),
      json['user_name'] as String,
      json['user_pic'] as String)
    ..root = json['root'] == null
        ? null
        : Root.fromJson(json['root'] as Map<String, dynamic>);
}

Map<String, dynamic> _$JokeToJson(Joke instance) => <String, dynamic>{
      'root': instance.root,
      'id': instance.id,
      'content': instance.content,
      'type': instance.type,
      'uid': instance.uid,
      'time': instance.time,
      'good': instance.good,
      'bad': instance.bad,
      'vote': instance.vote,
      'comment_num': instance.commentNum,
      'anonymous': instance.anonymous,
      'appid': instance.appid,
      'topic': instance.topic,
      'topic_content': instance.topicContent,
      'pic': instance.pic,
      'user_name': instance.userName,
      'user_pic': instance.userPic
    };

Pic _$PicFromJson(Map<String, dynamic> json) {
  return Pic(json['path'] as String, json['name'] as String,
      json['width'] as int, json['height'] as int, json['animated'] as int);
}

Map<String, dynamic> _$PicToJson(Pic instance) => <String, dynamic>{
      'path': instance.path,
      'name': instance.name,
      'width': instance.width,
      'height': instance.height,
      'animated': instance.animated
    };

Root _$RootFromJson(Map<String, dynamic> json) {
  return Root(
      json['id'] as int,
      json['content'] as String,
      json['time'] as String,
      json['pic'] == null
          ? null
          : Pic.fromJson(json['pic'] as Map<String, dynamic>));
}

Map<String, dynamic> _$RootToJson(Root instance) => <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'time': instance.time,
      'pic': instance.pic
    };
