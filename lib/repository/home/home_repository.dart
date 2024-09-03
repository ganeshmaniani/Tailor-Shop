import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../../core/core.dart';
import '../../model/model.dart';

class HomeRepository {
  Future<User?> getUserDetail(int id) async {
    try {
      Response response =
          await http.get(Uri.parse("${AppUrl.userDetailEndPoint}?id=$id"));
      log(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonDecodeResponse = jsonDecode(response.body);
        if (jsonDecodeResponse != null) {
          User user = User.fromJson(jsonDecodeResponse['users']);
          return user;
        } else {
          return null;
        }
      }
    } catch (e) {
      throw Exception(e.toString());
    }
    return null;
  }

  Future<BookingListCount?> getListCount() async {
    try {
      Response response =
          await http.get(Uri.parse(AppUrl.bookingListCountEndPoint));
      log(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonDecodeResponse = jsonDecode(response.body);
        if (jsonDecodeResponse != null) {
          BookingListCount bookingListCount =
              BookingListCount.fromJson(jsonDecodeResponse);
          return bookingListCount;
        } else {
          return null;
        }
      }
    } catch (e) {
      throw Exception(e.toString());
    }
    return null;
  }
}
