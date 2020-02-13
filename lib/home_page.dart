import 'package:calculate/home_page_view_model.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomePageViewModel viewModel;

  @override
  void initState() {
    viewModel = HomePageViewModel.init(
      state: this,
    );
    viewModel.generateQuestion();
    super.initState();
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    viewModel.context = context;
    return Scaffold(
      drawer: _drawerView(),
      appBar: AppBar(
        title: Text('Calculate'),
        leading: _LeadingButton(model: viewModel),
      ),
      body: Container(
        child: Stack(
          children: <Widget>[
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: _calculateView(),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: _padView(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _calculateView() {
    String operatorStr;
    switch (viewModel.operator) {
      case Operator.plus:
        operatorStr = '+';
        break;
      case Operator.minus:
        operatorStr = '-';
        break;
      case Operator.multiple:
        operatorStr = '×️';
        break;
      case Operator.divide:
        operatorStr = '÷';
        break;
    }
    TextStyle style = TextStyle(
      fontSize: 50,
    );

    return Container(
      margin: EdgeInsets.all(32),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 168,
            child: _scoreView(),
          ),
          Expanded(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('${viewModel.n1}', style: style),
                  Text('$operatorStr', style: style),
                  Text('${viewModel.n2}', style: style),
                  Text('=', style: style),
                  Text('${viewModel.result}', style: style),
                ],
              ),
            ),
          ),
          Container(
            width: 168,
            child: Center(
              child: Text(
                viewModel.resultStr,
                style: TextStyle(fontSize: 32),
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
//              _pad(PadType.del),
              _pad(PadType.num, num: 0),
//              _pad(PadType.ok),
            ],
          ),
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
        viewModel.onOkClicked();
      } else if (title == 'Del') {
        viewModel.onDelClicked();
      }
      setState(() {});
    });
  }

  Widget _numPad(String title) {
    int num = int.parse(title);
    return _tapPad(title, () => viewModel.onNumClicked(num));
  }

  Widget _tapPad(String title, void Function() target) {
    return FlatButton(
      onPressed: target,
      padding: EdgeInsets.zero,
      child: Container(
        margin: EdgeInsets.all(1),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(16),
        ),
        width: 96,
        height: 96,
        child: Center(
          child: Text(
            title,
            style: TextStyle(fontSize: 32),
          ),
        ),
      ),
    );
  }

  Widget _drawerView() {
    TextStyle style = TextStyle(
      fontSize: 20.0,
    );
    return Container(
      color: Colors.white,
      width: 256,
      child: ListView(
        children: <Widget>[
          FlatButton(
            child: Text('一位数加减乘除', style: style),
            onPressed: () => viewModel.onSettingQuestionClicked(1),
          ),
          FlatButton(
            child: Text('两位数加减乘除', style: style),
            onPressed: () => viewModel.onSettingQuestionClicked(2),
          ),
          FlatButton(
            child: Text('三位数加减乘除', style: style),
            onPressed: () => viewModel.onSettingQuestionClicked(3),
          ),
          FlatButton(
            child: Text('四位数加减乘除', style: style),
            onPressed: () => viewModel.onSettingQuestionClicked(4),
          ),
        ],
      ),
    );
  }

  Widget _scoreView() {
    return Container(
      child: Text(
        'score: ${viewModel.score}',
        style: TextStyle(
          fontSize: 32,
        ),
      ),
    );
  }
}

class _LeadingButton extends StatelessWidget {
  final HomePageViewModel model;
  _LeadingButton({
    this.model,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        model.onDrawerClicked(context);
      },
      icon: Icon(Icons.settings),
    );
  }
}
