import 'dart:async';

import 'network_util.dart';
import 'package:knctd/data/user.dart';

//JSON response format if there’s an error:
//
//{ error: true, error_msg: “Invalid credentitals”}
//  JSON response format if there’s no error:
//
//  { error: false, user: { username: “Some username”, password: “Some password” } }

class RestDatasource {
  NetworkUtil _netUtil = new NetworkUtil();
  static final BASE_URL = "http://docunation.com:8880/knctd";
  static final LOGIN_URL = BASE_URL + "/acctregi.php";
  static final _API_KEY = "somerandomkey";

  Future<User> login(User user) {
    return _netUtil.post(LOGIN_URL, /*body: {
      "token": _API_KEY,
      "username": username,
      "password": password
    }, headers: {
      "Accept": "application/json",
      "Content-Type": "application/json"
    }*/
  body: user.toMap()).then((dynamic res) {
      print(res.toString());
//
//      if(res["error"]) throw new Exception(res["error_msg"]);
//      return new User.map(res["user"]);

      return new User(user.username, user.password);
    });
  }
}
