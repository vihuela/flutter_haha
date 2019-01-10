import 'package:flutter_haha/view/constraint/BaseView.dart';

mixin IListView<T> implements BaseView {
  void setData(List<T> datas, bool loadMore);
}
