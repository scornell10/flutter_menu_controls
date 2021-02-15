import 'package:flutter/material.dart';

class SlideMenu extends StatefulWidget {
  SlideMenu({
    @required this.menu,
    @required this.mainPage,
    @required this.title,
    this.appBarColor = Colors.blueGrey,
  })  : assert(menu != null),
        assert(mainPage != null),
        assert(title != null);

  final Widget menu;
  final Widget mainPage;
  final String title;
  final Color appBarColor;
  @override
  _SlideMenuState createState() => _SlideMenuState();
}

class _SlideMenuState extends State<SlideMenu> with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    _anim = Tween<double>(begin: 1, end: 0.6).animate(_controller);
  }

  void _onPagePress() {
    if (_controller.isCompleted) _controller.reverse();
  }

  void _onMenuPress() {
    if (_controller.isDismissed) _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: [
          widget.menu,
          AnimatedBuilder(
            animation: _anim,
            builder: (context, child) {
              return Transform.scale(
                alignment: Alignment.centerRight,
                scale: _anim.value,
                child: child,
              );
            },
            child: GestureDetector(
              onTap: _onPagePress,
              child: Scaffold(
                appBar: AppBar(
                  leading: IconButton(
                    icon: Icon(Icons.menu),
                    onPressed: _onMenuPress,
                  ),
                  title: Text(widget.title),
                  backgroundColor: widget.appBarColor,
                ),
                body: widget.mainPage,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
