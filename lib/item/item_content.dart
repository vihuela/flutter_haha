import 'package:flutter/material.dart';
import 'package:flutter_haha/model/HahaListResponse.dart';
import 'package:flutter_haha/view/LabelView.dart';

class ItemContent extends StatefulWidget {
  Joke joke;

  ItemContent(this.joke);

  @override
  State<StatefulWidget> createState() {
    return ItemContentState(joke);
  }
}

class ItemContentState extends State<ItemContent> {
  Joke joke;

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

    //comment content
    var isShowRefContent = true;
    //imageView
    var isShowImage = true;
    //labelView
    var isShowLabelView = true;
    var isGif = true;

    var r1 = Flex(
      direction: Axis.vertical,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        //time
        Padding(
          padding: EdgeInsets.fromLTRB(padding, padding, padding, 0),
          child: Text(
            joke.content,
            textAlign: TextAlign.start,
            style: TextStyle(color: Color(0xFF8e8e93), fontSize: 12.0),
            maxLines: 1,
          ),
        ),

        //content
        Padding(
          padding: EdgeInsets.all(padding),
          child: Text(
            "sdsddsdsdsddsdsdsddsdsdsddsdsdsddsdsdsddsdsdsddsdsdsddsdsdsddsdsdsddsdsdsddsdsdsddsdsdsddsdsdsddsdsdsddsd",
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
              "sdsddsdsdsddsdsdsddsdsdsddsdsdsddsdsdsddsdsdsddsdsdsddsdsdsddsdsdsddsdsdsddsdsdsddsdsdsddsdsdsddsdsdsddsd",
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
                "https://file.digitaling.com/eImg/uimages/20170104/1483513576654699.jpg",
              ),
              Visibility(
                  visible: isShowLabelView,
                  //labelView
                  child: LabelView(
                    Size(500, 120),
                    useAngle: false,
                    labelAlignment: LabelAlignment.rightTop,
                    labelText: isGif ? "GIF" : "Long",
                    labelColor: Color(isGif ? 0xFFEE726E : 0xFF8e8e93),
                  ))
            ],
          ),
        ),
      ],
    );
    return r1;
  }
}
