// Copyright 2016 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:knctd/screens/nav_icon_view.dart';
import 'package:knctd/data/Contact.dart';
import 'package:knctd/data/DBContact.dart';
import 'package:knctd/screens/contacts_list.dart';
import 'package:knctd/contacts.dart';

class BottomNavigationDemo extends StatefulWidget {
  static String route = '/all_list';

  @override
  _BottomNavigationDemoState createState() => new _BottomNavigationDemoState();
}

class _BottomNavigationDemoState extends State<BottomNavigationDemo>
    with TickerProviderStateMixin {

  int _currentIndex = 0;
  BottomNavigationBarType _type = BottomNavigationBarType.shifting;
  List<NavigationIconView> _navigationViews;

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    super.initState();

    firebaseCloudMessaging_Listeners();

    _navigationViews = <NavigationIconView>[

      new NavigationIconView(
        activeIcon: const Icon(Icons.person),
        icon: const Icon(Icons.perm_identity),
        title: 'Contacts',
        color: Colors.teal,
        vsync: this,
        screen: new Semantics(
          label: 'Placeholder for Cloud tab',
          //child: const Icon(Icons.perm_identity),
          child: getContacts(false),
        ),
        count: 8,
      ),
      new NavigationIconView(
        activeIcon: const Icon(Icons.favorite),
        icon: const Icon(Icons.favorite_border),
        title: 'Monitoring',
        color: Colors.indigo,
        vsync: this,
        screen: new Semantics(
          label: 'Placeholder for Cloud tab',
          child: getContacts(true),
        ),
        count: 18,
      ),
      new NavigationIconView(
        icon: const Icon(Icons.access_alarm),
        title: 'Alarm',
        color: Colors.deepPurple,
        vsync: this,
        screen: new Semantics(
          label: 'Placeholder for Alarm tab',
          child: new Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.access_alarm),
              Text('Alarm'),
            ]
          ),
        ),
      ),
      new NavigationIconView(
        icon: const Icon(Icons.settings),
        title: 'Settings',
        color: Colors.green,
        vsync: this,
        screen: new Semantics(
          label: 'Placeholder for Event tab',
          child: const Icon(Icons.settings),
        ),
      )
    ];

    for (NavigationIconView view in _navigationViews)
      view.controller.addListener(_rebuild);

    _navigationViews[_currentIndex].controller.value = 1.0;
  }

  void firebaseCloudMessaging_Listeners() {
    if (Platform.isIOS) iOS_Permission();

    _firebaseMessaging.getToken().then((token){
      print("Token: '${token}' ");
    });

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('on message $message');
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
      },
    );
  }

  void iOS_Permission() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true)
    );
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings)
    {
      print("Settings registered: $settings");
    });
  }

  @override
  void dispose() {
    for (NavigationIconView view in _navigationViews)
      view.controller.dispose();
    super.dispose();
  }

  void _rebuild() {
    setState(() {
      // Rebuild in order to animate views.
    });
  }

  Widget _buildTransitionsStack() {
    final List<FadeTransition> transitions = <FadeTransition>[];

    for (NavigationIconView view in _navigationViews)
      transitions.add(view.transition(_type, context));

    // We want to have the newly animating (fading in) views on top.
    transitions.sort((FadeTransition a, FadeTransition b) {
      final Animation<double> aAnimation = a.opacity;
      final Animation<double> bAnimation = b.opacity;
      final double aValue = aAnimation.value;
      final double bValue = bAnimation.value;
      return aValue.compareTo(bValue);
    });

    return new Stack(children: transitions);
  }

  // build action bar actions depending on _currentIndex
  List<Widget> _buildActions() {
    if (_currentIndex == 0) {
      return <Widget>[
        new IconButton(
          icon: new Icon(Icons.add),
          tooltip: "Add new monitoring contact",
          onPressed: () => Navigator.of(context).pushNamed(ContactDetail.route),
        )
      ];
    } else {
      return <Widget>[
        new PopupMenuButton<BottomNavigationBarType>(
          onSelected: (BottomNavigationBarType value) {
            setState(() {
              _type = value;
            });
          },
          itemBuilder: (BuildContext context) =>
          <PopupMenuItem<BottomNavigationBarType>>[
            const PopupMenuItem<BottomNavigationBarType>(
              value: BottomNavigationBarType.fixed,
              child: Text('Fixed'),
            ),
            const PopupMenuItem<BottomNavigationBarType>(
              value: BottomNavigationBarType.shifting,
              child: Text('Shifting'),
            )
          ],
        )
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final BottomNavigationBar botNavBar = new BottomNavigationBar(
      items: _navigationViews
          .map((NavigationIconView navigationView) => navigationView.item)
          .toList(),
      currentIndex: _currentIndex,
      type: _type,
      onTap: (int index) {
        setState(() {
          _navigationViews[_currentIndex].controller.reverse();
          _currentIndex = index;
          _navigationViews[_currentIndex].controller.forward();
        });
      },
    );

    return new Scaffold(
      appBar: new AppBar(
        title: const Text('Knctd'),
        actions: _buildActions(),
      ),
      body: new Center(
        child: _buildTransitionsStack()
      ),
      bottomNavigationBar: botNavBar,
    );
  }



  Widget getContacts(bool monitoring) {
//    if (widget.monitoring) {
      // get all contacts that I'm monitoring
//    } else {
      // get all contacts who are monitoring me
//    }

    return new FutureBuilder<List<Contact>> (
      future: monitoring?DBContact().getMonitoringContacts():DBContact().getMonitoredContacts(),
      builder: (BuildContext context, AsyncSnapshot<List<Contact>> snapshot) {
        List<Contact> contacts = [];
        if (snapshot.data != null) contacts = snapshot.data;
//        if (contacts.isEmpty) {
//          return new Container();
//        }
        return new ContactsList(
            contacts: destinations,
            loading: snapshot.data == null);
      }

    );
  }

}
