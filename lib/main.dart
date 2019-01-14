import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_haha/model/HahaListResponse.dart';
import 'package:flutter_haha/net/Api.dart';
import 'package:flutter_haha/item/item_content.dart';
import 'package:dio/dio.dart';
import 'package:flutter_haha/net/ApiUtils.dart';
import 'package:flutter_haha/view/BaseListView.dart';
import 'package:flutter_haha/view/loadmore_widget.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

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
  List<Joke> jokes;
  ViewStates viewStates;

  int currentListPage = 1;

  @override
  void initState() {
    super.initState();
    //首次获取
    ApiUtils.hahaListRequest(1).then((res) {
      setState(() {
        viewStates = ViewStates.None;
        jokes = res.joke;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var baseListView = BaseListView<Joke>(
      datas: jokes,
      itemBuilder: (datas, index) => ItemContent(datas[index]),
      viewStates: viewStates,
      onRefresh: () {
        ApiUtils.hahaListRequest(1).then((res) {
          setState(() {
            currentListPage = 1;
            jokes = res.joke;
          });
        });
      },
      loadMore: () {
        ApiUtils.hahaListRequest(++currentListPage).then((res) {
          setState(() {
            currentListPage = int.parse(res.page);
            jokes.addAll(res.joke);
          });
        });
      },
    );
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: GestureDetector(
            child: Text("haha.mx"),
            onTap: () {
              baseListView.scrollToTop();
            },
          ),
        ),
      ),

      body: baseListView, //
    );
  }
}
