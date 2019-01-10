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
  List<Joke> jokes = [];

  int currentListPage = 1;
  ViewStates viewStates = ViewStates.None;

  GlobalKey<EasyRefreshState> _easyRefreshKey =
      new GlobalKey<EasyRefreshState>();
  GlobalKey<RefreshHeaderState> _headerKey =
      new GlobalKey<RefreshHeaderState>();
  GlobalKey<RefreshFooterState> _footerKey =
      new GlobalKey<RefreshFooterState>();

  @override
  void initState() {
    super.initState();
    ApiUtils.hahaListRequest(1).then((res) {
      setState(() {
        jokes = res.joke;
      });
    });
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

      body: BaseListView<Joke>(
        datas: jokes,
        itemBuilder: (datas, index) => ItemContent(datas[index]),
        viewStates: viewStates,
        onRefresh: () {
          ApiUtils.hahaListRequest(1).then((res) {
            setState(() {
              viewStates = ViewStates.Error;//todo
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
      ), //
    );
  }

  EasyRefresh buildEasyRefresh() {
    return EasyRefresh(
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
      loadMore: () {
        //异常时currentListPage不应自增 todo
        ApiUtils.hahaListRequest(++currentListPage).then((res) {
          setState(() {
            currentListPage = int.parse(res.page);
            jokes.addAll(res.joke);

          });
        });
      },
    );
  }

  FutureBuilder<List<Joke>> buildFutureBuilder() {
    return FutureBuilder<List<Joke>>(
      builder: (context, async) {
        debugPrint('async.connectionState ${async.connectionState}');

        if (async.connectionState == ConnectionState.done) {
          //error
          if (async.hasError) {
            //error parse todo
            return new RetryItem(() {
              print('show retry view:${async.error}');
            });
          }
          //no data
          else if (!async.hasData || async.data.isEmpty) {
            return new EmptyItem(() {
              print('show empty view');
            });
          }
          //have data
          else if (async.hasData) {
            return buildEasyRefresh();
          }
        } else {
          if (jokes.length == 0) {
            return new Center(
              child: new CircularProgressIndicator(),
            );
          }
        }
      },
      initialData: [],
      //first request network
      future: ApiUtils.hahaListRequest(1).then((res) {
        jokes = res.joke;
        return jokes;
      }),
    );
  }
}

class RetryItem extends StatelessWidget {
  GestureTapCallback ontap;

  RetryItem(this.ontap);

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
        child: new Center(
          child: new Text("加载出错,点击重试"),
        ),
        onTap: ontap);
  }
}

class EmptyItem extends StatelessWidget {
  GestureTapCallback ontap;

  EmptyItem(this.ontap);

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
        child: new Center(
          child: new Text("列表数据为空"),
        ),
        onTap: ontap);
  }
}
