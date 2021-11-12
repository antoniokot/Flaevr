import 'package:flaevr/models/ProductModel.dart';
import 'package:http/http.dart' as http;
import 'package:flaevr/utils/sharedAssets.dart';
import 'dart:convert';

class ProductService {
  static Future<List<ProductModel>?> getAllProducts() async {
    try {
      final response =
          await http.get(Uri.parse(SharedAssets.apiURL + '/products/'));

      if (response.statusCode == 200) {
        List<ProductModel> ret = [];
        var decodeJson = jsonDecode(response.body);

        decodeJson.forEach((item) => {
              ret.add(new ProductModel(
                  id: item['idProduct'],
                  name: item['name'],
                  barcode: item['barcode'],
                  pictureUrl: item['pictureUrl']))
            });
        return ret;
      } else {
        return null;
      }
    } catch (e) {
      print("\x1B[33mProductService.dart: x1B[0m" + e.toString());
      return null;
    }
  }

  static Future<ProductModel?> getByID(int id) async {
    try {
      final response = await http
          .get(Uri.parse(SharedAssets.apiURL + '/products/' + id.toString()));

      if (response.statusCode == 200) {
        List<dynamic> values = json.decode(response.body);
        Map<String, dynamic> map = values[0];
        return ProductModel.fromJson(map);
      } else {
        return null;
      }
    } catch (e) {
      print("\x1B[33mProductService.dart: x1B[0m" + e.toString());
      return null;
    }
  }

  //TERMINAR
  static Future<ProductModel?> getByBarcode(String code) async {
    try {
      final response = await http
          .get(Uri.parse(SharedAssets.apiURL + '/products/barcode/' + code));

      if (response.statusCode == 200) {
        List<dynamic> values = json.decode(response.body);
        Map<String, dynamic> map = values[0];
        return ProductModel.fromJson(map);
      } else {
        return null;
      }
    } catch (e) {
      print("\x1B[33mProductService.dart: x1B[0m" + e.toString());
      return null;
    }
  }

  static Future<List<ProductModel>?> getAllProductsInFolder(int id) async {
    try {
      final response = await http.get(
          Uri.parse(SharedAssets.apiURL + '/products/folder/' + id.toString()));

      if (response.statusCode == 200) {
        List<ProductModel> ret = [];
        var decodeJson = jsonDecode(response.body);

        decodeJson.forEach((item) => {
              ret.add(new ProductModel(
                  id: item['idProduct'],
                  name: item['name'],
                  barcode: item['barcode'],
                  pictureUrl: item['pictureUrl']))
            });
        return ret;
      } else {
        return null;
      }
    } catch (e) {
      print("\x1B[33mProductService.dart: x1B[0m" + e.toString());
      return null;
    }
  }

  static Future<List<ProductModel>?> getAllRecentProducts(int idUser) async {
    try {
      final response = await http.get(Uri.parse(
          SharedAssets.apiURL + '/products/user/' + idUser.toString()));

      if (response.statusCode == 200) {
        List<ProductModel> ret = [];
        var decodeJson = jsonDecode(response.body);

        for (var item in decodeJson) {
          ret.add(ProductModel.fromJson(item));
        }
        return ret;
      } else {
        return null;
      }
    } catch (e) {
      print("\x1B[33mProductService.dart: x1B[0m" + e.toString());
      return null;
    }
  }

  static Future<int> getCountOfAllScannedByStamp(
      int idUser, int idStamp) async {
    try {
      final response = await http.get(Uri.parse(SharedAssets.apiURL +
          '/scanns/count/user/' +
          idUser.toString() +
          '/stamp/' +
          idStamp.toString()));

      if (response.statusCode == 200) {
        List<dynamic> values = json.decode(response.body);
        Map<String, dynamic> map = values[0];
        return int.parse(map["total"]);
      } else {
        return 0;
      }
    } catch (e) {
      print("\x1B[33mProductService.dart: x1B[0m" + e.toString());
      return 0;
    }
  }
}
