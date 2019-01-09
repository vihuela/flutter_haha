import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_haha/model/HahaListResponse.dart';
import 'package:flutter_haha/net/Api.dart';
import 'package:flutter_haha/item/item_content.dart';
import 'package:flutter_haha/item/list_content.dart';
import 'package:dio/dio.dart';
import 'package:flutter_haha/net/ApiUtils.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter haha',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'data from haha.mx'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List jokes = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    var listContent = ListView.separated(
      itemCount: jokes.length,
      separatorBuilder: (context, index) {
        return Divider(
          height: 10.0,
          color: Color(0xFFf2f3f5),
        );
      },
      itemBuilder: (context, index) {
        return ItemContent(jokes[index]);
      },
    );
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: GestureDetector(
            child: Text("haha.mx"),
            onTap: () {
              getData();
            },
          ),
        ),
      ),
      body: listContent, //
    );
  }

  void getData() {
    ApiUtils.hahaListRequest((data) {
      HahaListResponse response = data;
      setState(() {
        jokes = response.joke;
        print('jokes:${jokes.length}');
      });
    });
  }
}
