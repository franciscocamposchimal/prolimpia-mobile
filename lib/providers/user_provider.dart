import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:prolimpia_mobile/models/collect_model.dart';
import 'package:prolimpia_mobile/models/current_user_model.dart';
import 'package:prolimpia_mobile/shared_preferences/shared_preferences.dart';

class UserProvider {
  final _prefs = new PreferenciasUsuario();
  String _url = 'http://192.168.100.199:8000/api/users';

  Future<Map<String, dynamic>> login(String email, String pass) async {
    final data = new Map<String, dynamic>();
    final url = '$_url/login';

    final bodyToLogin = {'email': email, 'password': pass};
    final response = await http.post(url, body: bodyToLogin);

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    data['status'] = response.statusCode;
    if (response.statusCode == 200) {
      final decodeData = json.decode(response.body);
      final currentUser = new CurrentUser.fromJson(decodeData);
      _prefs.user = currentUser;
      data['user'] = currentUser;
      return data;
    } else {
      data['user'] = null;
      return data;
    }
  }

  Future<Map<String, dynamic>> check() async {
    print('CHECK');
    final data = new Map<String, dynamic>();
    final url = '$_url/check';
    print(_prefs.user.token);

    final authorizationHeaders = {
      HttpHeaders.authorizationHeader: 'bearer ${_prefs.user.token}'
    };

    final response = await http.get(url, headers: authorizationHeaders);
    print('Response status: ${response.statusCode}');

    /*if (response.statusCode == 200) {
      final decodeData = json.decode(response.body);
      final currentUser = new CurrentUser.fromJson(decodeData);
      _prefs.user = currentUser;
      data['user'] = currentUser;
    }*/

    data['status'] = response.statusCode;
    return data;
  }

  Future<Map<String, dynamic>> logout() async {
    print('LOGOUT');
    final data = new Map<String, dynamic>();
    final url = '$_url/logout';

    final authorizationHeaders = {
      HttpHeaders.authorizationHeader: 'bearer ${_prefs.user.token}'
    };

    final response = await http.get(url, headers: authorizationHeaders);
    print('Response status: ${response.statusCode}');

    data['status'] = response.statusCode;
    return data;
  }

    Future<Map<String, dynamic>> getCollect() async {
    print('GETCOLLECT');
    final data = new Map<String, dynamic>();
    final url = '$_url/collects';

    final authorizationHeaders = {
      HttpHeaders.authorizationHeader: 'bearer ${_prefs.user.token}'
    };

    final response = await http.get(url, headers: authorizationHeaders);
    print('Response status: ${response.statusCode}');

    data['status'] = response.statusCode;
    if (response.statusCode == 200) {
      final decodeData = json.decode(response.body);
      final collectUser = new Collect.fromJson(decodeData);
      data['body'] = collectUser;
      return data;
    } else {
      data['body'] = null;
      return data;
    }
  }

}
