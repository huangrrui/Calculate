import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:calculate/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum Operator {
  plus,
  minus,
  multiple,
  divide,
}

enum PadType {
  num,
  ok,
  del,
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}
