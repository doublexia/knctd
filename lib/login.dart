// Copyright 2016 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:convert';
import 'package:knctd/data/user.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:knctd/screens/login_screen_presenter.dart';
import 'package:knctd/utils/auth.dart';
import 'package:knctd/data/db_helper.dart';
import 'package:knctd/screens/passwd_field.dart';
import 'package:knctd/screens/all_list.dart';

enum LoginFormMode { SignUp, SignIn }

class LoginForm extends StatefulWidget {
  static String route = '/signup';

  LoginFormMode _loginMode;

  LoginForm(this._loginMode, {Key key}) : super(key: key);

  static const String routeName = '/material/text-form-field';

  @override
  SignupFormFieldDemoState createState() =>
      new SignupFormFieldDemoState.LoginFormState();
}

class PersonData {
  String name = '';
  String phoneNumber = '';
  String email = '';
  String password = '';
}

class SignupFormFieldDemoState extends State<LoginForm>
    implements LoginScreenContract, AuthStateListener {
  static const LoadTimestampChannel =
      const MethodChannel('knctd.twohandslabs.com/timestamp');
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  BuildContext _ctx;

  PersonData person = new PersonData();

  LoginScreenPresenter _presenter;
  bool _isLoading = false;

  int _last_ts = 0;

  SignupFormFieldDemoState.LoginFormState() {
    _presenter = new LoginScreenPresenter(this);
//    var authStateProvider = new AuthStateProvider();
//    authStateProvider.subscribe(this);
  }
  @override
  void initState() {
    super.initState();
    //_loadLastTimestamp();
  }

  @override
  void dispose() {
    super.dispose();
//    var authStateProvider = new AuthStateProvider();
//    authStateProvider.dispose(this);
  }

  /*
  _loadLastTimestamp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _last_ts = (prefs.getInt('screen_idle_tag') ?? 0);
    });
  }
*/
  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  bool _autovalidate = false;
  bool _formWasEdited = false;

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<FormFieldState<String>> _passwordFieldKey =
      new GlobalKey<FormFieldState<String>>();
  final _UsNumberTextInputFormatter _phoneNumberFormatter =
      new _UsNumberTextInputFormatter();

  Future<Null> _askToWait() async {
    switch (await showDialog<Null>(
        context: context,
        builder: (BuildContext context) {
          return new SimpleDialog(
            title: const Text('Sign Up ...'),
            children: <Widget>[
              new CircularProgressIndicator(),
            ],
          );
        })) {
    }
  }

//  Future<dynamic> _doSignup() async {
////    new Future.delayed(new Duration(seconds: 3), (){
////      Navigator.pop(context);
////    });
//
//    var url = "http://docunation.com:8880/knctd/acctregi.php";
//    var body = "{'nm':'${person.name}'}";
////    return await http
////        .post(Uri.encodeFull(url), body: body, headers: {"Accept":"application/json", "Content-Type": "application/json"})
////        .then((http.Response response) {
////            //      print(response.body);
////            final int statusCode = response.statusCode;
////            if (statusCode < 200 || statusCode > 400 || json == null) {
////              throw new Exception("Error while fetching data");
////            }
////            return _decoder.convert(response.body);
////        });
//
//    http.post(url, body:body, headers: {"Accept":"application/json", "Content-Type": "application/json"})
//    .then((response) {
//      if (response.statusCode == 200) {
//        print("Response body: ${response.body}");
//        Navigator.pop(context);
//      } else {
//        // TODO
//        // popup error alert here
//      }
//    });
//  }

  void _onLoading(@required loginmode) {
    showDialog(
      context: context,
      barrierDismissible: false,
      child: new Dialog(
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            new Padding(
              padding: new EdgeInsets.symmetric(vertical: 15.0),
              child: new CircularProgressIndicator(),
            ),

//            new Text("Sign Up..."),
            new Padding(
              padding: new EdgeInsets.symmetric(vertical: 15.0),
              child: const Text('Sign Up...'),
            )
          ],
        ),
      ),
    );
//    _doSignup();
    (loginmode == LoginFormMode.SignUp)?_presenter.doRegister(new User(person.name, person.password)):_presenter.doLogin(new User(person.name, person.password));
//    new Future.delayed(new Duration(seconds: 3), () {
//      Navigator.pop(context); //pop dialog
//      _doSignup();
//    });
  }

  void _handleSubmitted() {
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      _autovalidate = true; // Start validating on every change.
      showInSnackBar('Please fix the errors in red before submitting.');
    } else {
      form.save();
      showInSnackBar('${person.name}\'s phone number is ${person.phoneNumber}');

      _onLoading(widget._loginMode);
//      _presenter.doLogin(new User(person.name, person.password));
    }
  }

  void _show_last_timestamp() {
    showInSnackBar(_last_ts.toString());
  }

  Future<Null> _load_last_timestamp() async {
    int tstamp;
    try {
      final int result =
          await LoadTimestampChannel.invokeMethod('loadTimestamp');
      tstamp = result;
    } on PlatformException catch (e) {
      tstamp = 0;
    }

    setState(() {
      _last_ts = tstamp;
    });
  }

  String _validateName(String value) {
    _formWasEdited = true;
    if (value.isEmpty) return 'Name is required.';
    final RegExp nameExp = new RegExp(r'^[A-Za-z ]+$');
    if (!nameExp.hasMatch(value))
      return 'Please enter only alphabetical characters.';
    return null;
  }

  String _validatePhoneNumber(String value) {
    _formWasEdited = true;
    final RegExp phoneExp = new RegExp(r'^\(\d\d\d\) \d\d\d\-\d\d\d\d$');
    if (!phoneExp.hasMatch(value))
      return '(###) ###-#### - Enter a US phone number.';
    return null;
  }

  String _validatePassword(String value) {
    _formWasEdited = true;
    final FormFieldState<String> passwordField = _passwordFieldKey.currentState;
    if (passwordField.value == null || passwordField.value.isEmpty)
      return 'Please enter a password.';
    if (passwordField.value != value) return 'The passwords don\'t match';
    return null;
  }

  Future<bool> _warnUserAboutInvalidData() async {
    final FormState form = _formKey.currentState;
    if (form == null || !_formWasEdited || form.validate()) return true;

    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return new AlertDialog(
              title: const Text('This form has errors'),
              content: const Text('Really leave this form?'),
              actions: <Widget>[
                new FlatButton(
                  child: const Text('YES'),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                ),
                new FlatButton(
                  child: const Text('NO'),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
              ],
            );
          },
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    _ctx = context;
    var registerBtn = ButtonTheme(
      minWidth: double.infinity,
      child: new RaisedButton(
        child: const Text('REGISTER'),
        padding: const EdgeInsets.all(16.0),
        textColor: Colors.white,
        color: Theme.of(context).primaryColor,
        splashColor: Colors.redAccent,
        onPressed: _handleSubmitted,
      ),
    );
    var signinBtn = ButtonTheme(
      minWidth: double.infinity,
      child: new RaisedButton(
        child: const Text('SIGN IN'),
        padding: const EdgeInsets.all(16.0),
        textColor: Colors.white,
        color: Theme.of(context).primaryColor,
        splashColor: Colors.redAccent,
        onPressed: _handleSubmitted,
      ),
    );

    var switchToSignin = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
        new Text('Already have an account?',
              style: Theme.of(context).textTheme.title),
        SizedBox(width: 5.0),
        InkWell(
          onTap: () {
            setState(() {
              widget._loginMode = LoginFormMode.SignIn;
            });
          },
          child: Text('SIGN IN',
            style :TextStyle(
            color: Colors.green,
            fontSize: Theme.of(context).textTheme.title.fontSize,
            decoration: TextDecoration.underline,
            ),
            ),
          ),
        ]);

    var switchToSignup = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Text('New to Knctd?',
              style: Theme.of(context).textTheme.title),
          SizedBox(width: 5.0),
          InkWell(
            onTap: () {
              setState(() {
                widget._loginMode = LoginFormMode.SignUp;
              });
            },
            child: Text('SIGN UP',
              style :TextStyle(
                color: Colors.green,
                fontSize: Theme.of(context).textTheme.title.fontSize,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ]);


    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: const Text('Knctd'),
      ),
      body: new SafeArea(
        top: false,
        bottom: false,
        child: new Form(
          key: _formKey,
          autovalidate: _autovalidate,
          onWillPop: _warnUserAboutInvalidData,
          child: new SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(height: 12.0),
                (widget._loginMode == LoginFormMode.SignUp)? new TextFormField(
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    filled: true,
                    icon: Icon(Icons.person),
                    hintText: 'Your Name',
                    labelText: 'Name *',
                  ),
                  onSaved: (String value) {
                    person.name = value;
                  },
                  validator: _validateName,
                )  : new Container(),
                const SizedBox(height: 12.0),
                new TextFormField(
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    filled: true,
                    icon: Icon(Icons.email),
                    hintText: 'Your email address',
                    labelText: 'E-mail *',
                  ),
                  keyboardType: TextInputType.emailAddress,
                  onSaved: (String value) {
                    person.email = value;
                  },
                ),
                const SizedBox(height: 12.0),
                (widget._loginMode == LoginFormMode.SignUp)? new TextFormField(
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    filled: true,
                    icon: Icon(Icons.phone),
                    hintText: 'Your phone number',
                    labelText: 'Phone Number',
                    prefixText: '+1',
                  ),
                  keyboardType: TextInputType.phone,
                  onSaved: (String value) {
                    person.phoneNumber = value;
                  },
                  validator: _validatePhoneNumber,
                  // TextInputFormatters are applied in sequence.
                  inputFormatters: <TextInputFormatter>[
                    WhitelistingTextInputFormatter.digitsOnly,
                    // Fit the validating format.
                    _phoneNumberFormatter,
                  ],
                ) : new Container(),
                const SizedBox(height: 12.0),
                /*
                new TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Tell us about yourself',
                    helperText: 'Keep it short, this is just a demo.',
                    labelText: 'Life story',
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 12.0),
                new TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Salary',
                    prefixText: '\$',
                    suffixText: 'USD',
                    suffixStyle: TextStyle(color: Colors.green)
                  ),
                  maxLines: 1,
                ),
                const SizedBox(height: 12.0),
                */
                new PasswordField(
                  fieldKey: _passwordFieldKey,
                  helperText: 'No more than 8 characters.',
                  labelText: 'Password *',
                  onFieldSubmitted: (String value) {
                    setState(() {
                      person.password = value;
                    });
                  },
                ),
                const SizedBox(height: 12.0),
                /*
                new TextFormField(
                  enabled: person.password != null && person.password.isNotEmpty,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    filled: true,
                    labelText: 'Re-type password',
                  ),
                  maxLength: 8,
                  obscureText: true,
                  validator: _validatePassword,
                ),
                const SizedBox(height: 12.0),
                */
                _isLoading ? new CircularProgressIndicator() : ((widget._loginMode == LoginFormMode.SignUp)?registerBtn:signinBtn),
                const SizedBox(height: 12.0),
                new Text('* indicates required field',
                    style: Theme.of(context).textTheme.caption),
                const SizedBox(height: 48.0),
                (widget._loginMode == LoginFormMode.SignUp)?switchToSignin:switchToSignup,
                const SizedBox(height: 12.0),
                new Center(
                  child: new FlatButton(
                    child: const Text('Load TS'),
                    textColor: Colors.white,
                    color: Colors.green,
                    onPressed: _load_last_timestamp,
                  ),
                ),
                Text(_last_ts.toString()),
                const SizedBox(height: 12.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void onAuthStateChanged(AuthState state) {
//    if (state == AuthState.LOGGED_IN) {
////      var authStateProvider = new AuthStateProvider();
////      authStateProvider.dispose(this);
//      Navigator.of(context).pushReplacementNamed(SigninFormFieldDemo.route);
//    }
  }

  @override
  void onLoginError(String errorTxt) {
    Navigator.of(context).pop();
    showInSnackBar(errorTxt);
    setState(() => _isLoading = false);
  }

  @override
  void onLoginSuccess(User user) {
    Navigator.of(context).pop();
    showInSnackBar("Signed up " + user.toString());
    setState(() => _isLoading = false);
    var db = new DatabaseHelper();
    //await db.saveUser(user);
    var authStateProvider = new AuthStateProvider();
    authStateProvider.notify(AuthState.LOGGED_IN);
    Navigator.of(context).pushReplacementNamed(BottomNavigationDemo.route);
  }
}

/// Format incoming numeric text to fit the format of (###) ###-#### ##...
class _UsNumberTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final int newTextLength = newValue.text.length;
    int selectionIndex = newValue.selection.end;
    int usedSubstringIndex = 0;
    final StringBuffer newText = new StringBuffer();
    if (newTextLength >= 1) {
      newText.write('(');
      if (newValue.selection.end >= 1) selectionIndex++;
    }
    if (newTextLength >= 4) {
      newText.write(newValue.text.substring(0, usedSubstringIndex = 3) + ') ');
      if (newValue.selection.end >= 3) selectionIndex += 2;
    }
    if (newTextLength >= 7) {
      newText.write(newValue.text.substring(3, usedSubstringIndex = 6) + '-');
      if (newValue.selection.end >= 6) selectionIndex++;
    }
    if (newTextLength >= 11) {
      newText.write(newValue.text.substring(6, usedSubstringIndex = 10) + ' ');
      if (newValue.selection.end >= 10) selectionIndex++;
    }
    // Dump the rest.
    if (newTextLength >= usedSubstringIndex)
      newText.write(newValue.text.substring(usedSubstringIndex));
    return new TextEditingValue(
      text: newText.toString(),
      selection: new TextSelection.collapsed(offset: selectionIndex),
    );
  }
}
