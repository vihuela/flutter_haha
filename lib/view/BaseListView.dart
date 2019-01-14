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
  final ViewStates viewStates;
  final List datas;
  ScrollController scrollController = new ScrollController();

  ItemBuilder itemBuilder;

  OnRefresh onRefresh;
  LoadMore loadMore;

  BaseListView({
    Key key,
    @required this.itemBuilder,
    @required this.datas,
    this.viewStates,
    this.onRefresh,
    this.loadMore,
  });

  void scrollToTop() async {
    if (scrollController.hasClients) {
      await scrollController.animateTo(
        0.0,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 300),
      );
    }
  }

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
        controller: widget.scrollController,
        itemCount: widget.datas != null ? widget.datas.length : 0,
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
      onRefresh: widget.onRefresh ?? null,
      loadMore: widget.loadMore ?? null,
    );

    switch (widget.viewStates) {
      case ViewStates.None:
        {
          return listView;
        }
        break;
      case ViewStates.Error:
        {
          if (widget.datas == null || widget.datas.isEmpty) {
            return RetryItem(() {
              widget.onRefresh();
            });
          }
        }
        break;
      case ViewStates.Empty:
        {
          return EmptyItem(() {
            widget.onRefresh();
          });
        }
        break;
      default:
        {
          return LoadingItem();
        }
        break;
    }
  }
}

enum ViewStates {
  None,
  Loading,
  Error,
  Empty,
}

@immutable
class LoadingItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}

@immutable
class RetryItem extends StatelessWidget {
  final GestureTapCallback ontap;

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

@immutable
class EmptyItem extends StatelessWidget {
  final GestureTapCallback ontap;

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
