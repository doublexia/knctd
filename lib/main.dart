// Copyright 2015 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Thanks for checking out Flutter!
// Like what you see? Tweet us @flutterio

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';


import 'routes.dart';
import 'emptyscreen.dart';
import 'login.dart';
import 'package:knctd/screens/all_list.dart';

void main() async {
  // Temporary debugging hook for https://github.com/flutter/flutter/issues/17888
  debugInstrumentationEnabled = true;

  // Overriding https://github.com/flutter/flutter/issues/13736 for better
  // visual effect at the cost of performance.
  MaterialPageRoute.debugEnableFadingRoutes = true; // ignore: deprecated_member_use
  //runApp(const GalleryApp());

  Widget _buildLandingScreen() {
    return new StreamBuilder<FirebaseUser> (
        stream: FirebaseAuth.instance.onAuthStateChanged,
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return new EmptyScreen();
          } else {
            if (snapshot.hasData) {
              if (snapshot.data.providerData.length == 1) { // logged in using email and password
                return snapshot.data.isEmailVerified
                    ? BottomNavigationDemo()
                    : LoginForm(LoginFormMode.SignIn /* user: snapshot.data */);
              } else {// logged in using other providers
                return BottomNavigationDemo();
              }
            } else {
              return LoginForm(LoginFormMode.SignUp);
            }
//            return (Auth.isLoggedIn()) ? new HomePage() : (Auth.isSignedIn()?new LoginPage():new SignupPage());
//         return (snapshot.hasData)? new HomePage() : new LoginPage();
          }
        }
    );
  }

  //Widget _defaultHome = new SignupFormFieldDemo();
  runApp(new MaterialApp(
    title: 'Connected',
    //home: _defaultHome,
    home: _buildLandingScreen(),
    routes: routes,

//    theme: new ThemeData(
//      primarySwatch: Colors.red,
//    ),
  ));
}
