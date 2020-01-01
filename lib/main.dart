import 'dart:math';
import 'dart:ui';

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
  int n1 = 0;
  int n2 = 0;
  Operator operator = Operator.plus;
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
    switch (operator) {
      case Operator.plus:
        operatorStr = '+';
        break;
      case Operator.minus:
        operatorStr = '-';
        break;
      case Operator.multiple:
        operatorStr = 'x';
        break;
      case Operator.divide:
        operatorStr = '/';
        break;
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
              _pad(PadType.num, num: 1),
              _pad(PadType.num, num: 2),
              _pad(PadType.num, num: 3),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _pad(PadType.num, num: 4),
              _pad(PadType.num, num: 5),
              _pad(PadType.num, num: 6),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _pad(PadType.num, num: 7),
              _pad(PadType.num, num: 8),
              _pad(PadType.num, num: 9),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _pad(PadType.del),
              _pad(PadType.num, num: 0),
              _pad(PadType.ok),
            ],
          ),
        ],
      ),
    );
  }

  Widget _pad(PadType type, {int num}) {
    switch (type) {
      case PadType.num:
        return _numPad(num.toString());
      case PadType.del:
        return _controlPad('Del');
        break;
      case PadType.ok:
        return _controlPad('OK');
        break;
    }
  }

  Widget _controlPad(String title) {
    return _tapPad(title, () {
      setState(() {
        if (title == 'OK') {
          // 生成新的题目
          if (result == expectResult) {
            _generateQuestion();
          }
        } else if (title == 'Del') {
          // 清空输入
          result = 0;
        }
      });
    });
  }

  Widget _numPad(String title) {
    return _tapPad(title, () {
      setState(() {
        int n = int.parse(title);
        if (result <= 9) {
          result = result * 10 + n;
        }
      });
    });
  }

  Widget _tapPad(String title, void Function() target) {
    return FlatButton(
      onPressed: target,
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
    expectResult = 0;
    result = 0;

    while (true) {
      operator = Operator.values[Random().nextInt(3)];
      n1 = Random().nextInt(10);
      n2 = Random().nextInt(10);
      if (operator == Operator.plus) {
        expectResult = n1 + n2;
      } else if (operator == Operator.minus) {
        if (n1 < n2) {
          continue;
        } else {
          expectResult = n1 - n2;
        }
      } else if (operator == Operator.multiple) {
        expectResult = n1 * n2;
      }
      break;
    }
  }
}
