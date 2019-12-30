import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum Operator {
  plus,
  minus,
  multiple,
  divide,
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
      home: Scaffold(
        appBar: AppBar(),
        body: Container(
          color: Colors.grey,
          child: Column(
            children: <Widget>[
              _calculateView(),
              Container(
                height: 32,
              ),
              _padView(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _calculateView() {
    int n1;
    int n2;
    int result;
    String operatorStr;

    bool oneMore = true;
    while (oneMore) {
      oneMore = false;

      n1 = Random().nextInt(10);
      n2 = Random().nextInt(10);
      var operator = Random().nextInt(2);
      result = 0;
      if (operator == 0) {
        result = n1 + n2;
        operatorStr = '+';
      } else if (operator == 1) {
        if (n1 < n2) {
          oneMore = true;
          continue;
        }
        result = n1 - n2;
        operatorStr = '-';
      } else if (operator == 2) {
        result = n1 * n2;
        operatorStr = 'x';
      } else {
        result = n1 ~/ n2;
        operatorStr = '/';
      }
    }
    return Container(
      child: Center(
        child: Text(
          '$n1 $operatorStr $n2 = $result',
          style: TextStyle(
            fontSize: 50,
          ),
        ),
      ),
    );
  }

  Widget _padView() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _numPad('1'),
              _numPad('2'),
              _numPad('3'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _numPad('4'),
              _numPad('5'),
              _numPad('6'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _numPad('7'),
              _numPad('8'),
              _numPad('9'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _numPad(' '),
              _numPad('0'),
              _numPad(' '),
            ],
          ),
        ],
      ),
    );
  }

  Widget _numPad(String title) {
    return Container(
      color: Colors.white,
      width: 64,
      height: 64,
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            fontSize: 32,
          ),
        ),
      ),
    );
  }
}
