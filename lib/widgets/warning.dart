import 'package:flutter_gallery_app/res/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Warning extends StatelessWidget {
  final String text;

  Warning(this.text);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.amaranth,
          borderRadius: BorderRadius.circular(5),
        ),
        padding: EdgeInsets.all(15),
        child: Row(
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: AppColors.white,
            ),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                text,
                style: Theme.of(context)
                    .textTheme
                    .headline5
                    .copyWith(color: AppColors.white, height: 15.23 / 13),
              ),
            )
          ],
        ),
      ),
    );
  }
}
