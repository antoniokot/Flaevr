import 'package:flaevr/models/ProductModel.dart';
import 'package:http/http.dart' as http;
import 'package:flaevr/models/Stamp.dart';
import 'package:flaevr/models/ProductStamp.dart';
import 'package:http/http.dart';
import 'dart:convert';

class StampService {
  //get all stamps from a product
  static Future<List<Stamp>> getAllByProductID(int id) async {
    try {
      

      // if (response.statusCode == 200) {
        
      // } else {
      //   // If the server did not return a 200 OK response,
      //   // then throw an exception.
      //   return null;
      // }
    } catch (e) {
      print(e);
      return null;
    }
  }
}
