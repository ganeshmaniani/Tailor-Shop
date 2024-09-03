import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/core.dart';
import '../../entities/entites.dart';

class AuthRepository {
  Future<bool> userLogin(LoginEntity loginEntity) async {
    try {
      Map<String, dynamic> body = {
        'email': loginEntity.email,
        'password': loginEntity.password
      };
      Response response =
          await http.post(Uri.parse(AppUrl.loginEndPoint), body: body);
      log(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonDecodeResponse = jsonDecode(response.body);
        if (jsonDecodeResponse['api_success'] == true) {
          final userId = jsonDecodeResponse['user']['id'];
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setInt('user_id', userId);
          return true;
        } else {
          return false;
        }
      } else {
        throw Exception('Invalid creaditial');
      }
    } catch (e) {
      return false;
    }
  }
}
