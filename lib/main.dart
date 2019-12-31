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
  int n1 = 0;
  int n2 = 0;
  int operator = 0; // 0123,+-*/
  int result = 0;
  int expectResult = 0;

  @override
  void initState() {
    _generateQuestion();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(),
        body: Container(
          child: Column(
            children: <Widget>[
              _calculateView(),
              _padView(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _calculateView() {
    String operatorStr;
    if (operator == 0) {
      operatorStr = '+';
    } else if (operator == 1) {
      operatorStr = '-';
    } else if (operator == 2) {
      operatorStr = 'x';
    } else {
      operatorStr = '/';
    }
    return Container(
      margin: EdgeInsets.all(32.0),
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
              _numPad('Del'),
              _numPad('0'),
              _numPad('OK'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _numPad(String title) {
    return FlatButton(
      onPressed: () {
        setState(() {
          try {
            int n = int.parse(title);
            if (result <= 9) {
              result = result * 10 + n;
            }
          } catch (e) {
            if (title == 'OK') {
              // 生成新的题目
              if (result == expectResult) {
                _generateQuestion();
              }
            } else if (title == 'Del') {
              // 清空输入
              result = 0;
            }
          }
        });
      },
      padding: EdgeInsets.zero,
      child: Container(
        margin: EdgeInsets.all(1),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black,
            width: 1,
          ),
        ),
        width: 128,
        height: 128,
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 32,
            ),
          ),
        ),
      ),
    );
  }

  _generateQuestion() {
    n1 = 0;
    n2 = 0;
    operator = 0;
    expectResult = 0;
    result = 0;

    while (true) {
      operator = Random().nextInt(3);
      n1 = Random().nextInt(10);
      n2 = Random().nextInt(10);
      if (operator == 0) {
        expectResult = n1 + n2;
      } else if (operator == 1) {
        if (n1 < n2) {
          continue;
        } else {
          expectResult = n1 - n2;
        }
      } else if (operator == 2) {
        expectResult = n1 * n2;
      }
      break;
    }
  }
}
