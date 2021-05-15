import 'package:FlutterGalleryApp/res/res.dart';
import 'package:FlutterGalleryApp/screens/photo_screen.dart';
import 'package:FlutterGalleryApp/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const String kFlutterDash =
    'https://flutter.dev/assets/404/dash_nest-c64796b59b65042a2b40fae5764c13b7477a592db79eaf04c86298dcb75b78ea.png';

class Feed extends StatefulWidget {
  Feed({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _FeedState();
  }
}

class _FeedState extends State<Feed> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          itemCount: 10,
          itemBuilder: (BuildContext context, int index) {
            return Column(
              children: <Widget>[
                _buildItem(index),
                Divider(
                  thickness: 2,
                  color: AppColors.mercury,
                ),
              ],
            );
          }),
    );
  }

  Widget _buildItem(int index) {
    final heroTag = "feedItem_$index";
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                '/fullScreenImage',
                arguments: FullScreenImageArguments(
                  photo: kFlutterDash,
                  altDescription: 'This is Flutter dash. I love him :)',
                  userName: 'kaparray',
                  name: 'Kirill Adeshchennko',
                  userPhoto:
                      'https://skill-branch.ru/img/speakers/Adechenko.jpg',
                  heroTag: heroTag,
                  routeSettings: RouteSettings(arguments: kFlutterDash),
                ),
              );
            },
            child: Hero(tag: heroTag, child: Photo(photoLink: kFlutterDash))),
        _buildPhotoMeta(index),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Text(
            'This is flutter dash. I love him :)',
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context)
                .textTheme
                .headline3
                .copyWith(color: AppColors.black),
          ),
        ),
      ],
    );
  }

  Widget _buildPhotoMeta(int index) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              UserAvatar('https://skill-branch.ru/img/speakers/Adechenko.jpg'),
              SizedBox(
                width: 6,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'bunin',
                    style: Theme.of(context).textTheme.headline2,
                  ),
                  Text(
                    '@bunin',
                    style: Theme.of(context)
                        .textTheme
                        .headline5
                        .copyWith(color: AppColors.manatee),
                  ),
                ],
              ),
            ],
          ),
          LikeButton(10, true),
        ],
      ),
    );
  }
}
