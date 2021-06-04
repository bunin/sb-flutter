import 'package:FlutterGalleryApp/data_provider.dart';
import 'package:FlutterGalleryApp/res/res.dart';
import 'package:FlutterGalleryApp/screens/photo_screen.dart';
import 'package:FlutterGalleryApp/widgets/widgets.dart';
import 'package:FlutterGalleryApp/models/photo_list/model.dart' as model;
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
  ScrollController _scrollController = ScrollController();
  int pageCount = 0;
  bool isLoading = false;
  var data = <model.Photo>[];

  @override
  void initState() {
    this._getData(pageCount);
    print('load data');
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent * 0.8) {
        _getData(pageCount);
      }
    });
    print('set listener');
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text("Unsplash photos"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[_buildListView(context, data)],
        ),
      ),
      resizeToAvoidBottomInset: false,
    );
  }

  Widget _buildListView(BuildContext ctx, List<model.Photo> photos) {
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(ctx).size.height - 193,
        child: ListView.builder(
          controller: _scrollController,
          itemBuilder: (context, i) {
            if (i == data.length) {
              return Center(
                child: Opacity(
                  opacity: isLoading ? 1 : 0,
                  child: CircularProgressIndicator(),
                ),
              );
            }
            return GestureDetector(
                child: _buildItem(photos[i], i),
                onTap: () {
                  // Navigator.pop(context, photos[i]);
                });
          },
          itemCount: photos.length,
        ),
      ),
    );
  }

  Widget _buildItem(model.Photo p, int index) {
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
                  photo: p.urls.full,
                  altDescription: p.altDescription,
                  userName: p.user.username,
                  name: p.user.name,
                  userPhoto: p.user.profileImage.small,
                  heroTag: heroTag,
                  likes: p.likes,
                  liked: p.likedByUser,
                  routeSettings: RouteSettings(arguments: p.urls.full),
                ),
              );
            },
            child: Hero(tag: heroTag, child: Photo(photoLink: p.urls.full))),
        _buildPhotoMeta(index),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Text(
            p.altDescription ?? p.description ?? "",
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
              UserAvatar(data[index].user.profileImage.small),
              SizedBox(
                width: 6,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    data[index].user.name,
                    style: Theme.of(context).textTheme.headline2,
                  ),
                  Text(
                    '@' + data[index].user.username,
                    style: Theme.of(context)
                        .textTheme
                        .headline5
                        .copyWith(color: AppColors.manatee),
                  ),
                ],
              ),
            ],
          ),
          LikeButton(data[index].likes, data[index].likedByUser),
        ],
      ),
    );
  }

  void _getData(int page) async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
      var tempList = await DataProvider.getPhotos(page, 10);

      setState(() {
        isLoading = false;
        data.addAll(tempList.photos);
        pageCount++;
      });
    }
  }
}
