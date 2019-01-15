import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_haha/app/i18n.dart';

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
  String errorInfo;

  BaseListView({
    Key key,
    @required this.itemBuilder,
    @required this.datas,
    this.viewStates,
    this.onRefresh,
    this.loadMore,
    this.errorInfo,
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
      case ViewStates.Error:
        {
          if (widget.datas == null || widget.datas.isEmpty) {
            return RetryItem(widget.errorInfo, () {
              widget.onRefresh();
            });
          } else {
            Fluttertoast.showToast(
              msg: widget.errorInfo,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIos: 1,
            );
          }
          return listView;
        }

      case ViewStates.Empty:
        {
          return EmptyItem(() {
            widget.onRefresh();
          });
        }
      default:
        {
          return LoadingItem();
        }
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
    return Center(child: CircularProgressIndicator());
  }
}

@immutable
class RetryItem extends StatelessWidget {
  final GestureTapCallback ontap;
  final String errorInfo;

  RetryItem(this.errorInfo, this.ontap);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(errorInfo ?? i18n.BaseListView_Default_Error_Info),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: GestureDetector(
                child: Text(
                  i18n.BaseListView_Click_To_Retry,
                  style: TextStyle(fontSize: 16.0),
                ),
                onTap: ontap,
              ),
            )
          ],
        ),
      ),
    );
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
          child: new Text(i18n.BaseListView_List_Data_Empty),
        ),
        onTap: ontap);
  }
}
