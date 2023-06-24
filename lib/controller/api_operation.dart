import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:wallpaper_guru/model/category_model.dart';
import 'package:wallpaper_guru/model/photos_model.dart';
import 'dart:math';

class ApiOperations {
  static List<PhotosModel> trendingWallpapers = [];
  static List<PhotosModel> searchWallpapersList = [];
  static List<CategoryModel> categoryModelList = [];

  static String _apiKey =
      '971HLCcKuob60n2iBcAGC4Phmof9J2cgUKolcLfOacKQgkIgPbevKjut';
  static Future<List<PhotosModel>> getTrendingWallpapers() async {
    await http.get(
        Uri.parse(
          'https://api.pexels.com/v1/curated',
        ),
        headers: {'Authorization': '$_apiKey'}).then((value) {
      //print(value.body);

      Map<String, dynamic> jsonData = jsonDecode(value.body);
      List photos = jsonData['photos'];
      photos.forEach((element) {
        trendingWallpapers.add(
          PhotosModel.fromAPI2App(element),
        );
      });
    });
    return trendingWallpapers;
  }

  static Future<List<PhotosModel>> searchWallpapers(String query) async {
    await http.get(
        Uri.parse(
            'https://api.pexels.com/v1/search?query=$query&per_page=30&page=1'),
        headers: {'Authorization': _apiKey}).then((value) {
      Map<String, dynamic> jsonData = jsonDecode(value.body);
      List photos = jsonData['photos'];
      searchWallpapersList.clear();
      photos.forEach((element) {
        searchWallpapersList.add(
          PhotosModel.fromAPI2App(element),
        );
      });
    });
    return searchWallpapersList;
  }

  static List<CategoryModel> getCategoriesList() {
    List categoryName = [
      'Cars',
      'Nature',
      'Bikes',
      'Street',
      'City',
      'Flowers'
    ];
    categoryModelList.clear();
    categoryName.forEach((catName) async {
      final _random = Random();

      PhotosModel photoModel =
          (await searchWallpapers(catName))[0 + _random.nextInt(11 - 0)];
      categoryModelList.add(
        CategoryModel(
          catImgUrl: photoModel.imgSrc,
          catName: catName,
        ),
      );
    });
    return categoryModelList;
  }
}
