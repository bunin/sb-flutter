import 'package:FlutterGalleryApp/res/res.dart';
import 'package:FlutterGalleryApp/screens/feed_screen.dart';
import 'package:FlutterGalleryApp/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FullScreenImageArguments {
  final String photo;
  final String altDescription;
  final String userName;
  final String name;
  final String userPhoto;
  final String heroTag;
  final Key key;
  final RouteSettings routeSettings;

  FullScreenImageArguments({
    this.photo,
    this.altDescription,
    this.userName,
    this.name,
    this.userPhoto,
    this.heroTag,
    this.key,
    this.routeSettings,
  });
}

class FullScreenImage extends StatefulWidget {
  FullScreenImage(
      {Key key,
      this.photo,
      this.altDescription,
      this.userName,
      this.name,
      this.userPhoto,
      this.heroTag})
      : super(key: key);

  final String photo;
  final String altDescription;
  final String userName;
  final String name;
  final String userPhoto;
  final String heroTag;

  @override
  State<StatefulWidget> createState() {
    return _FullScreenImageState();
  }
}

class _FullScreenImageState extends State<FullScreenImage>
    with TickerProviderStateMixin {
  String photo;
  String name;
  String userName;
  String userPhoto;
  String altDescription;
  String heroTag;

  AnimationController controller;

  Animation<double> userOpacity;
  Animation<double> columnOpacity;

  @override
  void initState() {
    super.initState();
    photo = widget.photo != null ? widget.photo : kFlutterDash;
    name = widget.name != null ? widget.name : '';
    userName = widget.userName != null ? '@' + widget.userName : '';
    userPhoto = widget.userPhoto != null
        ? widget.userPhoto
        : 'https://skill-branch.ru/img/speakers/Adechenko.jpg';
    altDescription = widget.altDescription != null ? widget.altDescription : '';
    heroTag = widget.heroTag;

    controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    userOpacity = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
        parent: controller, curve: Interval(0.0, 0.5, curve: Curves.ease)));

    columnOpacity = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
        parent: controller, curve: Interval(0.5, 1.0, curve: Curves.ease)));

    _playAnimation();
  }

  Future<void> _playAnimation() async {
    try {
      await controller.forward().orCancel;
    } on TickerCanceled {
      // the animation got canceled, probably because it was disposed of
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Column(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Hero(tag: "$heroTag", child: Photo(photoLink: photo ?? "")),
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    _buildButton("Save", () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Alert Dialog title'),
                              content: Text('Alert Dialog body'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: Text('Ok'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: Text('Cancel'),
                                ),
                              ],
                            );
                          });
                      return;
                    }),
                    SizedBox(
                      width: 12,
                    ),
                    _buildButton("Visit", () async {
                      OverlayState overlayState = Overlay.of(context);
                      OverlayEntry overlayEntry = OverlayEntry(
                          builder: (ctx) => Positioned(
                              top: MediaQuery.of(context).viewInsets.top + 50,
                              child: Material(
                                color: Colors.transparent,
                                child: Container(
                                  alignment: Alignment.center,
                                  width: MediaQuery.of(context).size.width,
                                  child: Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    padding:
                                        EdgeInsets.fromLTRB(16, 10, 16, 10),
                                    decoration: BoxDecoration(
                                      color: AppColors.mercury,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text('SkillBranch'),
                                  ),
                                ),
                              )));

                      overlayState.insert(overlayEntry);
                      await Future.delayed(Duration(seconds: 1));
                      overlayEntry.remove();
                      return;
                    }),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    // String title = ModalRoute.of(context).settings.arguments;
    return AppBar(
      backgroundColor: AppColors.white,
      centerTitle: true,
      elevation: 0,
      actions: [
        IconButton(
          icon: Icon(
            Icons.more_vert,
            color: AppColors.grayChateau,
          ),
          onPressed: () {
            showModalBottomSheet(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                context: context,
                builder: (context) {
                  return ClipRRect(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.mercury,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(10, (index) => FlutterLogo()),
                      ),
                    ),
                  );
                });
          },
        ),
      ],
      leading: IconButton(
        icon: Icon(
          CupertinoIcons.back,
          color: AppColors.grayChateau,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        'Photo',
        style: AppStyles.h2Black,
      ),
    );
  }

  Widget _buildButton(String text, VoidCallback handler) {
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
              AnimatedBuilder(
                child: UserAvatar(userPhoto),
                animation: controller,
                builder: (context, child) => FadeTransition(
                  opacity: userOpacity,
                  child: child,
                ),
              ),
              SizedBox(
                width: 6,
              ),
              AnimatedBuilder(
                animation: controller,
                builder: (context, child) => FadeTransition(
                  opacity: columnOpacity,
                  child: child,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      name ?? "unknown",
                      style: AppStyles.h1Black,
                    ),
                    Text(
                      "@" + (userName ?? "unknown"),
                      style:
                          AppStyles.h5Black.copyWith(color: AppColors.manatee),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
