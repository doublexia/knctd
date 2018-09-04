// Copyright 2015 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Thanks for checking out Flutter!
// Like what you see? Tweet us @flutterio

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'gallery/app.dart';
import 'signup.dart';

void main() async {
  // Temporary debugging hook for https://github.com/flutter/flutter/issues/17888
  debugInstrumentationEnabled = true;

  // Overriding https://github.com/flutter/flutter/issues/13736 for better
  // visual effect at the cost of performance.
  MaterialPageRoute.debugEnableFadingRoutes = true; // ignore: deprecated_member_use
  //runApp(const GalleryApp());

  Widget _defaultHome = new TextFormFieldDemo();
  runApp(new MaterialApp(
    title: 'Connected',
    home: _defaultHome,
    /*
    routes: <String, WidgetBuilder>{
      // Set routes for using the Navigator.
      '/home': (BuildContext context) => new HomePage(),
      '/login': (BuildContext context) => new LoginPage()
    },
    */
  ));
}
