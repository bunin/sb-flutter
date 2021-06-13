import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gallery_app/data_provider.dart';
import 'package:flutter_gallery_app/models/photo_list/model.dart' as model;
import 'package:flutter_gallery_app/res/colors.dart';
import 'package:flutter_gallery_app/screens/photo_screen.dart';
import 'package:flutter_gallery_app/widgets/search_bar.dart';
import 'package:flutter_gallery_app/widgets/warning.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SearchScreenState();
  }
}

class _SearchScreenState extends State<SearchScreen> {
  ScrollController _scrollController = ScrollController();
  int pageCount = 1;
  bool isLoading = false;
  bool errored = false;
  String query = '';
  var data = <model.Photo>[];
  final TextEditingController _textCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent * 0.8) {
        this._getData(pageCount);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SearchBar(
        controller: _textCtrl,
        clearOnSubmit: false,
        closeOnSubmit: false,
        inBar: true,
        setState: setState,
        buildDefaultAppBar: null,
        showClearButton: false,
        onSubmitted: (q) {
          if (q == query) {
            return;
          }
          setState(() {
            query = q;
            pageCount = 1;
            this.data.clear();
          });
          this._getData(pageCount);
        },
      ).buildSearchBar(context),
      body: errored
          ? Warning("There was an error loading the feed")
          : isLoading && data.length < 1
              ? Center(child: CircularProgressIndicator())
              : (!isLoading &&
                      query != null &&
                      query.isNotEmpty &&
                      (data == null || data.isEmpty))
                  ? Center(
                      child: Text(
                        "Nothing found",
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w500,
                          fontSize: 17,
                          height: 22 / 17,
                          letterSpacing: -0.41,
                          color: AppColors.manatee,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )
                  : _buildListView(context, data),
    );
  }

  Future _onRefresh() {
    setState(() {
      data.clear();
      pageCount = 1;
      isLoading = true;
      print("REFRESH");
      print(query);
    });
    return DataProvider.searchPhotos(
            keyword: query, page: pageCount, pageSize: 15)
        .then((value) {
      setState(() {
        isLoading = false;
        data.addAll(value.photos);
        pageCount++;
      });
    });
  }

  Widget _buildListView(BuildContext ctx, List<model.Photo> photos) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: _onRefresh,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: StaggeredGridView.countBuilder(
            controller: _scrollController,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            itemBuilder: (context, i) {
              return _buildItem(context, data[i], i);
            },
            itemCount: data.length,
            crossAxisCount: 3,
            staggeredTileBuilder: (int index) {
              return index % 18 == 0 || index == 10 || index % 18 == 10
                  ? StaggeredTile.count(2, 2)
                  : StaggeredTile.count(1, 1);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildItem(BuildContext context, model.Photo p, int index) {
    final heroTag = "feedItem_$index";
    print("BUILD ITEM $index");
    return GestureDetector(
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
            height:
                (MediaQuery.of(context).size.width - 20) / p.width * p.height,
            width: (MediaQuery.of(context).size.width - 20),
          ),
        );
      },
      child: Hero(
        tag: heroTag,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(7),
          child: CachedNetworkImage(
              imageUrl: p.urls.small,
              fit: BoxFit.cover,
              placeholder: (context, url) => Center(
                    child: ColoredBox(
                      color: p.color.toColor(),
                      child: SizedBox.expand(),
                    ),
                  ),
              errorWidget: (context, url, error) => Icon(Icons.error)),
        ),
      ),
    );
  }

  void _getData(int page) async {
    try {
      if (!isLoading) {
        setState(() {
          isLoading = true;
          errored = false;
        });
        var tempList = await DataProvider.searchPhotos(
            keyword: query, page: pageCount, pageSize: 15);

        setState(() {
          errored = false;
          isLoading = false;
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
