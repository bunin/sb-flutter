import 'package:FlutterGalleryApp/screens/feed_screen.dart';
import 'package:FlutterGalleryApp/screens/photo_screen.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FullScreenImage(
        photo: kFlutterDash,
        altDescription: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum porta est sit amet aliquet vulputate. Proin non eros nec diam lacinia ultrices non id ante. Ut vehicula nec elit ut porttitor. In et felis at massa dapibus facilisis vel eget tellus. Donec ut consectetur elit. Etiam sed iaculis justo. Morbi ut diam felis. Integer quis risus nec tortor scelerisque feugiat id mollis mi. Nunc egestas lectus in nisl ultrices, eget auctor dui posuere. Quisque commodo sapien at mauris tincidunt sollicitudin tristique et nunc. In at massa sem. Etiam suscipit dui at velit suscipit, ut egestas ipsum maximus. Sed iaculis justo vitae semper ornare. Nulla tincidunt, lacus nec iaculis cursus, leo libero commodo diam, et mollis lacus est a purus.',
      ),
    );
  }
}
