import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:codigo_de_estrada_mz/constantes.dart';
import 'package:codigo_de_estrada_mz/blocs/usuario_bloc.dart';
import 'package:codigo_de_estrada_mz/ui/loja/widgets/purchase_box.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class GetPremium extends StatefulWidget {
  @override
  _GetPremiumState createState() => _GetPremiumState();
}

class _GetPremiumState extends State<GetPremium> {
  final List<String> itens = [
    "Sem anuncios",
    "Todos testes desbloqueados",
    "Respostas gratuítas",
    "Novos modos de jogo",
    "100MZN por 12h grátis",
  ];
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: branco,
      key: _scaffoldKey,
      body: Container(
        decoration: BoxDecoration(
          color: branco,
          border: Border(
            top: BorderSide(width: 50, color: lightgreen),
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 20),
                alignment: Alignment.center,
                child: Text(
                  "Versão premium".toUpperCase(),
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: lightgreen,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                alignment: Alignment.center,
                child: Text(
                  BlocProvider.getBloc<UsuarioBloc>().userData.premium
                      ? "Adquirda!"
                      : "400 MZN",
                  style: TextStyle(
                      fontSize: 30, fontWeight: FontWeight.bold, color: preto),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Divider(
                height: 4,
                color: Colors.black54,
              ),
              _item(itens[0]),
              _item(itens[1]),
              _item(itens[2]),
              _item(itens[3]),
              _item(itens[4]),
              Divider(
                height: 4,
                color: Colors.black54,
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: lightgreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  onPressed: () async {
                    if (BlocProvider.getBloc<UsuarioBloc>().userData.premium)
                      Navigator.pop(context);
                    else
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => PurchaseBox(
                          cs: 400,
                          cor: lightgreen,
                          gradient: null,
                          scaffoldKey: _scaffoldKey,
                        ),
                      ).then((value) {
                        setState(() {});
                      });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: Text(
                      BlocProvider.getBloc<UsuarioBloc>().userData.premium
                          ? "Voltar"
                          : "Virar Premium",
                      style: TextStyle(fontSize: 24, color: branco),
                    ),
                  ),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Row(
                  children: <Widget>[
                    Icon(
                      FontAwesomeIcons.angleLeft,
                      color: lightred,
                    ),
                    Text(
                      "voltar",
                      style: TextStyle(color: lightred, fontSize: 16),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _item(String t) {
    return ListTile(
      leading: Icon(
        FontAwesomeIcons.check,
        color: lightgreen,
        size: 18,
      ),
      title: Text(
        t,
        style: TextStyle(fontSize: 18),
      ),
    );
  }
}
