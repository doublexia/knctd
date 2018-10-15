import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:knctd/utils/RESTDatasource.dart';
import 'package:knctd/data/user.dart';

import 'package:knctd/utils/network_util.dart';

abstract class LoginScreenContract {
  void onLoginSuccess(User user);
  void onLoginError(String errorTxt);
}

class LoginScreenPresenter {
  NetworkUtil _netUtil = new NetworkUtil();

  static final BASE_URL = "http://docunation.com:8880/knctd";
  static final REGISTER_URL = BASE_URL + "/acctregi.php";
  static final LOGIN_URL = BASE_URL + "/acctregi.php";
  static final _API_KEY = "somerandomkey";

  LoginScreenContract _view;
  RestDatasource api = new RestDatasource();
  LoginScreenPresenter(this._view);

  Future<dynamic> doRegister(User user) async {
    _netUtil.post(REGISTER_URL, body: user.toMap()).then((dynamic res) {
      print("Response body: ${res.toString()}");
      _view.onLoginSuccess(new User(user.username, user.password));
    }
    ).catchError((error) {
      print("Exception: " + error.toString());
      _view.onLoginError(error.toString());
    }
    );
  }

  Future<dynamic> doLogin(User user) async {
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
