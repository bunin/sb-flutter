import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DemoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, {'name': 'asd'});
              },
              child: Text('Click me'),
            ),
          ],
        ),
      ),
    );
  }
}
