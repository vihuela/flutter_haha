import 'package:flutter/material.dart';
import 'package:flutter_haha/item/item_content.dart';
import 'package:flutter_haha/view/LabelView.dart';

class ListContent extends StatefulWidget {
  List jokes = [];

  ListContent(this.jokes);

  @override
  State<StatefulWidget> createState() {
    print('jokes,length:${jokes.length}');
    return ListContentState(jokes);
  }
}

class ListContentState extends State<ListContent> {
  List jokes = [];

  ListContentState(this.jokes);

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
      itemCount: jokes.length,
      separatorBuilder: (context, index) {
        return Divider(
          height: 10.0,
          color: Color(0xFFf2f3f5),
        );
      },
      itemBuilder: (context, index) {
        return ItemContent(jokes[index]);
      },
    );
  }
}
