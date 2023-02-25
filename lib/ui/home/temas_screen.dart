import 'package:codigo_de_estrada_mz/constantes.dart';
import 'package:codigo_de_estrada_mz/enums/connectivity_status.dart';
import 'package:codigo_de_estrada_mz/services/connectivity_service.dart';
import 'package:codigo_de_estrada_mz/ui/home/views/temas_view.dart';
import 'package:codigo_de_estrada_mz/ui/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TemasScreen extends StatelessWidget {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final Color branco = Colors.white;
  final Color preto = Colors.black;
  // background-image: linear-gradient( 114.9deg,  rgba(34,34,34,1) 8.3%, rgba(0,40,60,1) 41.6%, rgba(0,143,213,1) 93.4% );
  final LinearGradient mainGrad = LinearGradient(colors: [
    Color.fromRGBO(84, 13, 110, 1),
    Color.fromRGBO(238, 66, 102, 1),
  ], begin: Alignment.topCenter, end: Alignment.bottomCenter);
  @override
  Widget build(BuildContext context) {
    return StreamProvider<ConnectivityStatus>(
      initialData: ConnectivityStatus.OFFLINE,
      create: (context) => ConnectivityService().statusController.stream,
      child: Scaffold(
        key: _scaffoldKey,
        body: Container(
          decoration: BoxDecoration(color: mainBG),
          child: Stack(
            children: <Widget>[
              TemasView(),
            ],
          ),
        ),
        drawer: CustomDrawer(_scaffoldKey),
      ),
    );
  }
}
