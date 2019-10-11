import 'dart:ui';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  print(window.defaultRouteName);
  runApp(MyApp(initialWidget: _widgetForRoute(window.defaultRouteName)));
}

void openHome() {
  runApp(MyApp(initialWidget: MyHomePage(title: 'test home')));
}

void openCalculator() {
  runApp(MyApp(initialWidget: Scaffold(body: Calculator())));
}

Widget _widgetForRoute(String route) {
  switch (route) {
    case '/home':
      return MyHomePage(title: 'test home');
    case '/calculator':
      return Scaffold(body: Calculator());
    default:
      return Center(
        child: Text('Unknown route: $route', textDirection: TextDirection.ltr),
      );
  }
}

class MyApp extends StatelessWidget {
  final Widget initialWidget;

  MyApp({this.initialWidget});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in a Flutter IDE). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: initialWidget,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter = _counter + 10;
    });
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
        body: SafeArea(
          child: Center(
            // Center is a layout widget. It takes a single child and positions it
            // in the middle of the parent.
            child: Column(
              // Column is also a layout widget. It takes a list of children and
              // arranges them vertically. By default, it sizes itself to fit its
              // children horizontally, and tries to be as tall as its parent.
              //
              // Invoke "debug painting" (press "p" in the console, choose the
              // "Toggle Debug Paint" action from the Flutter Inspector in Android
              // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
              // to see the wireframe for each widget.
              //
              // Column has various properties to control how it sizes itself and
              // how it positions its children. Here we use mainAxisAlignment to
              // center the children vertically; the main axis here is the vertical
              // axis because Columns are vertical (the cross axis would be
              // horizontal).
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'You have pushed the button this many times:',
                ),
                Text(
                  '$_counter',
                  style: Theme.of(context).textTheme.display1,
                ),
                FlatButton(
                  child: Text('add 1'),
                  onPressed: _incrementCounter,
                )
              ],
            ),
          ),
        ));
  }
}

class Calculator extends StatefulWidget {
  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String dropdownValue = 'Add';
  int result = 0;

  int _first = 0;
  int _second = 0;

  static const platform = const MethodChannel('com.myCustomChannelData/data');

  _CalculatorState() {
    platform.setMethodCallHandler(_receiveFromHost);
  }

  Future<void> _receiveFromHost(MethodCall call) async {
    int f = 0;
    int s = 0;

    try {
      print(call.method);

      if (call.method == "fromHostToClient") {
        final String data = call.arguments;
        print(call.arguments);

        final jData = jsonDecode(data);

        f = jData['first'];
        s = jData['second'];
      }
    } on PlatformException catch (e) {
      //platform may not able to send proper data.
    }

    setState(() {
      _first = f;
      _second = s;
    });
  }

  void _sendResultsToAndroidiOS() {
    if (dropdownValue == 'Add') {
      result = _addNumbers(_first, _second);
    } else {
      result = _multiplyNumbers(_first, _second);
    }

    Map<String, dynamic> resultMap = Map();
    resultMap['operation'] = dropdownValue;
    resultMap['result'] = result;

    platform.invokeMethod("FromClientToHost", resultMap);
  }

  _addNumbers(int n1, int n2) {
    return n1 + n2;
  }

  _multiplyNumbers(int n1, int n2) {
    return n1 * n2;
  }

  _setResults(int n1, int n2) {
    setState(() {
      if (dropdownValue == 'Add') {
        result = _addNumbers(n1, n2);
      } else {
        result = _multiplyNumbers(n1, n2);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          Container(
              padding: EdgeInsets.all(10),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('First Number: ',
                        style: TextStyle(color: Colors.black, fontSize: 16)),
                    Text(_first.toString(),
                        style: TextStyle(color: Colors.blue, fontSize: 16)),
                  ])),
          Container(
              padding: EdgeInsets.all(10),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Second Number: ',
                        style: TextStyle(color: Colors.black, fontSize: 16)),
                    Text(_second.toString(),
                        style: TextStyle(color: Colors.blue, fontSize: 16)),
                  ])),
          Container(
              margin: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  DropdownButton<String>(
                    value: dropdownValue,
                    style: TextStyle(color: Colors.blue, fontSize: 16),
                    items: <String>['Add', 'Multiply']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String newValue) {
                      setState(() {
                        dropdownValue = newValue;
                      });
                    },
                  )
                ],
              )),
          RaisedButton(
            onPressed: () {
              _setResults(_first, _second);
              _sendResultsToAndroidiOS();
            },
            textColor: Colors.white,
            padding: const EdgeInsets.all(0.0),
            child: Container(
                decoration: BoxDecoration(color: Colors.blue),
                padding: const EdgeInsets.all(10.0),
                child: const Text('Send Results to Android/iOS module',
                    style: TextStyle(fontSize: 16))),
          ),
          Container(
              margin: EdgeInsets.all(10),
              child: Text(
                'Result: $result',
                style: TextStyle(color: Colors.blue, fontSize: 16),
              ))
        ],
      ),
    );
  }
}
