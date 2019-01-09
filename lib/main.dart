import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_haha/model/HahaListResponse.dart';
import 'package:flutter_haha/net/Api.dart';
import 'package:flutter_haha/item/item_content.dart';
import 'package:dio/dio.dart';
import 'package:flutter_haha/net/ApiUtils.dart';
import 'package:flutter_haha/view/loadmore_widget.dart';

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

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
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
      body: LoadMore(
        isFinish: isLoadMoreFinish,
        onLoadMore: _loadMore,
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
        whenEmptyLoad: false,
        delegate: DefaultLoadMoreDelegate(),
        textBuilder: DefaultLoadMoreTextBuilder.chinese,
      ), //
    );
  }

  getData({loadMode = false, page = 1, Function call}) {
    ApiUtils.hahaListRequest(
      (data) {
        HahaListResponse response = data;
        setState(() {
          currentListPage = int.parse(response.page);
          isLoadMoreFinish = response.joke.isEmpty;

          if (!loadMode) {
            //refresh
            jokes = response.joke;
            currentListPage = 1;
          } else {
            //loadMore
            jokes.addAll(response.joke);
          }
          if (call != null) call(isLoadMoreFinish);
        });
      },
      loadMode,
      page,
    );
  }

  Future<bool> _loadMore() async {
    print('_loadMore');
    getData(
        loadMode: true,
        page: ++currentListPage,
        call: (v) {
          return v;
        });
    return true;
  }
}
