import 'package:codigo_de_estrada/ui/utils/screen_notification_utils.dart';
import 'package:flutter/material.dart';

class GPLAYCard extends StatefulWidget {
  final int item;
  const GPLAYCard({super.key, required this.item});
  @override
  _GPLAYCardState createState() => _GPLAYCardState();
}

class _GPLAYCardState extends State<GPLAYCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        border: Border.all(color: Colors.blueGrey.shade100, width: 1),
        boxShadow: [
          BoxShadow(
            blurRadius: 5,
            color: Colors.black.withOpacity(.1),
            offset: const Offset(0, 0),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(.2),
            blurRadius: 5,
            offset: const Offset(2.0, 4.0),
          ),
        ],
      ),
      child: Column(
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: Image.asset(
              "assets/images/gplay.png",
              height: 50,
              alignment: Alignment.centerLeft,
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              ScreenNotificationUtils()
                  .showSnackBar(context, "Funcionalidade desabilitada");
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              backgroundColor: Colors.blueGrey,
            ),
            child: Container(
              height: 40,
              alignment: Alignment.center,
              child: const Text(
                "Comprar",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }
}
