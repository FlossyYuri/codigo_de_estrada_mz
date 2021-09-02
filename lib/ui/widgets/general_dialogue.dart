import 'package:flutter/material.dart';

class GeneralDialogue extends StatefulWidget {
  GeneralDialogue({Key key}) : super(key: key);

  @override
  _GeneralDialogueState createState() => _GeneralDialogueState();
}

class _GeneralDialogueState extends State<GeneralDialogue> {
  @override
  Widget build(BuildContext context) {
    showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierColor: Colors.black45,
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (BuildContext buildContext, Animation animation,
            Animation secondaryAnimation) {
          return Center(
            child: Container(
              width: MediaQuery.of(context).size.width - 10,
              height: MediaQuery.of(context).size.height - 80,
              padding: EdgeInsets.all(20),
              color: Colors.white,
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "Save",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                        primary: const Color(0xFF1BC0C5)),
                  )
                ],
              ),
            ),
          );
        });
    return Container(
      child: Column(
        children: <Widget>[],
      ),
    );
  }
}
