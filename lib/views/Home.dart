import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'Login.dart';
import 'package:first_app/controllers/LoginController.dart';
import 'package:first_app/views/UserChoice.dart';
import 'package:flutter/cupertino.dart';

class Home extends StatefulWidget {
  final String title;
  Home({Key key, @required this.title}) : super(key: key);

  _Home createState() => new _Home();
}

class _Home extends State<Home> {

  @override
  void initState() {
    _check();
    super.initState();
  }

  void _check() async{
    bool exists = await LoginController().checkUserLogged();
    Route route = new CupertinoPageRoute(builder: (context) => UserChoice());
    if(exists) Navigator.pushReplacement(context, route);
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: new Stack(
            children: <Widget>[
              new Container(
                decoration: new BoxDecoration(
                  image: new DecorationImage(
                      image: new AssetImage("assets/graphics/background.png"),
                      fit: BoxFit.cover),
                ),
              ),
              new Center(child:
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  new Image.asset("assets/graphics/logo.png", width: 100),
                  new Padding(child: new Text(
                      "\"A melhor oportunidade de vender suas habilidades e encontrar serviços\"",
                      style:
                      TextStyle(fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center),
                      padding: EdgeInsets.fromLTRB(5, 20, 5, 0))
                ],
              )
              ),
              new Padding(padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10), child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  new Align(
                    child: RaisedButton(
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0)),
                      padding: EdgeInsets.symmetric(
                          horizontal: 45, vertical: 20),
                      child: const Text('PARTICIPE',
                          style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold)),
                      textColor: Theme
                          .of(context)
                          .primaryColorDark,
                      color: Theme
                          .of(context)
                          .primaryColor,
                      elevation: 4.0,
                      onPressed: () {
                        Navigator.push(
                          context,
                            CupertinoPageRoute(builder: (context) => Login())
                        );
                      },),
                    alignment: Alignment.bottomLeft,
                  ),
                  new Align(
                    child: RaisedButton(
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0)),
                      padding: EdgeInsets.symmetric(
                          horizontal: 45, vertical: 20),
                      child: const Text('PROCURAR',
                          style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold)),
                      textColor: Theme
                          .of(context)
                          .primaryColorDark,
                      color: Theme
                          .of(context)
                          .primaryColor,
                      elevation: 4.0,
                      onPressed: () {
                        //nothing
                      },),
                    alignment: Alignment.bottomRight,
                  ),
                ],
              ))
            ])
    );
  }
}