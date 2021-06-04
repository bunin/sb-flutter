import 'package:FlutterGalleryApp/data_provider.dart';
import 'package:FlutterGalleryApp/screens/feed_screen.dart';
import 'package:FlutterGalleryApp/screens/webview_page.dart';
import 'package:flutter/material.dart';

import 'photo_list.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("widget.title"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Press button to login',
            ),
            Container(
              width: 100,
              child: FlatButton(
                child: Text("Login"),
                color: Colors.blue,
                textColor: Colors.white,
                disabledColor: Colors.grey,
                disabledTextColor: Colors.black,
                onPressed: () => doLogin(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void doLogin(BuildContext context) {
    if (DataProvider.authToken == "") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => WebViewPage()),
      ).then((value) {
        RegExp exp = RegExp("(?<==).*");
        var oneTimeCode = exp.stringMatch(value);

        DataProvider.doLogin(oneTimeCode: oneTimeCode).then((value) {
          DataProvider.authToken = value.accessToken;

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Feed(),
            ),
          );
        });
      });
    } else
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Feed(),
        ),
      );
  }
}
