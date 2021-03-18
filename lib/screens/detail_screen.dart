import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:wiki_search/webservice/webapi.dart';

class DetailScreen extends StatefulWidget {
  String title;

  DetailScreen(this.title, {Key key});

  @override
  State<StatefulWidget> createState() {
    return DetailState();
  }
}

class DetailState extends State<DetailScreen> {
  var content = "";
  bool isLoading = true;

  @override
  void initState() {
    print('title ' + widget.title);
    WebApi().getDetail(widget.title.replaceAll(" ", "%20")).then((value) {
      if (value != null) {
        //final resStr = value.body;
        var dict = jsonDecode(value.body);
        setState(() {
          content = dict['parse']['text']['*'];
          isLoading = false;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //backgroundColor: Colors.orange,
        automaticallyImplyLeading: true,
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Expanded(
            child: isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Html(
                    data: content,
                  ),
          ),
        ],
      ),
    );
  }
}
