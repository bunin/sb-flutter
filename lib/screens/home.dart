import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gallery_app/main.dart';
import 'package:flutter_gallery_app/res/res.dart';
import 'package:flutter_gallery_app/screens/feed_screen.dart';
import 'package:flutter_gallery_app/screens/search_screen.dart';

class Home extends StatefulWidget {
  final Stream<ConnectivityResult> onConnectivityChanged;

  Home(this.onConnectivityChanged);

  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  int currentTab = 1; // todo set to 0
  final PageStorageBucket bucket = PageStorageBucket();
  StreamSubscription subscription;

  List<Widget> pages = [
    Feed(key: PageStorageKey('FeedPage')),
    SearchScreen(key: PageStorageKey('SearchPage')),
    Container(),
  ];

  final List<BottomNavyBarItem> _tabs = [
    BottomNavyBarItem(
      asset: AppIcons.home,
      title: Text('Home'),
      activeColor: AppColors.dodgerBlue,
      inactiveColor: AppColors.manatee,
    ),
    BottomNavyBarItem(
      asset: Icons.search,
      title: Text('Search'),
      activeColor: AppColors.dodgerBlue,
      inactiveColor: AppColors.manatee,
    ),
    BottomNavyBarItem(
      asset: Icons.person,
      title: Text('User'),
      activeColor: AppColors.dodgerBlue,
      inactiveColor: AppColors.manatee,
    ),
  ];

  @override
  void initState() {
    super.initState();
    subscription =
        widget.onConnectivityChanged.listen((ConnectivityResult result) {
      switch (result) {
        case ConnectivityResult.wifi:
          ConnectivityOverlay().removeOverlay(context);
          break;
        case ConnectivityResult.mobile:
          setState(() {});
          ConnectivityOverlay().removeOverlay(context);
          break;
        case ConnectivityResult.none:
          setState(() {});
          ConnectivityOverlay().showOverlay(context, widget);
          break;
      }
    });
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      bottomNavigationBar: BottomNavyBar(
          showElevation: true,
          itemCornerRadius: 8,
          curve: Curves.ease,
          items: _tabs,
          currentTab: currentTab,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          onItemSelected: (int index) {
            setState(() {
              currentTab = index;
            });
          }),
      body: PageStorage(
        child: pages[currentTab],
        bucket: bucket,
      ),
      resizeToAvoidBottomInset: false,
      extendBody: false,
      extendBodyBehindAppBar: true,
    );
  }
}

class BottomNavyBar extends StatelessWidget {
  final Color backgroundColor;
  final bool showElevation;
  final Duration animationDuration;
  final List<BottomNavyBarItem> items;
  final ValueChanged<int> onItemSelected;
  final MainAxisAlignment mainAxisAlignment;
  final double itemCornerRadius;
  final double containerHeight;
  final Curve curve;
  final int currentTab;

  BottomNavyBar({
    Key key,
    this.currentTab,
    this.showElevation = true,
    this.backgroundColor,
    this.itemCornerRadius = 24,
    this.containerHeight = 57,
    this.animationDuration = const Duration(milliseconds: 270),
    this.mainAxisAlignment = MainAxisAlignment.spaceBetween,
    @required this.items,
    @required this.onItemSelected,
    this.curve = Curves.linear,
  }) : super(key: key) {
    assert(items != null);
    assert(items.length >= 2 && items.length <= 5);
    assert(onItemSelected != null);
    assert(curve != null);
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = (backgroundColor == null)
        ? Theme.of(context).bottomAppBarColor
        : backgroundColor;

    return SafeArea(
        child: Container(
      decoration: BoxDecoration(
        color: bgColor,
        boxShadow: [
          if (showElevation)
            const BoxShadow(color: Colors.white, blurRadius: 16)
        ],
      ),
      width: double.infinity,
      height: containerHeight,
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      child: Row(
        mainAxisAlignment: mainAxisAlignment,
        children: items.map((item) {
          var index = items.indexOf(item);
          return GestureDetector(
            onTap: () => onItemSelected(index),
            child: _ItemWidget(
              item: item,
              isSelected: currentTab == index,
              backgroundColor: bgColor,
              itemCornerRadius: itemCornerRadius,
              animationDuration: animationDuration,
              curve: curve,
            ),
          );
        }).toList(),
      ),
    ));
  }
}

class _ItemWidget extends StatelessWidget {
  final bool isSelected;
  final BottomNavyBarItem item;
  final Color backgroundColor;
  final double itemCornerRadius;
  final Duration animationDuration;
  final Curve curve;

  const _ItemWidget({
    Key key,
    @required this.item,
    @required this.isSelected,
    @required this.backgroundColor,
    @required this.animationDuration,
    @required this.itemCornerRadius,
    this.curve = Curves.linear,
  })  : assert(isSelected != null),
        assert(item != null),
        assert(backgroundColor != null),
        assert(animationDuration != null),
        assert(itemCornerRadius != null),
        assert(curve != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      width: MediaQuery.of(context).size.width / 3 - 16 * 3,
      height: double.maxFinite,
      duration: animationDuration,
      curve: curve,
      // padding: const EdgeInsets.symmetric(horizontal: 8),
      // decoration: BoxDecoration(
      //   color: isSelected ? item.activeColor.withOpacity(0.2) : backgroundColor,
      //   borderRadius: BorderRadius.circular(itemCornerRadius),
      // ),
      child: Column(
        children: <Widget>[
          Icon(
            item.asset,
            size: 20,
            color: isSelected ? item.activeColor : item.inactiveColor,
          ),
          SizedBox(
            height: 4,
          ),
          DefaultTextStyle.merge(
            style: TextStyle(
              color: isSelected ? item.activeColor : item.inactiveColor,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            textAlign: item.textAlign,
            child: item.title,
          ),
        ],
      ),
    );
  }
}

class BottomNavyBarItem {
  final IconData asset;
  final Text title;
  final Color activeColor;
  final Color inactiveColor;
  final TextAlign textAlign;

  BottomNavyBarItem(
      {@required this.asset,
      @required this.title,
      this.activeColor = Colors.blue,
      this.textAlign,
      this.inactiveColor}) {
    assert(asset != null);
    assert(title != null);
  }
}
