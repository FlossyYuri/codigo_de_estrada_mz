import 'dart:async';

import 'package:codigo_de_estrada_mz/enums/connectivity_status.dart';
import 'package:connectivity/connectivity.dart';

class ConnectivityService {
  StreamController<ConnectivityStatus> statusController =
      StreamController<ConnectivityStatus>();

  ConnectivityService() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      Connectivity().checkConnectivity().then((value) {
        statusController.sink.add(_getStatusFromResult(value));
        var connectionStatus = _getStatusFromResult(result);
        statusController.add(connectionStatus);
      });
    });
  }

  ConnectivityStatus _getStatusFromResult(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.mobile:
        return ConnectivityStatus.CELULAR;
      case ConnectivityResult.wifi:
        return ConnectivityStatus.WIFI;
      case ConnectivityResult.none:
        return ConnectivityStatus.OFFLINE;
      default:
        return ConnectivityStatus.OFFLINE;
    }
  }
}
