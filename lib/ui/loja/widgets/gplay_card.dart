import 'dart:async';

import 'package:codigo_de_estrada_mz/blocs/transacoes_bloc.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';

class GPLAYCard extends StatefulWidget {
  final int item;
  GPLAYCard({@required this.item});
  @override
  _GPLAYCardState createState() => _GPLAYCardState();
}

class _GPLAYCardState extends State<GPLAYCard> {
  StreamSubscription _purchaseUpdatedSubscription;

  StreamSubscription _purchaseErrorSubscription;

  bool comprando = false;

  final List<String> _productLists = [
    '100_cs',
    '200_cs',
    '500_cs',
    'premium',
  ];

  List<IAPItem> _items = [];
  @override
  void initState() {
    super.initState();
    _initPlatformState();
  }

  Future<bool> _initPlatformState() async {
    // prepare
    await FlutterInappPurchase.instance.initConnection;
    await _getProduct();
    _purchaseUpdatedSubscription = FlutterInappPurchase.purchaseUpdated.listen(
      (productItem) {
        switch (productItem.productId) {
          case '100_cs':
            BlocProvider.getBloc<TransacoesBloc>().comprarCS(100, context);
            break;
          case '200_cs':
            BlocProvider.getBloc<TransacoesBloc>().comprarCS(200, context);
            break;
          case 'premium':
            BlocProvider.getBloc<TransacoesBloc>().virarPremium(context);
            break;
          case '500_cs':
            BlocProvider.getBloc<TransacoesBloc>().comprarCS(500, context);
            break;
        }
      },
    );

    _purchaseErrorSubscription = FlutterInappPurchase.purchaseError.listen(
      (purchaseError) {
        print("Novo erro: $purchaseError");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Compra mal sucedida.\n",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
            ),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.redAccent,
          ),
        );
      },
    );
    return true;
  }

  Future<Null> _requestPurchase(IAPItem item) async {
    await FlutterInappPurchase.instance.requestPurchase(item.productId);
  }

  Future<bool> _getProduct() async {
    List<IAPItem> items =
        await FlutterInappPurchase.instance.getProducts(_productLists);
    for (var item in items) {
      this._items.add(item);
    }
    return true;
  }

  @override
  void dispose() {
    if (_purchaseErrorSubscription != null) _purchaseErrorSubscription.cancel();
    if (_purchaseUpdatedSubscription != null)
      _purchaseUpdatedSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        border: Border.all(color: Colors.blueGrey[100], width: 1),
        boxShadow: [
          BoxShadow(
            blurRadius: 5,
            color: Colors.black.withOpacity(.1),
            offset: Offset(0, 0),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(.2),
            blurRadius: 5,
            offset: Offset(2.0, 4.0),
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
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              this._requestPurchase(_items[widget.item]).then(
                (_) {
                  comprando = false;
                },
              );
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              primary: Colors.blueGrey,
            ),
            child: Container(
              height: 40,
              alignment: Alignment.center,
              child: Text(
                "Comprar",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }
}
