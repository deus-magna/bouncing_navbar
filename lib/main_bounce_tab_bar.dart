import 'package:flutter/material.dart';

class MainBounceTabBar extends StatefulWidget {
  @override
  _MainBounceTabBarState createState() => _MainBounceTabBarState();
}

class _MainBounceTabBarState extends State<MainBounceTabBar> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bounce TabBar'),
      ),
      extendBody: true,
      body: IndexedStack(
        index: _currentIndex,
        children: [
          Container(
            color: Colors.red,
          ),
          Container(
            color: Colors.green,
          ),
          Container(
            color: Colors.yellow,
          ),
          Container(
            color: Colors.orange,
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: null),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: TestingAppBar(),
      // bottomNavigationBar: BounceTabTar(
      //   backgroundColor: Colors.blue,
      //   onTabChanged: (value) {
      //     print(value);
      //     setState(() {
      //       _currentIndex = value;
      //     });
      //   },
      //   items: [
      //     Icon(
      //       Icons.person,
      //       color: Colors.white,
      //     ),
      //     Icon(Icons.print, color: Colors.white),
      //     Icon(Icons.speaker, color: Colors.white),
      //     Icon(Icons.note, color: Colors.white),
      //   ],
      // ),
    );
  }
}

const _movement = 60;

class TestingAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
          child: Container(
        child: CustomPaint(
          size: Size(double.infinity, 70),
          painter: RPSCustomPainter(),
        ),
      ),
    );
  }
}

class BounceTabTar extends StatefulWidget {
  final Color backgroundColor;
  final List<Widget> items;
  final ValueChanged<int> onTabChanged;
  final int initialIndex;

  const BounceTabTar(
      {Key key,
      this.backgroundColor,
      this.items,
      this.onTabChanged,
      this.initialIndex = 0})
      : super(key: key);

  @override
  _BounceTabTarState createState() => _BounceTabTarState();
}

class _BounceTabTarState extends State<BounceTabTar>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation _animTabBarIn,
      _animTabBarOut,
      _animCircleItem,
      _animElevationIn,
      _animElevationOut;
  int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
    _animTabBarIn = CurveTween(
      curve: Interval(
        0.1,
        0.6,
        curve: Curves.decelerate,
      ),
    ).animate(_controller);

    _animTabBarOut = CurveTween(
      curve: Interval(
        0.6,
        1.0,
        curve: Curves.bounceOut,
      ),
    ).animate(_controller);

    _animCircleItem = CurveTween(
      curve: Interval(
        0.0,
        0.5,
      ),
    ).animate(_controller);

    _animElevationIn = CurveTween(
      curve: Interval(
        0.1,
        0.5,
      ),
    ).animate(_controller);

    _animElevationOut = CurveTween(
      curve: Interval(
        0.55,
        1.0,
        curve: Curves.bounceOut,
      ),
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    double currentWidth = width;
    double currentElevation = 0;
    return SizedBox(
      height: kBottomNavigationBarHeight,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (BuildContext context, _) {
          currentWidth = width -
              (_movement * _animTabBarIn.value) +
              (_movement * _animTabBarOut.value);

          currentElevation = -_movement * _animElevationIn.value -
              kBottomNavigationBarHeight / 6 +
              _movement * _animElevationOut.value;
          return Center(
            child: Container(
              width: currentWidth,
              decoration: BoxDecoration(
                color: widget.backgroundColor,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20.0),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(widget.items.length, (index) {
                  if (index == _currentIndex) {
                    return Expanded(
                      child: CustomPaint(
                        foregroundPainter:
                            _CircleItemPainter(_animCircleItem.value),
                        child: Transform.translate(
                          offset: Offset(0.0, currentElevation),
                          child: CircleAvatar(
                            radius: 30.0,
                            backgroundColor: widget.backgroundColor,
                            child: widget.items[index],
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Expanded(
                      child: GestureDetector(
                        onTap: () {
                          widget.onTabChanged(index);
                          setState(() {
                            _currentIndex = index;
                          });
                          _controller.forward(from: 0.0);
                        },
                        child: CircleAvatar(
                          radius: 30.0,
                          backgroundColor: widget.backgroundColor,
                          child: widget.items[index],
                        ),
                      ),
                    );
                  }
                }),
              ),
            ),
          );
        },
      ),
    );
  }
}

class RPSCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = new Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    Path path = Path();
    path.moveTo(0, size.height);
    path.lineTo(0, size.height * 0.25);
    path.quadraticBezierTo(size.width * 0.23, size.height * 0.14,
        size.width * 0.31, size.height * 0.10);
    path.cubicTo(size.width * 0.37, size.height * 0.05, size.width * 0.37,
        size.height * 0.15, size.width * 0.38, size.height * 0.25);
    path.cubicTo(size.width * 0.37, size.height * 0.90, size.width * 0.63,
        size.height * 0.90, size.width * 0.63, size.height * 0.25);
    path.cubicTo(size.width * 0.63, size.height * 0.15, size.width * 0.63,
        size.height * 0.06, size.width * 0.69, size.height * 0.10);
    path.quadraticBezierTo(
        size.width * 0.77, size.height * 0.14, size.width, size.height * 0.25);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class _CircleItemPainter extends CustomPainter {
  final double progress;

  _CircleItemPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = 20.0 * progress;
    final strokeWidth = 10.0;
    final currentStrokeWidth = strokeWidth * (1 - progress);

    if (progress < 1.0) {
      canvas.drawCircle(
        center,
        radius,
        Paint()
          ..color = Colors.black
          ..style = PaintingStyle.stroke
          ..strokeWidth = currentStrokeWidth,
      );
    }
  }

  @override
  bool shouldRepaint(_CircleItemPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(_CircleItemPainter oldDelegate) => false;
}
