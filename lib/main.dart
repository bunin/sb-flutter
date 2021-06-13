import 'package:flutter/material.dart';
import 'package:flutter_gallery_app/app.dart';
import 'package:flutter_gallery_app/res/res.dart';

void main() {
  // debugRepaintRainbowEnabled = true;
  runApp(MyApp());
}

class ConnectivityOverlay {
  static final ConnectivityOverlay _singleton = ConnectivityOverlay._internal();

  factory ConnectivityOverlay() {
    return _singleton;
  }

  ConnectivityOverlay._internal();

  static OverlayEntry? overlayEntry;

  void showOverlay(BuildContext context, Widget child) {
    OverlayState? overlayState = Overlay.of(context);
    overlayEntry = OverlayEntry(
        builder: (ctx) => Container(
              color: AppColors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.wifi_off_rounded,
                    color: Color(0xFFB2BBC6),
                    size: 60,
                  ),
                  Text(
                    'No internet connection',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: AppColors.manatee,
                        decoration: TextDecoration.none,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                        height: 22 / 15,
                        letterSpacing: -0.41),
                  ),
                ],
              ),
            ));

    overlayState?.insert(overlayEntry!);
  }

  void removeOverlay(BuildContext context) {
    overlayEntry?.remove();
  }
}
