import 'package:flutter/material.dart';
import 'package:flutter_haha/item/item_content.dart';
import 'package:flutter_haha/view/LabelView.dart';

class ListContent extends StatefulWidget {
  List jokes = [];
  //itemBuilder须放外部,放内部setState不刷新
  IndexedWidgetBuilder itemBuilder;

  ListContent({
    Key key,
    @required this.jokes,
    @required this.itemBuilder,
  });

  @override
  State<StatefulWidget> createState() {
    return ListContentState();
  }
}

class ListContentState extends State<ListContent> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: widget.jokes.length,
      separatorBuilder: (context, index) {
        return Divider(
          height: 10.0,
          color: Color(0xFFf2f3f5),
        );
      },
      itemBuilder: widget.itemBuilder,
    );
  }
}
