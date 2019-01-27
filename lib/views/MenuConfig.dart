import 'package:flutter/material.dart';
import 'package:first_app/controllers/LoginController.dart';
import 'package:first_app/views/Home.dart';
import 'package:first_app/views/UserChoice.dart';
import 'package:flutter/cupertino.dart';

class MenuConfig extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(body:  new Stack(children: <Widget>[
        new Container(color: Theme.of(context).accentColor,
          child: new Center(child:
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new Align(child: new Padding(padding: EdgeInsets.all(20), child: new Text("CONFIGURAÇÕES", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25))), alignment: Alignment.centerLeft),
              new Align(child: new FlatButton(onPressed: (){
                Route route = CupertinoPageRoute(builder: (context) => UserChoice());
                Navigator.push(context, route);
              }, child: new Text("MUDAR VISÃO COMO CLIENTE/TRABALHADOR", style: TextStyle(fontWeight: FontWeight.bold))), alignment: Alignment.centerLeft),
              new Align(child: new FlatButton(onPressed: (){}, child: new Text("TERMOS DE SERVIÇO E PRIVACIDADE", style: TextStyle(fontWeight: FontWeight.bold))), alignment: Alignment.centerLeft),
              new Align(child: new FlatButton(onPressed: (){}, child: new Text("FALE CONOSCO", style: TextStyle(fontWeight: FontWeight.bold))), alignment: Alignment.centerLeft),
              new Align(child: new FlatButton(onPressed: (){}, child: new Text("EDITAR PERFIL", style: TextStyle(fontWeight: FontWeight.bold))), alignment: Alignment.centerLeft),
              new Align(child: new FlatButton(child: new Text("SAIR DO APP", style: TextStyle(fontWeight: FontWeight.bold)), onPressed: (){
                  LoginController().logOut((){
                  Route route = CupertinoPageRoute(builder: (context) => Home(title: "Folium.work"));
                  Navigator.pushAndRemoveUntil(context, route, (Route<dynamic> route) => false);
                });
              }), alignment: Alignment.centerLeft),
            ],
          )
          ))
        ]
      ));
  }
}