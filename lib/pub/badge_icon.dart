import 'package:flutter/material.dart';

class BadgeIcon extends StatefulWidget {
  final Icon icon;
  final int count;
  final Color badgeColor;
  final Color badgeTextColor;
  final bool hideZeroCount;

  BadgeIcon({
    Key key,
    @required this.icon,
    @required this.count,
    this.badgeColor: Colors.red,
    this.badgeTextColor: Colors.white,
    this.hideZeroCount: true,
  }) : super(key: key);

  @override
  _BadgeIconState createState() {
    return _BadgeIconState();
  }
}

class _BadgeIconState extends State<BadgeIcon> {
  @override
  Widget build(BuildContext context) {
    if (widget.icon == null)
      return new Container(width: 0.0, height: 0.0);

    if (widget.hideZeroCount && widget.count == 0)
      return widget.icon;

    return Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: widget.icon,
          ),
          Positioned(
            top: 0.0,
            right: 0.0,
            child: Material(
                type: MaterialType.circle,
                elevation: 2.0,
                color: widget.badgeColor,
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Text(
                    widget.count > 9?"9" : widget.count.toString(),
                    style: TextStyle(
                      fontSize: 13.0,
                      color: widget.badgeTextColor,
                      fontWeight: FontWeight.bold,
                        decoration: widget.count > 9 ?TextDecoration.underline:TextDecoration.none,
                    ),
                  ),
                )
            ),
          )
        ]
    );
  }
}