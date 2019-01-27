import 'package:flutter/material.dart';
import 'package:first_app/controllers/LoginController.dart';
import 'package:first_app/controllers/LoadingController.dart';
import 'package:flutter/cupertino.dart';
import 'package:first_app/views/MenuConfig.dart';

class HomeClient extends StatefulWidget {
  _HomeClient createState() =>  new _HomeClient();
}

class _HomeClient extends State<HomeClient> {

  Image _image = new Image.network(LoginController().getCurrentClient().imageUrl, fit: BoxFit.cover,);

  bool _load = true;
  @override
  void initState() {
    _image.image.resolve(new ImageConfiguration()).addListener((_, __) {
      if (mounted) {
        setState(() {
          _load = false;
        });
      }
    });
    super.initState();
  }

  Widget contentLoading(){
    return LoadingController().initLoadingScreen("carregando perfil".toUpperCase());
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(backgroundColor: Colors.transparent, body: _load ? contentLoading() :
        new Stack(children: <Widget>[
            new Container(
              height: 400,
              width: double.infinity,
              child: _image
            ),
            new SingleChildScrollView(child:
              new Padding(padding: EdgeInsets.fromLTRB(0, 280, 0, 0), child:
                  new Column(children: <Widget>[
                    new Container(width: double.infinity, padding: EdgeInsets.only(left: 10, right: 10, bottom: 10), decoration: BoxDecoration(boxShadow: [new BoxShadow(color: Colors.black, blurRadius: 80.0)]), child: new Align(alignment: Alignment.centerLeft, child: new Text("BEM VINDO, "+LoginController().getCurrentClient().name.split(" ")[0].toUpperCase(), style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold, fontFamily: 'VarelaRound')))),
                    new Container(padding: EdgeInsets.only(top: 10),decoration: BoxDecoration(color: Theme.of(context).backgroundColor, borderRadius: BorderRadius.only(topRight: Radius.circular(80))), child: new Column(children: <Widget>[
                      new Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
                        new Padding(padding: EdgeInsets.only(left: 10, right: 20), child: new Column(mainAxisSize: MainAxisSize.min ,children: <Widget>[
                          new Align(child: FlatButton.icon( icon: new Image.asset("assets/graphics/briefcase.png", width: 20),onPressed: (){}, label: new Text("Procurar trabalhadores", style: TextStyle(fontWeight: FontWeight.bold))), alignment: Alignment.centerLeft),
                          new Align(child: FlatButton.icon( icon: new Image.asset("assets/graphics/quality.png", width: 20),onPressed: (){}, label: new Text("Trabalhadores favoritos", style: TextStyle(fontWeight: FontWeight.bold))), alignment: Alignment.centerLeft),
                          new Align(child: FlatButton.icon( icon: new Image.asset("assets/graphics/location.png", width: 20), label: new Text("Trabalhadores por perto", style: TextStyle(fontWeight: FontWeight.bold)), onPressed: (){}), alignment: Alignment.centerLeft),
                          new Align(child: FlatButton.icon( icon: new Image.asset("assets/graphics/messages.png", width: 20),onPressed: (){}, label: new Text("Caixa de mensagens", style: TextStyle(fontWeight: FontWeight.bold))), alignment: Alignment.centerLeft),
                          new Align(child: FlatButton.icon( icon: new Icon(Icons.settings, size: 20), label: new Text("Configurações", style: TextStyle(fontWeight: FontWeight.bold)), onPressed: (){
                            Navigator.push(context, CupertinoPageRoute(builder: (context) => MenuConfig()));
                          }), alignment: Alignment.centerLeft),
                        ]))
                      ])
                    ]))
                  ])
            )
          )
        ])
    );
  }
}