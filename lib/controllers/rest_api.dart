import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RestApi {

  static Future<http.Response?> getDataFromServer(String url, Map<String,dynamic> params,) async {
    http.Response? response;

    try{
      //debugPrint('=======$url====$method===${jsonEncode(params)}');

      Map<String, String> mapHeader = {
        "Content-Type": "application/json",
      };

      response = await http.post(
        Uri.parse(url),
        headers: mapHeader,
        body: jsonEncode(params),
      );

      //debugPrint('=========Response: ${response.body}=====${response.statusCode}=');
    }
    catch(e) {
      debugPrint('=========Error http: $e');
    }

    return response;
  }

}