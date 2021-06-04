import 'package:FlutterGalleryApp/res/res.dart';
import 'package:FlutterGalleryApp/screens/feed_screen.dart';
import 'package:FlutterGalleryApp/widgets/claim_bottom_sheet.dart';
import 'package:FlutterGalleryApp/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';

class FullScreenImageArguments {
  final String photo;
  final String altDescription;
  final String userName;
  final String name;
  final String userPhoto;
  final String heroTag;
  final Key key;
  final RouteSettings routeSettings;
  final int likes;
  final bool liked;

  FullScreenImageArguments({
    this.photo,
    this.altDescription,
    this.userName,
    this.name,
    this.userPhoto,
    this.heroTag,
    this.key,
    this.routeSettings,
    this.likes,
    this.liked,
  });
}

class FullScreenImage extends StatefulWidget {
  FullScreenImage({
    Key key,
    this.photo = '',
    this.altDescription = '',
    this.userName = '',
    this.name = '',
    this.userPhoto = '',
    this.heroTag,
    this.likes,
    this.liked,
  }) : super(key: key);

  final String photo;
  final String altDescription;
  final String userName;
  final String name;
  final String userPhoto;
  final String heroTag;
  final int likes;
  final bool liked;

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
  Animation<double> opacityAvatar;
  Animation<double> opacityDescription;

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

    opacityAvatar = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
        parent: controller, curve: Interval(0.0, 0.5, curve: Curves.ease)));

    opacityDescription = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
            parent: controller, curve: Interval(0.5, 1.0, curve: Curves.ease)));

    controller.forward();
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
    print(ModalRoute.of(context).settings.arguments);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Hero(
                  tag: widget.heroTag,
                  child: Photo(photoLink: widget.photo),
                ),
                const SizedBox(height: 11),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    widget.altDescription ?? 'NOTHING',
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.headline3,
                  ),
                ),
                const SizedBox(height: 9),
                _buildPhotoMeta(),
                const SizedBox(height: 17),
                _buildActionButtons(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    // String title = ModalRoute.of(context).settings.arguments;
    return AppBar(
      elevation: 0,
      // backgroundColor: AppColors.white,
      // centerTitle: true,
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
              builder: (context) => ClaimBottomSheet(),
            );
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
        style: Theme.of(context).textTheme.headline2,
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
                  opacity: opacityAvatar,
                  child: child,
                ),
              ),
              SizedBox(
                width: 6,
              ),
              AnimatedBuilder(
                animation: controller,
                builder: (context, child) => FadeTransition(
                  opacity: opacityDescription,
                  child: child,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      name ?? "unknown",
                      style: Theme.of(context).textTheme.headline1,
                    ),
                    Text(
                      "@" + (userName ?? "unknown"),
                      style: Theme.of(context)
                          .textTheme
                          .headline5
                          .copyWith(color: AppColors.manatee),
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

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          LikeButton(widget.likes ?? 0, widget.liked ?? false),
          SizedBox(width: 14),
          Expanded(
            child: _buildButton("Save", () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('download photos'),
                      content:
                          Text('Are you sure you want to download a photo?'),
                      actions: [
                        FlatButton(
                          onPressed: () {
                            GallerySaver.saveImage(photo)
                                .then((value) => Navigator.of(context).pop());
                          },
                          child: Text('Download'),
                        ),
                        FlatButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text('Close'),
                        ),
                      ],
                    );
                  });
              return;
            }),
          ),
          const SizedBox(
            width: 12,
          ),
          Expanded(
            child: _buildButton("Visit", () async {
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
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
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
              overlayEntry?.remove();
              return;
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(String text, VoidCallback callback) {
    return GestureDetector(
      onTap: callback,
      child: Container(
        height: 36,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          color: AppColors.dodgerBlue,
        ),
        // padding: EdgeInsets.all(7),
        child: Center(
          child: Text(
            text,
            style: Theme.of(context)
                .textTheme
                .headline4
                .copyWith(color: AppColors.white),
          ),
        ),
      ),
    );
  }
}
