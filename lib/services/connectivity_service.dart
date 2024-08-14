import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:latest_codigo_de_estrada/enums/connectivity_status.dart';

class ConnectivityService {
  StreamController<ConnectivityStatus> statusController =
      StreamController<ConnectivityStatus>();

  ConnectivityService() {
    // Inicializa o ConnectivityPlus
    Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> result) {

          // Obtém o status atual de conectividade
          Connectivity().checkConnectivity().then((List<ConnectivityResult> value) {
            statusController.sink
                .add(_getStatusFromResult(value.first));
            var connectionStatus = _getStatusFromResult(result.first);
            statusController.add(connectionStatus);
          },);
        },);
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

  // Fechar o StreamController quando não for mais necessário
  void dispose() {
    statusController.close();
  }
}
