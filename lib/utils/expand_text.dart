import 'package:flutter/material.dart';

class ExpandableText extends StatefulWidget {
  final String labelHeader;
  final String desc;
  final String shortDesc;

  ExpandableText({
    Key? key,
    required this.labelHeader,
    required this.desc,
    required this.shortDesc,
  }) : super(key: key);

  @override
  _ExpandableTextState createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool descTextShowFlag = false;

  String removeHtmlTags(String htmlText) {
    return htmlText.replaceAll(RegExp(r'<[^>]*>'), '');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            widget.labelHeader,
            style: TextStyle(
              fontSize: 15,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            descTextShowFlag ? removeHtmlTags(widget.desc) : removeHtmlTags(widget.shortDesc),
            style: TextStyle(
              fontSize: 14,
              color: Colors.black,
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              child: Text(
                descTextShowFlag ? "Show Less" : "Show More",
                style: TextStyle(
                  color: Colors.blue,
                ),
              ),
              onTap: () {
                setState(() {
                  descTextShowFlag = !descTextShowFlag;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
