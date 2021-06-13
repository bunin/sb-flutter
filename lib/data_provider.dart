import 'dart:convert';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'models/auth/model.dart';
import 'models/photo_list/model.dart';
import 'package:http/http.dart' as http;

class DataProvider {
  static String authToken = "";
  static const String _accessKey = const String.fromEnvironment("UNSPLASH_KEY");
  static const String _secretKey =
      const String.fromEnvironment("UNSPLASH_SECRET");
  static const String authUrl =
      'https://unsplash.com/oauth/authorize?client_id=$_accessKey&redirect_uri=urn%3Aietf%3Awg%3Aoauth%3A2.0%3Aoob&response_type=code&scope=public+write_likes';

  static Future<Auth> doLogin({String oneTimeCode = ""}) async {
    var response = await http.post(
        Uri(scheme: 'https', host: 'unsplash.com', path: '/oauth/token'),
        headers: {
          'Content-Type': 'application/json',
        },
        body:
            '{"client_id":"$_accessKey","client_secret":"$_secretKey","redirect_uri":"urn:ietf:wg:oauth:2.0:oob","code":"$oneTimeCode","grant_type":"authorization_code"}');

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return Auth.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error: ${response.reasonPhrase}');
    }
  }

  static Future<Photos> getPhotos(int page, int perPage) async {
    var response = await DefaultCacheManager().getSingleFile(
      'https://api.unsplash.com/photos?page=$page&per_page=$perPage',
      headers: {'Authorization': 'Bearer $authToken'},
    );
    return Photos.fromJson(json.decode(response.readAsStringSync()));
  }

  static Future<Photos> searchPhotos(
      {String keyword = "", int page = 1, int pageSize = 10}) async {
    var response = await DefaultCacheManager().getSingleFile(
        'https://api.unsplash.com/search/photos?page=' +
            page.toString() +
            '&per_page=' +
            pageSize.toString() +
            '&query=' +
            Uri.encodeQueryComponent(keyword),
        headers: {'Authorization': 'Bearer $authToken'});

    Map<String, dynamic> data = jsonDecode(response.readAsStringSync());
    return Photos.fromJson(data['results']);
  }

  static Future<Photo> getRandomPhoto() async {
    var response = await http.get('https://api.unsplash.com/photos/random',
        headers: {'Authorization': 'Bearer $authToken'});

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return Photo.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error: ${response.reasonPhrase}');
    }
  }

  static Future<Photo> getPhoto(String id) async {
    var response = await http.get('https://api.unsplash.com/photos/' + id,
        headers: {'Authorization': 'Bearer $authToken'});

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return Photo.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error: ${response.reasonPhrase}');
    }
  }

  static Future<bool> likePhoto(String photoId) async {
    var response = await http
        .post('https://api.unsplash.com/photos/$photoId/like', headers: {
      'Authorization': 'Bearer $authToken',
    });

    print(response.body);
    print(response.reasonPhrase);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return true; //returns 201 - Created
    } else {
      throw Exception('Error: ${response.reasonPhrase}');
    }
  }

  static Future<bool> unlikePhoto(String photoId) async {
    var response = await http
        .delete('https://api.unsplash.com/photos/$photoId/like', headers: {
      'Authorization': 'Bearer $authToken',
    });

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return true; //returns 201 - Created
    } else {
      throw Exception('Error: ${response.reasonPhrase}');
    }
  }
}
