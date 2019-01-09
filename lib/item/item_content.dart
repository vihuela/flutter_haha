import 'package:flutter/material.dart';
import 'package:flutter_haha/model/HahaListResponse.dart';
import 'package:flutter_haha/view/LabelView.dart';

class ItemContent extends StatefulWidget {
  final Joke joke;

  ItemContent(this.joke);

  @override
  State<StatefulWidget> createState() {
    return ItemContentState(joke);
  }
}

class ItemContentState extends State<ItemContent> {
  final Joke joke;

  ItemContentState(this.joke);

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
    var padding = 10.0;
    //time
    var time = joke.time;
    //comment content
    var isShowRefContent = joke.root != null;
    var contentRef =
        isShowRefContent ? joke.root.content.replaceAll("<br />", "") : "";
    //imageView
    var isShowImage = joke.pic != null;
    var imageUrl = isShowImage
        ? "https://image.haha.mx/${joke.pic.path}/middle/${joke.pic.name}"
        : "";
    //labelView
    var content = joke.content.replaceAll("<br />", "");
    var isGif = imageUrl.endsWith("gif");
    var isShowLabelView = isShowImage != null ? isGif || joke.pic.height >= 6666 : false;
    var labelText = isGif ? "GIF" : "Long";
    var labelColor = isGif ? 0xFFEE726E : 0xFF8e8e93;

    var r1 = Flex(
      direction: Axis.vertical,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        //time
        Padding(
          padding: EdgeInsets.fromLTRB(padding, padding, padding, 0),
          child: Text(
            time,
            textAlign: TextAlign.start,
            style: TextStyle(color: Color(0xFF8e8e93), fontSize: 12.0),
            maxLines: 1,
          ),
        ),

        //content
        Padding(
          padding: EdgeInsets.all(padding),
          child: Text(
            content,
            textAlign: TextAlign.justify,
            style: TextStyle(color: Color(0xFF696969), fontSize: 15.0),
          ),
        ),

        //Ref content
        Visibility(
          visible: isShowRefContent,
          child: Padding(
            padding: EdgeInsets.fromLTRB(padding * 3, 0, padding, padding),
            child: Text(
              contentRef,
              textAlign: TextAlign.justify,
              style: TextStyle(color: Color(0xFF8e8e93)),
            ),
          ),
        ),

        Visibility(
          visible: isShowImage,
          child: Stack(
            //image
            children: <Widget>[
              Image.network(
                imageUrl,
              ),
              Visibility(
                  visible: isShowLabelView,
                  //labelView
                  child: LabelView(
                    Size(500, 120),
                    useAngle: false,
                    labelAlignment: LabelAlignment.rightTop,
                    labelText: labelText,
                    labelColor: Color(labelColor),
                  ))
            ],
          ),
        ),
      ],
    );
    return r1;
  }
}
