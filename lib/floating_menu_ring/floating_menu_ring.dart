import 'package:flutter/material.dart';

import 'widgets/active_ring.dart';

class FloatingMenuRing extends StatefulWidget {
  FloatingMenuRing({
    @required this.ringColor,
    @required this.icons,
    @required this.iconColors,
    @required this.menuIcon,
    @required this.menuColor,
    @required this.onPressed,
  })  : assert(ringColor != null),
        assert(icons.length == 4),
        assert(iconColors.length == 4),
        assert(menuIcon != null),
        assert(menuColor != null),
        assert(onPressed != null);

  final Color ringColor;
  final List<IconData> icons;
  final List<Color> iconColors;
  final Color menuColor;
  final IconData menuIcon;
  final OnFloatMenuPressed onPressed;

  @override
  _FloatingMenuRingState createState() => _FloatingMenuRingState();
}

class _FloatingMenuRingState extends State<FloatingMenuRing>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<Offset> _moveAnim;
  bool _showMenu = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _moveAnim = Tween<Offset>(
      begin: Offset(0, 0),
      end: Offset(0, -7),
    ).animate(
      _controller,
    );
    _controller.addListener(() {
      if (_controller.isCompleted)
        setState(() {
          _showMenu = true;
        });
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_showMenu)
      return SlideTransition(
        position: _moveAnim,
        child: FloatingActionButton(
          onPressed: () => _controller.forward(),
          backgroundColor: widget.menuColor,
          child: Icon(
            widget.menuIcon,
          ),
        ),
      );

    return Align(
      alignment: Alignment.center,
      child: ActiveRing(
        ringColor: widget.ringColor,
        icons: widget.icons,
        colors: widget.iconColors,
        menuColor: widget.menuColor,
        menuIcon: widget.menuIcon,
        onPressed: (index) {
          setState(() {
            _showMenu = false;
          });
          _controller.reverse();
        },
      ),
    );
  }
}
