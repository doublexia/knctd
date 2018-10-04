import 'package:flutter/material.dart';

import 'signup.dart';
import 'signin.dart';

import 'package:flutter_gallery/screens/home_screen.dart';
import 'package:flutter_gallery/screens/login_screen.dart';

final routes  = {
  SignupFormFieldDemo.tag: (BuildContext context) => new SignupFormFieldDemo(),
  SigninFormFieldDemo.tag: (BuildContext context) => new SigninFormFieldDemo(),
  '/login': (BuildContext context) => new LoginScreen(),
  '/home': (BuildContext context) => new HomeScreen(),
  '/':(BuildContext context) => new LoginScreen(),
};
