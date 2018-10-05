import 'package:flutter/material.dart';

import 'package:knctd/signup.dart';
import 'package:knctd/signin.dart';

//import 'package:knctd/screens/home_screen.dart';
//import 'package:knctd/screens/login_screen.dart';

final routes  = {
  SignupFormFieldDemo.tag: (BuildContext context) => new SignupFormFieldDemo(),
  SigninFormFieldDemo.tag: (BuildContext context) => new SigninFormFieldDemo(),
//  '/login': (BuildContext context) => new LoginScreen(),
//  '/home': (BuildContext context) => new HomeScreen(),
//  '/':(BuildContext context) => new LoginScreen(),
  '/': (BuildContext context) => new SignupFormFieldDemo()
};
