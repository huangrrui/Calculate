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

class HomePageViewModel {
  State state;
  BuildContext context;

  int n1;
  int n2;
  Operator operator;
  int result;
  int expectResult;
  String resultStr; // 回答结果文字（正确、错误）
  Timer resultStrTimer;
  int questionDigit;
  int get score {
    return _score?.value ?? 0;
  }

  Accumulator _score;

  HomePageViewModel.init({
    this.state,
  }) {
    n1 = 0;
    n2 = 0;
    operator = Operator.plus;
    result = 0;
    expectResult = 0;
    resultStr = '';
    questionDigit = 1;
    _score = Accumulator();
  }

  dispose() {
    resultStrTimer?.cancel();
  }

  generateQuestion() {
    n1 = 0;
    n2 = 0;
    expectResult = 0;
    result = 0;

    /// 产生+-*/运算符
    operator = Operator.values[Random().nextInt(4)];
    while (true) {
      n1 = pow(10, questionDigit - 1) + Random().nextInt(pow(10, questionDigit) - pow(10, questionDigit - 1));
      n2 = pow(10, questionDigit - 1) + Random().nextInt(pow(10, questionDigit) - pow(10, questionDigit - 1));
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

  startTimer() {
    if (resultStrTimer != null) {
      resultStrTimer.cancel();
    }

    resultStrTimer = Timer(Duration(seconds: 1), () {
      resultStrTimer.cancel();
      resultStrTimer = null;
      state.setState(() {
        resultStr = '';
      });
    });
  }

  onOkClicked() {
    // 生成新的题目
    if (result == expectResult) {
      generateQuestion();
      resultStr = 'Correct';
      _scorePlus();
    } else {
      result = 0;
      resultStr = 'Wrong';
    }
    state.setState(() {});
    startTimer();
  }

  onDelClicked() {
    // 清空输入
    result = 0;
  }

  onNumClicked(int num) {
    if (result <= (pow((pow(10, questionDigit) - 1), 2))) {
      result = result * 10 + num;
    }
    if (result == expectResult) {
      generateQuestion();
      resultStr = 'Correct';
      _scorePlus();
    } else {
      resultStr = 'Wrong';
    }
    startTimer();
    state.setState(() {});
  }

  onDrawerClicked(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  /// 几位数乘法
  onSettingQuestionClicked(int digits) {
    Navigator.pop(context);
    questionDigit = digits;
    generateQuestion();
    _scoreReset();
    state.setState(() {});
  }

  _scorePlus() {
    _score.increment(1);
  }

  _scoreReset() {
    _score = Accumulator();
  }
}
