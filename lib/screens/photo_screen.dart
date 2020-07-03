import 'package:FlutterGalleryApp/res/res.dart';
import 'package:FlutterGalleryApp/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FullScreenImage extends StatelessWidget {
  FullScreenImage(
      {Key key, this.photo, this.altDescription, this.userName, this.name})
      : super(key: key);

  final String photo;
  final String altDescription;
  final String userName;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Photo'),
        leading: IconButton(
          icon: Icon(CupertinoIcons.back),
          onPressed: () {},
        ),
      ),
      body: Column(
        children: <Widget>[
          Photo(photoLink: photo ?? ""),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Text(
              altDescription ?? "",
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: AppStyles.h3,
            ),
          ),
          _buildPhotoMeta(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                _buildButton("Save", () {}),
                SizedBox(width: 12,),
                _buildButton("Visit", () {}),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(String text, void Function() handler) {
    return GestureDetector(
      onTap: handler,
      child: Container(
        width: 105,
        height: 36,
        padding: EdgeInsets.all(7),
        child: Center(
          child: Text(
            text,
            style: AppStyles.h4
                .copyWith(color: AppColors.white, fontWeight: FontWeight.w500),
          ),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          color: AppColors.dodgerBlue,
        ),
      ),
    );
  }

  Widget _buildPhotoMeta() {
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
                    name ?? "unknown",
                    style: AppStyles.h1Black,
                  ),
                  Text(
                    "@" + (userName ?? "unknown"),
                    style: AppStyles.h5Black.copyWith(color: AppColors.manatee),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
