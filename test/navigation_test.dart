import 'dart:async';

import 'package:FlutterGalleryApp/screens/home.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:FlutterGalleryApp/screens/photo_screen.dart';
import 'package:FlutterGalleryApp/screens/feed_screen.dart';
import 'package:FlutterGalleryApp/res/res.dart';

void main() {
  testWidgets('module1', (WidgetTester tester) async {
    TextTheme textTheme = buildAppTextTheme();

    expect(
      textTheme.headline6,
      TextStyle(
        fontSize: 12,
        height: 20 / 12,
        letterSpacing: -0.24,
        fontWeight: FontWeight.w300,
        fontFamily: 'Roboto',
        fontStyle: FontStyle.normal,
      ),
    );

    expect(
        textTheme.headline5,
        TextStyle(
          fontSize: 13,
          height: 18 / 13,
          fontWeight: FontWeight.normal,
          color: AppColors.black,
          fontStyle: FontStyle.normal,
          fontFamily: 'Roboto',
        ));

    expect(
      textTheme.headline4,
      TextStyle(
        fontSize: 14,
        height: 16 / 14,
        color: AppColors.alto,
        fontWeight: FontWeight.w600,
        fontFamily: 'Roboto',
        fontStyle: FontStyle.normal,
        letterSpacing: 0.75,
      ),
    );

    expect(
      textTheme.headline3,
      TextStyle(
        fontSize: 14,
        height: 20 / 14,
        color: AppColors.manatee,
        fontWeight: FontWeight.normal,
        fontFamily: 'Roboto',
        fontStyle: FontStyle.normal,
        letterSpacing: 0.25,
      ),
    );

    expect(
      textTheme.headline2,
      TextStyle(
        fontSize: 17,
        height: 22 / 17,
        fontFamily: 'Roboto',
        color: AppColors.black,
        fontWeight: FontWeight.normal,
        fontStyle: FontStyle.normal,
        letterSpacing: -0.41,
      ),
    );

    expect(
      textTheme.headline1,
      TextStyle(
        fontSize: 18,
        height: 23 / 18,
        color: AppColors.black,
        fontWeight: FontWeight.bold,
        fontFamily: 'Roboto',
        fontStyle: FontStyle.normal,
      ),
    );
  });

  testWidgets('module2', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(
          textTheme: buildAppTextTheme(),
        ),
        home: FullScreenImage(
          photo: kFlutterDash,
          altDescription: 'This is Flutter dash. I love him :)',
          userName: 'kaparray',
          name: 'Kirill Adeshchenko',
          userPhoto: 'https://skill-branch.ru/img/speakers/Adechenko.jpg',
          heroTag: 'tag',
        ),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(seconds: 2));

    await tester.tap(find.widgetWithIcon(IconButton, Icons.more_vert));

    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('adult'.toUpperCase()), findsOneWidget);
    expect(find.text('spam'.toUpperCase()), findsOneWidget);
    expect(find.text('hate'.toUpperCase()), findsOneWidget);
  });

  testWidgets('module3', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(
          textTheme: buildAppTextTheme(),
        ),
        home: FullScreenImage(
          photo: kFlutterDash,
          altDescription: 'This is Flutter dash. I love him :)',
          userName: 'kaparray',
          name: 'Kirill Adeshchenko',
          userPhoto: 'https://skill-branch.ru/img/speakers/Adechenko.jpg',
          heroTag: 'tag',
        ),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(seconds: 2));

    await tester.tap(find.widgetWithText(GestureDetector, 'Save'));

    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('Download'), findsOneWidget);
    expect(find.text('Close'), findsOneWidget);
  });

  testWidgets('module4', (WidgetTester tester) async {
    StreamController<ConnectivityResult> controller = StreamController<ConnectivityResult>();

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(textTheme: buildAppTextTheme()),
        home: Home(controller.stream),
      ),
    );
    await tester.pump();

    controller.add(ConnectivityResult.none);
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('No internet connection'), findsOneWidget);

    controller.add(ConnectivityResult.wifi);
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('No internet connection'), findsNothing);

    controller.add(ConnectivityResult.none);
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('No internet connection'), findsOneWidget);

    controller.add(ConnectivityResult.mobile);
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('No internet connection'), findsNothing);

    controller.add(ConnectivityResult.none);
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('No internet connection'), findsOneWidget);

    controller.close();
  });
}
