import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'fab_mini_menu.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();

    _buildFabMenus();

    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {

    });
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  List<FabMiniMenu> fabItems;

  void _buildFabMenus() {
    fabItems = [
      FabMiniMenu(icon: Icons.cloud_upload, action: () => _chooseFile()),
      FabMiniMenu(
        //icon: Icons.image, action: () => _pickImage(ImageSource.gallery)),
          icon: Icons.image,
          action: () => _chooseFile()),
      FabMiniMenu(icon: Icons.camera, action: () => _chooseFile()),
    ];
  }

  void _chooseFile() async {

  }


  AnimationController _controller;
  final _scaffoldKey = GlobalKey<ScaffoldState>(); // new line

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  new GlobalKey<RefreshIndicatorState>();

  _showSnackBar(String text) {
    final snackBar = SnackBar(content: Text(text));

    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    DefaultTabController.of(context).addListener(() {
      setState(() {
        _fabOpacity = DefaultTabController.of(context).index == 0 ? 1 : 0;
      });
    });

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.title),
        bottom: TabBar(
          tabs: [
            Tab(
              icon: Icon(Icons.file_upload),
              text: 'Upload',
            ),
            Tab(icon: Icon(Icons.file_download), text: 'Download'),
          ],
        ),
      ),
      body: TabBarView(
        children: [
          Container(),
          Container()
        ],
      ),
      floatingActionButton: AnimatedOpacity(
        opacity: _fabOpacity,
        duration: Duration(milliseconds: 250),
        curve: Curves.easeOut,
        child: _buildFabMenu(context),
      ),
    );
  }

  double _fabOpacity = 1;

  Widget _buildFabMenu(BuildContext context) {
    Color backgroundColor = Theme.of(context).cardColor;
    Color foregroundColor = Theme.of(context).accentColor;

    return new Column(
      mainAxisSize: MainAxisSize.min,
      children: new List.generate(fabItems.length, (int index) {
        Widget child = new Container(
          padding: EdgeInsets.only(bottom: 10),
          // height: 70.0,
          // width: 56.0,
          //alignment: FractionalOffset.bottomRight,
          child: new ScaleTransition(
            scale: new CurvedAnimation(
              parent: _controller,
              //   curve: new Interval(
              //       1.0 * index / 10.0, 1.0 - index / fabItems.length / 2.0,
              //       curve: Curves.fastOutSlowIn),
              curve: Curves.fastOutSlowIn,
            ),
            child: new FloatingActionButton(
              heroTag: null,
              backgroundColor: backgroundColor,
              mini: false,
              child: new Icon(fabItems[index].icon, color: foregroundColor),
              onPressed: () {
                fabItems[index].action();
                _controller.reverse();
              },
            ),
          ),
        );
        return child;
      }).toList()
        ..add(
          new FloatingActionButton(
            heroTag: null,
            child: new AnimatedBuilder(
              animation: _controller,
              builder: (BuildContext context, Widget child) {
                return new Transform(
                  transform: new Matrix4.rotationZ(_controller.value * 0.5 * math.pi),
                  alignment: FractionalOffset.center,
                  child: new Icon(_controller.isDismissed ? Icons.menu : Icons.close),
                );
              },
            ),
            onPressed: () {
              if (_controller.isDismissed) {
                _controller.forward();
              } else {
                _controller.reverse();
              }
            },
          ),
        ),
    );
  }
}