import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:knctd/utils/RESTDatasource.dart';
import 'package:knctd/utils/user.dart';

import 'package:knctd/utils/network_util.dart';

abstract class LoginScreenContract {
  void onLoginSuccess(User user);
  void onLoginError(String errorTxt);
}

class LoginScreenPresenter {
  NetworkUtil _netUtil = new NetworkUtil();

  static final BASE_URL = "http://docunation.com:8880/knctd";
  static final LOGIN_URL = BASE_URL + "/acctregi.php";
  static final _API_KEY = "somerandomkey";

  LoginScreenContract _view;
  RestDatasource api = new RestDatasource();
  LoginScreenPresenter(this._view);

  Future<dynamic> doLogin(User user) async {
//    api.login(username, password).then((User user) {
//      _view.onLoginSuccess(user);
//    }).catchError((Exception error) => _view.onLoginError(error.toString()));

//    http.post(LOGIN_URL,
//        body: '{"username": "${username}", "password": "${password}"}',
//        headers: {
//          "Accept": "application/json",
//          "Content-Type": "application/json"
//        }).then((response) {
//          final String res = response.body;
//          final int statusCode = response.statusCode;
//
//          print("Response body: ${response.body}");
//          if (statusCode < 200 || statusCode > 400 || json == null) {
//            //throw new Exception("Error while fetching data");
//            _view.onLoginError("Error while fetching data");
//          }
//          _view.onLoginSuccess(new User(username, password));
//        });

    _netUtil.post(LOGIN_URL, body: user.toMap()).then((dynamic res) {
      print("Response body: ${res.toString()}");
      _view.onLoginSuccess(new User(user.username, user.password));
    }
    ).catchError((error) {
      print("Exception: " + error.toString());
      _view.onLoginError(error.toString());
    }
    );
  }
}
