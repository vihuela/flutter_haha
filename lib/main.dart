import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_haha/model/HahaListResponse.dart';
import 'package:flutter_haha/net/Api.dart';
import 'package:flutter_haha/item/item_content.dart';
import 'package:dio/dio.dart';
import 'package:flutter_haha/net/ApiUtils.dart';
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
  List jokes = [];
  int currentListPage = 1;
  bool isLoadMoreFinish = false;
  GlobalKey<EasyRefreshState> _easyRefreshKey =
      new GlobalKey<EasyRefreshState>();
  GlobalKey<RefreshHeaderState> _headerKey =
      new GlobalKey<RefreshHeaderState>();
  GlobalKey<RefreshFooterState> _footerKey =
      new GlobalKey<RefreshFooterState>();

  @override
  void initState() {
    super.initState();
//    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: GestureDetector(
            child: Text("haha.mx"),
            onTap: () {
//              getData();
            },
          ),
        ),
      ),

      body: EasyRefresh(
        key: _easyRefreshKey,
        behavior: ScrollOverBehavior(),
        refreshHeader: ClassicsHeader(
          key: _headerKey,
          bgColor: Colors.transparent,
          textColor: Colors.black87,
          moreInfoColor: Colors.black54,
          showMore: true,
        ),
        refreshFooter: ClassicsFooter(
          key: _footerKey,
          bgColor: Colors.transparent,
          textColor: Colors.black87,
          moreInfoColor: Colors.black54,
          showMore: true,
        ),
        child: ListView.separated(
          itemCount: jokes.length,
          separatorBuilder: (context, index) {
            return Divider(
              height: 10.0,
              color: Color(0xFFf2f3f5),
            );
          },
          itemBuilder: (context, index) => ItemContent(jokes[index]),
        ),
        onRefresh: () {
          ApiUtils.hahaListRequest(1).then((res) {
            setState(() {
              currentListPage = 1;
              jokes = res.joke;
            });
          });
        },
        loadMore: () async {
          ApiUtils.hahaListRequest(++currentListPage).then((res) {
            setState(() {
              currentListPage = int.parse(res.page);
              jokes.addAll(res.joke);
            });
          });
        },
      ), //
    );
  }
}
