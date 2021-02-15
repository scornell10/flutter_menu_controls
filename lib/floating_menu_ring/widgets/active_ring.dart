import 'dart:math' as math;
import 'package:flutter/material.dart';

import 'floating_menu_ring_item.dart';

typedef void OnFloatMenuPressed(int index);

class ActiveRing extends StatefulWidget {
  ActiveRing({
    @required this.icons,
    @required this.colors,
    @required this.ringColor,
    @required this.menuColor,
    @required this.menuIcon,
    @required this.onPressed,
  });

  final List<IconData> icons;
  final List<Color> colors;
  final Color ringColor;
  final Color menuColor;
  final IconData menuIcon;
  final OnFloatMenuPressed onPressed;

  @override
  _ActiveRingState createState() => _ActiveRingState();
}

class _ActiveRingState extends State<ActiveRing>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<Offset> _topLeftAnim;
  Animation<Offset> _topRightAnim;
  Animation<Offset> _bottomLeftAnim;
  Animation<Offset> _bottomRightAnim;
  Animation<double> _topNavBtnAngle;
  Animation<double> _opacityAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 250),
    );
    _topLeftAnim = Tween<Offset>(
      begin: Offset(0, 0),
      end: Offset(-1.5, -1.3),
    ).animate(_controller);
    _bottomLeftAnim = Tween<Offset>(
      begin: Offset(0, 0),
      end: Offset(-1.5, 1.3),
    ).animate(_controller);
    _topRightAnim = Tween<Offset>(
      begin: Offset(0, 0),
      end: Offset(1.5, -1.3),
    ).animate(_controller);
    _bottomRightAnim = Tween<Offset>(
      begin: Offset(0, 0),
      end: Offset(1.5, 1.3),
    ).animate(_controller);
    _topNavBtnAngle = Tween<double>(
      begin: 0.0,
      end: math.pi / 4,
    ).animate(_controller);
    _opacityAnim = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      _controller,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _onPress([int index = 99]) {
    _controller.reverse();
    _controller.addListener(() {
      if (_controller.isDismissed) widget.onPressed(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height / 4;
    final width = size.width;

    return Stack(
      alignment: Alignment.center,
      children: [
        AnimatedBuilder(
          animation: _opacityAnim,
          builder: (context, child) {
            return Opacity(
              opacity: _opacityAnim.value,
              child: Container(
                height: height,
                width: width,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: widget.ringColor,
                    width: 1,
                  ),
                ),
              ),
            );
          },
        ),
        SlideTransition(
          position: _topLeftAnim,
          child: FloatingMenuRingItem(
            color: widget.colors[0],
            icon: widget.icons[0],
            onPressed: () => _onPress(0),
          ),
        ),
        SlideTransition(
          position: _topRightAnim,
          child: FloatingMenuRingItem(
            color: widget.colors[0],
            icon: widget.icons[1],
            onPressed: () => _onPress(1),
          ),
        ),
        SlideTransition(
          position: _bottomLeftAnim,
          child: FloatingMenuRingItem(
            color: widget.colors[0],
            icon: widget.icons[2],
            onPressed: () => _onPress(2),
          ),
        ),
        SlideTransition(
          position: _bottomRightAnim,
          child: FloatingMenuRingItem(
            color: widget.colors[0],
            icon: widget.icons[3],
            onPressed: () => _onPress(3),
          ),
        ),
        AnimatedBuilder(
          animation: _topNavBtnAngle,
          builder: (context, _) {
            return Transform.rotate(
              angle: _topNavBtnAngle.value, //math.pi / 4,
              child: FloatingActionButton(
                onPressed: () => _onPress(),
                backgroundColor: widget.menuColor,
                child: Icon(
                  widget.menuIcon,
                  color: Colors.white,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
