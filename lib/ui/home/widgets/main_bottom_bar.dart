import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:codigo_de_estrada_mz/blocs/usuario_bloc.dart';
import 'package:codigo_de_estrada_mz/constantes.dart';
import 'package:codigo_de_estrada_mz/models/usuario.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomBottomBar extends StatelessWidget {
  final GlobalKey<ScaffoldState> _keys;
  CustomBottomBar(this._keys);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: pagePadding,
      decoration: BoxDecoration(color: mainBG.withAlpha(150)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              IconButton(
                tooltip: "User profile",
                splashColor: Colors.white,
                icon: Icon(
                  FontAwesomeIcons.user,
                  color: Colors.white,
                  size: 22,
                ),
                onPressed: () {
                  _keys.currentState.openDrawer();
                },
              ),
              StreamBuilder<Usuario>(
                stream: BlocProvider.getBloc<UsuarioBloc>().outUsuario,
                builder: (context, user) {
                  if (user.hasData) {
                    return Text(
                      user.data.username,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 22, color: branco),
                    );
                  }
                  return Container();
                },
              ),
            ],
          ),
          _buildPrincipal()
        ],
      ),
    );
  }

  Widget _buildPrincipal() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/cs.png"),
            ),
          ),
        ),
      ],
    );
  }
}
