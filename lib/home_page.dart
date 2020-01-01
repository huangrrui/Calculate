import 'dart:async';
import 'dart:math';

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

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int n1 = 0;
  int n2 = 0;
  Operator operator = Operator.plus;
  int result = 0;
  int expectResult = 0;
  String resultStr = ''; // 回答结果文字（正确、错误）
  Timer resultStrTimer;

  @override
  void initState() {
    _generateQuestion();
    super.initState();
  }

  @override
  void dispose() {
    resultStrTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Column(
          children: <Widget>[
            _calculateView(),
            _padView(),
          ],
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
      margin: EdgeInsets.all(32),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(),
          ),
          Text(
            '$n1 $operatorStr $n2 = $result',
            style: TextStyle(
              fontSize: 50,
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Text(
                resultStr,
                style: TextStyle(fontSize: 40),
              ),
            ),
          ),
        ],
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
      case PadType.ok:
        return _controlPad('OK');
    }
  }

  Widget _controlPad(String title) {
    return _tapPad(title, () {
      if (title == 'OK') {
        _onOkClicked();
      } else if (title == 'Del') {
        _onDelClicked();
      }
      setState(() {});
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

    operator = Operator.values[Random().nextInt(4)];
    while (true) {
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
      } else if (operator == Operator.divide) {
        if (n2 == 0) {
          continue;
        }

        if ((n1 / n2) != (n1 ~/ n2).toDouble()) {
          continue;
        }
        expectResult = n1 ~/ n2;
      }
      break;
    }
  }

  _startTimer() {
    if (resultStrTimer != null) {
      resultStrTimer.cancel();
    }

    resultStrTimer = Timer(Duration(seconds: 1), () {
      resultStrTimer.cancel();
      resultStrTimer = null;
      setState(() {
        resultStr = '';
      });
    });
  }

  _onOkClicked() {
    // 生成新的题目
    if (result == expectResult) {
      _generateQuestion();
      resultStr = 'Correct';
    } else {
      result = 0;
      resultStr = 'Wrong';
    }
    setState(() {});
    _startTimer();
  }

  _onDelClicked() {
    // 清空输入
    result = 0;
  }
}
