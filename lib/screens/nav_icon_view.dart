import 'package:flutter/material.dart';
import 'package:knctd/pub/badge_icon.dart';

class NavigationIconView {
  NavigationIconView({
    Widget icon,
    Widget activeIcon,
    String title,
    Color color,
    TickerProvider vsync,
    Widget screen,
    int count: 0,
  }) : _icon = icon,
        _color = color,
        _title = title,
      _count = count,
        item = new BottomNavigationBarItem(
          icon: new BadgeIcon(icon: icon, count:count),
//          stack(
//            children: <Widget>[
//              Padding(
//                padding: const EdgeInsets.all(5.0),
//                child: icon,
//              ),
//              Positioned(
//                top: 0.0,
//                right: 0.0,
//                child: Material(
//                    type: MaterialType.circle,
//                    elevation: 2.0,
//                    color: Colors.red,
//                    child: Padding(
//                      padding: const EdgeInsets.all(3.0),
//                      child: Text(
//                        "8",
//                        style: TextStyle(
//                          fontSize: 12.0,
//                          color: Colors.white,
//                          fontWeight: FontWeight.bold,
//                        ),
//                      ),
//                    )),
//              )
//            ]
//          ),
          activeIcon: new BadgeIcon(icon: activeIcon??icon, count:count),
//          (activeIcon != null)?Stack(
//              children: <Widget>[
//                Padding(
//                  padding: const EdgeInsets.all(5.0),
//                  child:activeIcon,
//                ),
//                Positioned(
//                  top: 0.0,
//                  right: 0.0,
//                  child: Material(
//                      type: MaterialType.circle,
//                      elevation: 2.0,
//                      color: Colors.red,
//                      child: Padding(
//                        padding: const EdgeInsets.all(3.0),
//                        child: Text(
//                          "8",
//                          style: TextStyle(
//                            fontSize: 12.0,
//                            color: Colors.white,
//                            fontWeight: FontWeight.bold,
//                          ),
//                        ),
//                      )),
//                )
//              ]
//          ) : activeIcon,
          title: new Text(title),
          backgroundColor: color,
        ),
        _screen = screen,
        controller = new AnimationController(
          duration: kThemeAnimationDuration,
          vsync: vsync,
        ) {
    _animation = new CurvedAnimation(
      parent: controller,
      curve: const Interval(0.5, 1.0, curve: Curves.fastOutSlowIn),
    );
  }

  final Widget _icon;
  final Color _color;
  final String _title;
  final BottomNavigationBarItem item;
  final AnimationController controller;
  CurvedAnimation _animation;
  final Widget _screen;
  final int _count;

  FadeTransition transition(BottomNavigationBarType type, BuildContext context) {
    Color iconColor;
    if (type == BottomNavigationBarType.shifting) {
      iconColor = _color;
    } else {
      final ThemeData themeData = Theme.of(context);
      iconColor = themeData.brightness == Brightness.light
          ? themeData.primaryColor
          : themeData.accentColor;
    }

    return new FadeTransition(
      opacity: _animation,
      child: new SlideTransition(
        position: new Tween<Offset>(
          begin: const Offset(0.0, 0.02), // Slightly down.
          end: Offset.zero,
        ).animate(_animation),
        child: new IconTheme(
          data: new IconThemeData(
            color: iconColor,
            size: 120.0,
          ),
          child: _screen,
        ),
      ),
    );
  }
}


class CustomIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final IconThemeData iconTheme = IconTheme.of(context);
    return new Container(
      margin: const EdgeInsets.all(4.0),
      width: iconTheme.size - 8.0,
      height: iconTheme.size - 8.0,
      color: iconTheme.color,
    );
  }
}

class CustomInactiveIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final IconThemeData iconTheme = IconTheme.of(context);
    return new Container(
        margin: const EdgeInsets.all(4.0),
        width: iconTheme.size - 8.0,
        height: iconTheme.size - 8.0,
        decoration: new BoxDecoration(
          border: new Border.all(color: iconTheme.color, width: 2.0),
        )
    );
  }
}
