import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gallery_app/res/res.dart';

class Photo extends StatelessWidget {
  Photo({
    Key key,
    this.photoLink,
    this.bgColor,
    this.height,
    this.width,
  }) : super(key: key);

  final String photoLink;
  final Color bgColor;
  final height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(17)),
        child: Container(
          width: width,
          height: height,
          color: bgColor ?? AppColors.grayChateau,
          child: CachedNetworkImage(
            imageUrl: photoLink,
            placeholder: (context, url) => Center(
              child: ColoredBox(
                color: bgColor ?? AppColors.grayChateau,
                child: SizedBox(
                  height: height,
                  width: width ?? double.infinity,
                ),
              ),
            ),
            errorWidget: (context, url, error) => Icon(Icons.error),
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}
