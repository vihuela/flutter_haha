import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_haha/item/item_content.dart';
import 'package:flutter_haha/model/HahaListResponse.dart';
import 'package:flutter_haha/net/Api.dart';
import 'package:flutter_haha/net/ErrorData.dart';
import 'package:flutter_haha/view/BaseListView.dart';

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

  String errorInfo;

  @override
  void initState() {
    super.initState();
    //首次获取
    Api.hahaListRequest(1).then((res) {
      setState(() {
        viewStates = ViewStates.None;
        jokes = res.joke;
      });
    }).catchError((e) {
      setState(() {
        viewStates = ViewStates.Error;
        errorInfo = (e as ErrorData).message;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var baseListView = BaseListView<Joke>(
      datas: jokes,
      itemBuilder: (datas, index) => ItemContent(datas[index]),
      viewStates: viewStates,
      errorInfo: errorInfo,
      onRefresh: () {
        Api.hahaListRequest(1).then((res) {
          setState(() {
            viewStates = ViewStates.None;
            currentListPage = 1;
            jokes = res.joke;
          });
        }).catchError((e) {
          setState(() {
            viewStates = ViewStates.Error;
            errorInfo = (e as ErrorData).message;
          });
        });
      },
      loadMore: () {
        Api.hahaListRequest(++currentListPage).then((res) {
          setState(() {
            viewStates = ViewStates.None;
            currentListPage = int.parse(res.page);
            jokes.addAll(res.joke);
          });
        }).catchError((e) {
          setState(() {
            currentListPage--;
            viewStates = ViewStates.Error;
            errorInfo = (e as ErrorData).message;
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
