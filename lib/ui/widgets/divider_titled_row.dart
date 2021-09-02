import 'package:flutter/material.dart';

class DividerTitledRow extends StatelessWidget {
  final Color textColor;
  final Color lineColor;
  final String text;
  DividerTitledRow(
      {@required this.text,
      @required this.lineColor,
      @required this.textColor});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            width: double.infinity,
            height: 1,
            color: lineColor,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 24,
              color: textColor,
            ),
          ),
        ),
        Expanded(
          child: Container(
            width: double.infinity,
            height: 1,
            color: lineColor,
          ),
        ),
      ],
    );
  }
}
