import 'package:flutter/cupertino.dart';

class CommonUtils {
  void popUntilRoot(BuildContext context) {
    while (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  void popUntilRootAndPush(BuildContext context, CupertinoPageRoute route) {
    while (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
    Navigator.pushReplacement(context, route);
  }
}
