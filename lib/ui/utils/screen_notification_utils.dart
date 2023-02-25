
import 'package:codigo_de_estrada_mz/constantes.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ScreenNotificationUtils {
  void showLoadingModal(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            height: 200,
            width: 200,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 60,
                    width: 60,
                    child: CircularProgressIndicator(
                      strokeWidth: 5,
                      valueColor: AlwaysStoppedAnimation(
                        mainBG,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text("Loading"),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void showToast(String text) {
    Fluttertoast.showToast(
      msg: "Ja existe um usuario com esse contacto",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
    );
  }
}
