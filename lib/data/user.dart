
class User {
  String _username;
  String _password;
  User(this._username, this._password);

  //create a new User object out of a dynamic map object

  User.map(dynamic obj) {
    this._username = obj["username"];
    this._password = obj["password"];
  }

  String get username => _username;
  String get password => _password;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["username"] = _username;
    map["password"] = _password;

    return map;
  }

  Map<String, dynamic> toJson() =>
      {
        'username': _username,
        'password': _password
      };

  User.fromJson(Map<String, dynamic> json)
      : _username = json['username'],
       _password = json['password'];

  String toString() {
    return _username;
  }
}