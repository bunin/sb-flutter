import 'dart:io';

import 'package:flutter_gallery_app/res/res.dart';
import 'package:flutter_gallery_app/screens/home.dart';
import 'package:flutter_gallery_app/screens/photo_screen.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(Connectivity().onConnectivityChanged),
      theme: ThemeData(
        appBarTheme: AppBarTheme(color: AppColors.white, elevation: 0),
        backgroundColor: AppColors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: buildAppTextTheme(),
      ),
      onUnknownRoute: (RouteSettings settings) {
        if (Platform.isAndroid) {
          return MaterialPageRoute(builder: (context) => _route404());
        } else if (Platform.isIOS) {
          return CupertinoPageRoute(builder: (context) => _route404());
        }
        return null;
      },
      onGenerateRoute: (RouteSettings settings) {
        Widget route;
        switch (settings.name) {
          case '/fullScreenImage':
            FullScreenImageArguments args =
                settings.arguments as FullScreenImageArguments;
            route = FullScreenImage(
              photo: args.photo,
              altDescription: args.altDescription,
              userName: args.userName,
              name: args.name,
              userPhoto: args.userPhoto,
              heroTag: args.heroTag,
              key: args.key,
              likes: args.likes,
              liked: args.liked,
            );
            break;
          default:
            route = _route404();
            break;
        }
        if (Platform.isAndroid) {
          return MaterialPageRoute(builder: (context) => route);
        } else if (Platform.isIOS) {
          return CupertinoPageRoute(builder: (context) => route);
        }
        return null;
      },
      debugShowCheckedModeBanner: false,
    );
  }

  Widget _route404() {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text('404'),
            Text('Page not found'),
          ],
        ),
      ),
    );
  }
}
