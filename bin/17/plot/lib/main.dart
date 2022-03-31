import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_plot/flutter_plot.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Point> data = [
    const Point(21.0, 19.0),
    const Point(3.0, 7.0),
    const Point(8.0, 9.0),
    const Point(11.0, 14.0),
    const Point(18.0, 17.0),
    const Point(7.0, 8.0),
    const Point(-4.0, -4.0),
    const Point(6.0, 12.0),
  ];
  int _counter = 0;
  int maxY = 0;
  int p1Y = -103;
  int p2Y = -157;
  bool found = false;
  TextEditingController velX = TextEditingController();
  TextEditingController velY = TextEditingController();

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    velX.text = '6';
    velY.text = '3';

    computePoints();
    super.initState();
  }

  void computePoints() {
    data.clear();
    data.add(const Point(0, 0));
    int x = 0;
    int y = 0;
    int vX = int.parse(velX.text);
    int vY = int.parse(velY.text);
    x += vX.toInt();
    y += vY.toInt();
    maxY = 0;
    found = false;
    data.add(Point(x, y));
    for (var i = 0; i < 300; i++) {
      if (vX > 0) {
        vX--;
      } else if (vX < 0) {
        vX++;
      }

      vY--;
      x += vX.toInt();
      y += vY.toInt();
      maxY = max(maxY, y);
      if ((found == false) && (y >= p2Y) && (y <= p1Y)) {
        found = true;
      }

      data.add(Point(x, y));
    }
    setState(() {
      data = data;
      maxY = maxY;
      found = found;
    });
    print(data);
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          children: <Widget>[
            Row(
              children: [
                Container(
                  width: 400,
                  child: TextField(
                    onChanged: (value) => computePoints(),
                    controller: velX,
                  ),
                ),
                Container(
                  width: 400,
                  child: TextField(
                    onChanged: (value) => computePoints(),
                    controller: velY,
                  ),
                ),
                Text(maxY.toString()),
                Text(found.toString()),
              ],
            ),
            Container(
              padding: const EdgeInsets.only(top: 12.0),
              child: Text('Super Neat Plot'),
            ),
            Container(
              child: Plot(
                data: data,
                height: 700,
                gridSize: Offset(2.0, 2.0),
                style: PlotStyle(
                  trace: true,
                  pointRadius: 3.0,
                  outlineRadius: 1.0,
                  primary: Colors.white,
                  secondary: Colors.orange,
                  textStyle: TextStyle(
                    fontSize: 8.0,
                    color: Colors.blueGrey,
                  ),
                  axis: Colors.blueGrey[600],
                  gridline: Colors.blueGrey[100],
                ),
                padding: const EdgeInsets.fromLTRB(40.0, 12.0, 12.0, 40.0),
                xTitle: 'My X Title',
                yTitle: 'My Y Title',
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
