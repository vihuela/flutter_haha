import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_haha/view/constraint/BaseView.dart';
import 'package:flutter_haha/view/constraint/IListView.dart';

typedef Widget ItemBuilder(List datas, int position);

typedef Future OnRefresh();
typedef Future LoadMore();

//如果setState不刷新，将此widget放于build回调中
//datas与itemBuilder暴露外部，避免setState不刷新
class BaseListView<T> extends StatefulWidget {
  ItemBuilder itemBuilder;
  OnRefresh onRefresh;
  LoadMore loadMore;
  List<T> datas = [];
  ViewStates viewStates = ViewStates.Loading;

  BaseListView({
    Key key,
    @required this.datas,
    @required this.itemBuilder,
    this.onRefresh,
    this.loadMore,
    this.viewStates,
  });

  @override
  State<StatefulWidget> createState() {
    return _BaseListView();
  }
}

class _BaseListView extends State<BaseListView> {
  GlobalKey<EasyRefreshState> _easyRefreshKey =
      new GlobalKey<EasyRefreshState>();
  GlobalKey<RefreshHeaderState> _headerKey =
      new GlobalKey<RefreshHeaderState>();
  GlobalKey<RefreshFooterState> _footerKey =
      new GlobalKey<RefreshFooterState>();

  @override
  Widget build(BuildContext context) {
    debugPrint("widget.viewStates:${widget.viewStates}");
    var listView = EasyRefresh(
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
        itemCount: widget.datas.length,
        separatorBuilder: (context, index) {
          return Divider(
            height: 10.0,
            color: Color(0xFFf2f3f5),
          );
        },
        itemBuilder: (context, index) {
          return widget.itemBuilder(widget.datas, index);
        },
      ),
      onRefresh: () {
        widget.onRefresh();
      },
      loadMore: () {
        widget.loadMore();
      },
    );
    if (widget.viewStates == ViewStates.Loading) {
      return LoadingItem();
    } else if (widget.viewStates == ViewStates.Error && widget.datas.isEmpty) {
      return RetryItem(() {
        widget.onRefresh();
      });
    } else if (widget.viewStates == ViewStates.Empty) {
      return EmptyItem(() {
        widget.onRefresh();
      });
    } else {
      return listView;
    }
  }
}

enum ViewStates {
  None,
  Loading,
  Error,
  Empty,
}

class LoadingItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
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
