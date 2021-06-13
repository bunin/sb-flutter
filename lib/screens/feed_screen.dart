import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gallery_app/data_provider.dart';
import 'package:flutter_gallery_app/models/photo_list/model.dart' as model;
import 'package:flutter_gallery_app/screens/photo_screen.dart';
import 'package:flutter_gallery_app/widgets/warning.dart';
import 'package:flutter_gallery_app/widgets/widgets.dart';

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
  int pageCount = 1;
  bool isLoading = false;
  bool initialLoading = true;
  bool errored = false;
  var data = <model.Photo>[];

  @override
  void initState() {
    this._getData(pageCount);
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
    return errored
        ? Warning("There was an error loading the feed")
        : initialLoading
            ? Center(child: CircularProgressIndicator())
            : _buildListView(context, data);
  }

  Future _onRefresh() {
    setState(() {
      data.clear();
      pageCount = 1;
    });
    return DataProvider.getPhotos(pageCount, 15).then((value) {
      setState(() {
        isLoading = false;
        initialLoading = false;
        data.addAll(value.photos);
        pageCount++;
      });
    });
  }

  Widget _buildListView(BuildContext ctx, List<model.Photo> photos) {
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
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
              child: _buildItem(context, photos[i], i),
              onTap: () {
                // Navigator.pop(context, photos[i]);
              });
        },
        itemCount: photos.length,
      ),
    );
  }

  Widget _buildItem(BuildContext context, model.Photo p, int index) {
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
                photo: p.urls.regular,
                altDescription: p.altDescription,
                userName: p.user.username,
                name: p.user.name,
                userPhoto: p.user.profileImage.small,
                heroTag: heroTag,
                likes: p.likes,
                liked: p.likedByUser,
                color: p.color.toColor(),
                height: p.height.toDouble(),
                width: p.width.toDouble(),
              ),
            );
          },
          child: Hero(
            tag: heroTag,
            child: Photo(
              photoLink: p.urls.regular,
              bgColor: p.color.toColor(),
              height:
                  (MediaQuery.of(context).size.width - 20) / p.width * p.height,
              width: (MediaQuery.of(context).size.width - 20),
            ),
          ),
        ),
        _buildPhotoMeta(index),
        ...(p.altDescription != null || p.description != null)
            ? [
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 5, 10, 10),
                  child: Text(
                    p.altDescription ?? p.description ?? "",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .headline3
                        .copyWith(color: Color(0xFFB2BBC6)),
                  ),
                ),
              ]
            : [SizedBox(height: 10)],
        ColoredBox(
          color: Color(0xFFE7E7E7),
          child: SizedBox(
            height: 1,
            width: double.infinity,
          ),
        )
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
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    data[index].user.name,
                    style: Theme.of(context).textTheme.headline2,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '@' + data[index].user.username,
                    style: Theme.of(context)
                        .textTheme
                        .headline5
                        .copyWith(color: Color(0xFF8E8E93)),
                  ),
                ],
              ),
            ],
          ),
          LikeButton(
            likeCount: data[index].likes,
            isLiked: data[index].likedByUser,
            photoID: data[index].id,
          ),
        ],
      ),
    );
  }

  void _getData(int page) async {
    print("get data");
    try {
      if (!isLoading) {
        setState(() {
          isLoading = true;
          errored = false;
        });
        var tempList = await DataProvider.getPhotos(page, 15);

        setState(() {
          errored = false;
          isLoading = false;
          initialLoading = false;
          data.addAll(tempList.photos);
          pageCount++;
        });
      }
    } catch (e) {
      print(e);
      setState(() {
        errored = true;
      });
    }
  }
}

extension ColorExtension on String {
  toColor() {
    var hexColor = this.replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    if (hexColor.length == 8) {
      return Color(int.parse("0x$hexColor"));
    }
  }
}
