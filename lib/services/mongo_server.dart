import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

const MONGODB_BASEURL = "https://eu-central-1.aws.data.mongodb-api.com";
const COLLECTION_DATABASE = "lfc_trademore";
const CLUSTER0 = "Cluster0";

class MongoDB {
  static const String APIKEY =
      'LssPdj8u0hQg15mhq6YW6gpfw8WrqRQQKCkC2xDYsRTWOXHTpaHWYawBVJp09M60';

  static var headers = {
    'Content-Type': 'application/json',
  };

  static getData({
    required Map<String, dynamic> filter,
    required Map<String, dynamic> projection,
    required String sortBy,
    required int limit,
    required void Function() showLoading,
    required void Function(dynamic) onDone,
    required void Function(dynamic) onError,
  }) async {
    try {
      showLoading();
      var body = {
        "collection": COLLECTION_DATABASE,
        "database": COLLECTION_DATABASE,
        "dataSource": CLUSTER0,
        "filter": filter,
        "sort": {sortBy: 1},
        "limit": limit,
        "projection": projection,
      };
      Dio dio = Dio();
      String token = await d();
      headers.addAll({'Authorization': 'Bearer $token'});
      var response = await dio
          .post('$MONGODB_BASEURL/app/data-odftm/endpoint/data/v1/action/find',
              options: Options(headers: headers), data: body)
          .timeout(const Duration(seconds: 30));
      if (response.statusCode == 200) {
        var result = response.data['documents'];
        onDone(result);
      } else {
        onError(response.data.toString());
      }
    } catch (_) {
      onError(_.toString());
    }
  }

  static insertData({
    required document,
    required void Function() showLoading,
    required void Function() onDone,
    required void Function(dynamic) onError,
  }) async {
    String token = await d();
    headers.addAll({'Authorization': 'Bearer $token'});
    try {
      showLoading();
      var body = {
        "dataSource": CLUSTER0,
        "database": COLLECTION_DATABASE,
        "collection": COLLECTION_DATABASE,
        "document": document
      };
      Dio dio = Dio();
      var response = await dio.post(
          '$MONGODB_BASEURL/app/data-odftm/endpoint/data/v1/action/insertOne',
          options: Options(headers: headers),
          data: body);
      if (response.statusCode == 201) {
        onDone();
      } else {
        onError('Request failed with status: ${response.data}');
      }
    } catch (_) {
      onError(_.toString());
    }
  }

  static updateData({
    required filter,
    required document,
    bool? isArray,
    bool? upsert,
    required void Function() showLoading,
    required void Function(dynamic) onDone,
    required void Function(dynamic) onError,
  }) async {
    try {
      showLoading();
      var body = {
        "dataSource": CLUSTER0,
        "database": COLLECTION_DATABASE,
        "collection": COLLECTION_DATABASE,
        "filter": filter,
        if (isArray == null)
          "update": {'\$set': document}
        else
          "update": {'\$push': document},
        if (upsert == true) "upsert": upsert
      };
      Dio dio = Dio();
      String token = await d();
      headers.addAll({'Authorization': 'Bearer $token'});
      var response = await dio
          .post(
              '$MONGODB_BASEURL/app/data-odftm/endpoint/data/v1/action/updateOne',
              options: Options(headers: headers),
              data: body)
          .timeout(const Duration(seconds: 30));
          print(response.data);
          print(response.statusMessage);
      if (response.statusCode == 200) {
        onDone(response.toString());
      } else {
        onError(response.toString());
      }
    } catch (_) {
      onError(_.toString());
          

    }
  }

  static deleteData({
    required filter,
    required void Function() showLoading,
    required void Function(dynamic) onDone,
    required void Function(dynamic) onError,
  }) async {
    try {
      showLoading();
      var body = {
        "dataSource": CLUSTER0,
        "database": COLLECTION_DATABASE,
        "collection": COLLECTION_DATABASE,
        "filter": filter,
      };
      Dio dio = Dio();
      String token = await d();
      headers.addAll({'Authorization': 'Bearer $token'});
      var response = await dio
          .post(
              '$MONGODB_BASEURL/app/data-odftm/endpoint/data/v1/action/deleteOne',
              options: Options(headers: headers),
              data: body)
          .timeout(const Duration(seconds: 30));
      print(response.statusCode);
      if (response.statusCode == 200) {
        onDone('Successful');
      } else {
        onError('Error');
      }
    } catch (_) {
      onError(_.toString());
    }
  }

  static d() async {
    var response = await http.post(Uri.parse(
        'https://eu-central-1.aws.realm.mongodb.com/api/client/v2.0/app/data-odftm/auth/providers/anon-user/login'));
    return json.decode(response.body)['access_token'];
  }
}
