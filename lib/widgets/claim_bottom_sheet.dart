import 'package:FlutterGalleryApp/res/res.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ClaimBottomSheet extends StatelessWidget {
  static const items = ['adult', 'harm', 'bully', 'spam', 'copyright', 'hate'];

  @override
  Widget build(BuildContext context) {
    VoidCallback handler = Navigator.of(context).pop;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.mercury,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: items
            .map((e) => InkWell(
                  onTap: handler,
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      e.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline2.copyWith(),
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }
}
