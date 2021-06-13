import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_gallery_app/data_provider.dart';
import 'package:flutter_gallery_app/res/res.dart';
import 'package:flutter/material.dart';

class LikeButton extends StatefulWidget {
  LikeButton({this.likeCount, this.isLiked, this.photoID, Key key})
      : super(key: key);

  final int likeCount;
  final bool isLiked;
  final String photoID;

  @override
  State<StatefulWidget> createState() {
    return _LikeButtonState();
  }
}

class _LikeButtonState extends State<LikeButton> {
  bool isLiked;
  int likeCount;

  @override
  void initState() {
    super.initState();
    isLiked = widget.isLiked;
    likeCount = widget.likeCount;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        print("LIKE");
        print(widget.photoID);
        if (!isLiked) {
          DataProvider.likePhoto(widget.photoID).then((value) {
            setState(() {
              isLiked = !isLiked;
              likeCount++;
              DefaultCacheManager().emptyCache(); // todo: clear only related files
            });
          }).onError((error, stackTrace) => showDialog(
              context: context,
              builder: (_) => AlertDialog(
                    title: Text('Error'),
                    content: Text('There was an error performing action'),
                  )));
        } else {
          DataProvider.unlikePhoto(widget.photoID).then((value) {
            setState(() {
              isLiked = !isLiked;
              likeCount++;
              DefaultCacheManager().emptyCache(); // todo: clear only related files
            });
          }).onError((error, stackTrace) => showDialog(
              context: context,
              builder: (_) => AlertDialog(
                    title: Text('Error'),
                    content: Text('There was an error performing action'),
                  )));
        }
      },
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Row(
            children: <Widget>[
              Icon(isLiked ? AppIcons.like_fill : AppIcons.like),
              SizedBox(
                width: 4.21,
              ),
              Text(
                likeCount.toString(),
                style: TextStyle(
                  color: AppColors.black,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  height: 14 / 16,
                  letterSpacing: 0.75,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
