import 'dart:math' as math;
import 'package:flutter/material.dart';

import 'widgets/floating_menu_item.dart';

typedef void OnFloatingMenuItemPress(int menuIndex);

class FloatingMenu extends StatefulWidget {
  FloatingMenu({
    @required this.titles,
    @required this.icons,
    @required this.onPress,
  })  : assert(titles.length > 0 && titles.length < 5),
        assert(icons.length > 0 &&
            icons.length < 5 &&
            icons.length == titles.length),
        assert(onPress != null);

  final List<String> titles;
  final List<IconData> icons;
  final OnFloatingMenuItemPress onPress;

  @override
  _FloatingMenuState createState() => _FloatingMenuState();
}

class _FloatingMenuState extends State<FloatingMenu>
    with TickerProviderStateMixin {
  AnimationController _controller;
  var menuItems = List<Widget>();

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    var fadeStart = 0.0;
    var fadeEnd = 0.2;
    var slideStart = 0.0;

    for (int index = 0; index < widget.titles.length; index++) {
      final slideAnim = Tween<Offset>(
        begin: Offset(0, 1.0),
        end: Offset(0, 0),
      ).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            slideStart,
            1.0,
            curve: Curves.ease,
          ),
        ),
      );
      slideStart += 0.2;
      final fadeAnim = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            fadeStart,
            fadeEnd,
            curve: Curves.ease,
          ),
        ),
      );
      fadeStart += 0.2;
      fadeEnd += 0.2;

      menuItems.add(
        SizedBox(
          height: 10,
        ),
      );
      menuItems.add(
        FloatingMenuItem(
          fadeAnimation: fadeAnim,
          slideAnimation: slideAnim,
          title: widget.titles[index],
          icon: widget.icons[index],
          onPressed: () => widget.onPress(index),
        ),
      );
    }
    final rotateAnim = Tween<double>(begin: 0, end: math.pi / 4).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(
          0.0,
          1.0,
          curve: Curves.ease,
        ),
      ),
    );
    menuItems = menuItems.reversed.toList();
    menuItems.add(
      FloatingActionButton(
        heroTag: 'main-menu',
        onPressed: _onMenuShowHide,
        child: AnimatedBuilder(
          animation: rotateAnim,
          builder: (context, snapshot) {
            return Transform.rotate(
              angle: rotateAnim.value,
              child: Icon(Icons.add),
            );
          },
        ),
      ),
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onMenuShowHide() {
    if (_controller.status == AnimationStatus.completed)
      _controller.reverse();
    else
      _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: menuItems,
    );
  }
}
