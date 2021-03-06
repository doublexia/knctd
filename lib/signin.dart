// Copyright 2016 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:knctd/screens/login_screen_presenter.dart';
import 'package:knctd/data/db_helper.dart';
import 'package:knctd/signup.dart';
import 'package:knctd/data/user.dart';
import 'package:knctd/screens/all_list.dart';

class SigninFormFieldDemo extends StatefulWidget {
  static String route = '/signin';

  const SigninFormFieldDemo({ Key key }) : super(key: key);

  static const String routeName = '/material/text-form-field';

  @override
  SigninFormFieldDemoState createState() => new SigninFormFieldDemoState();
}

class PersonData {
//  String name = '';
//  String phoneNumber = '';
  String email = '';
  String password = '';
}

class PasswordField extends StatefulWidget {
  const PasswordField({
    this.fieldKey,
    this.hintText,
    this.labelText,
    this.helperText,
    this.onSaved,
    this.validator,
    this.onFieldSubmitted,
  });

  final Key fieldKey;
  final String hintText;
  final String labelText;
  final String helperText;
  final FormFieldSetter<String> onSaved;
  final FormFieldValidator<String> validator;
  final ValueChanged<String> onFieldSubmitted;

  @override
  _PasswordFieldState createState() => new _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return new TextFormField(
      key: widget.fieldKey,
      obscureText: _obscureText,
      maxLength: 8,
      onSaved: widget.onSaved,
      validator: widget.validator,
      onFieldSubmitted: widget.onFieldSubmitted,
      decoration: new InputDecoration(
        border: const UnderlineInputBorder(),
        filled: true,
        icon: Icon(Icons.https),
        hintText: widget.hintText,
        labelText: widget.labelText,
        helperText: widget.helperText,
        suffixIcon: new GestureDetector(
          onTap: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
          child: new Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
        ),
      ),
    );
  }
}

class SigninFormFieldDemoState extends State<SigninFormFieldDemo> implements LoginScreenContract {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  BuildContext _ctx;

  PersonData person = new PersonData();

  LoginScreenPresenter _presenter;
  bool _isLoading = false;

//  SigninFormFieldDemo() {
//    _presenter = new LoginScreenPresenter(this);
//  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(value)
    ));
  }

  bool _autovalidate = false;
  bool _formWasEdited = false;

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<FormFieldState<String>> _passwordFieldKey = new GlobalKey<FormFieldState<String>>();
  final _UsNumberTextInputFormatter _phoneNumberFormatter = new _UsNumberTextInputFormatter();

  void _onLoading() {
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
              child:  new CircularProgressIndicator(),
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
//    _presenter.doLogin(new User(person.email, person.password));
    _presenter = new LoginScreenPresenter(this);
    _presenter.doLogin(new User("name", "passwd"));
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
      showInSnackBar('${person.email}\'s passwd is ${person.password}');

      _onLoading();
    }
  }

  String _validateName(String value) {
    _formWasEdited = true;
    if (value.isEmpty)
      return 'Name is required.';
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
    if (passwordField.value != value)
      return 'The passwords don\'t match';
    return null;
  }

  Future<bool> _warnUserAboutInvalidData() async {
    final FormState form = _formKey.currentState;
    if (form == null || !_formWasEdited || form.validate())
      return true;

    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: const Text('This form has errors'),
          content: const Text('Really leave this form?'),
          actions: <Widget> [
            new FlatButton(
              child: const Text('YES'),
              onPressed: () { Navigator.of(context).pop(true); },
            ),
            new FlatButton(
              child: const Text('NO'),
              onPressed: () { Navigator.of(context).pop(false); },
            ),
          ],
        );
      },
    ) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    _ctx = context;
    var loginBtn = ButtonTheme(
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
                new TextFormField(
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    filled: true,
                    icon: Icon(Icons.email),
                    hintText: 'Your email address',
                    labelText: 'E-mail *',
                  ),
                  keyboardType: TextInputType.emailAddress,
                  onSaved: (String value) { person.email = value; },
                ),
                const SizedBox(height: 12.0),
                new PasswordField(
                  fieldKey: _passwordFieldKey,
                  helperText: 'No more than 8 characters.',
                  labelText: 'Password *',
                  onSaved: (String value) { person.password = value; },
                  onFieldSubmitted: (String value) {
//                    setState(() {
                      person.password = value;
//                    });
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
                _isLoading?new CircularProgressIndicator(): loginBtn,

                const SizedBox(height: 12.0),
                new Text(
                  '* indicates required field',
                  style: Theme.of(context).textTheme.caption
                ),
                const SizedBox(height: 48.0),

                new Center(child:new Text(
                    'New to Knctd?',
                    style: Theme.of(context).textTheme.title
                )),
                const SizedBox(height: 12.0),

                new Center(
                  child: new FlatButton(
                    child: const Text('REGISTER'),
                    textColor: Colors.white,
                    color: Colors.green,
                    splashColor: Colors.redAccent,
                    onPressed: () {Navigator.of(context).pushReplacementNamed(SignupFormFieldDemo.route);},
                  ),
                ),
                const SizedBox(height: 12.0),
              ],
            ),
          ),
        ),
      ),
    );
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
    showInSnackBar("Signed up "+user.toString());
    setState(() => _isLoading = false);
    var db = new DatabaseHelper();
    //await db.saveUser(user);
//    Navigator.of(context).pushReplacementNamed(BottomNavigationDemo.route);
    Navigator.of(context).pushNamed(BottomNavigationDemo.route);
  }
}

/// Format incoming numeric text to fit the format of (###) ###-#### ##...
class _UsNumberTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue
  ) {
    final int newTextLength = newValue.text.length;
    int selectionIndex = newValue.selection.end;
    int usedSubstringIndex = 0;
    final StringBuffer newText = new StringBuffer();
    if (newTextLength >= 1) {
      newText.write('(');
      if (newValue.selection.end >= 1)
        selectionIndex++;
    }
    if (newTextLength >= 4) {
      newText.write(newValue.text.substring(0, usedSubstringIndex = 3) + ') ');
      if (newValue.selection.end >= 3)
        selectionIndex += 2;
    }
    if (newTextLength >= 7) {
      newText.write(newValue.text.substring(3, usedSubstringIndex = 6) + '-');
      if (newValue.selection.end >= 6)
        selectionIndex++;
    }
    if (newTextLength >= 11) {
      newText.write(newValue.text.substring(6, usedSubstringIndex = 10) + ' ');
      if (newValue.selection.end >= 10)
        selectionIndex++;
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
