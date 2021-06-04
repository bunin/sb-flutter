import 'package:flutter/material.dart';
import 'package:FlutterGalleryApp/data_provider.dart';
import 'package:FlutterGalleryApp/models/photo_list/model.dart';

class PhotoListScreen extends StatefulWidget {
  @override
  _PhotoListState createState() => _PhotoListState();
}

class _PhotoListState extends State<PhotoListScreen> {
  ScrollController _scrollController = ScrollController();
  int pageCount = 0;
  bool isLoading = false;
  var data = List<Photo>();

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

  Widget _buildListView(BuildContext context, List<Photo> photos) {
    //TODO: переделать на SingleChildScrollView так, чтобы он занимал весь экран
    return Container(
      height: MediaQuery.of(context).size.height - 80,
      width: 250,
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
              child: _buildPhotoRow(photos[i]),
              onTap: () {
                // Navigator.pop(context, photos[i]);
              });
        },
        itemCount: photos.length,
      ),
    );
  }

  Widget _buildPhotoRow(Photo photo) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Center(
        child: Column(
          children: [
            Stack(children: <Widget>[
              Image.network(
                photo.urls.thumb,
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: RawMaterialButton(
                  elevation: 0.0,
                  child: Icon(
                    Icons.favorite,
                    color: photo.likedByUser ? Colors.redAccent : Colors.white,
                    size: 40,
                  ),
                  onPressed: () async {
                    photo.likedByUser
                        ? DataProvider.unlikePhoto(photo.id)
                        : DataProvider.likePhoto(photo.id);
                    setState(() {
                      photo.likedByUser = !photo.likedByUser;
                    });
                  },
                  constraints: BoxConstraints.tightFor(
                    width: 40,
                    height: 40,
                  ),
                  shape: const CircleBorder(),
                  fillColor: Colors.transparent,
                ),
              )
            ]),
            Text(
              '${photo.altDescription ?? 'sample image'}',
              textAlign: TextAlign.center,
            ),
          ],
        ),
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
