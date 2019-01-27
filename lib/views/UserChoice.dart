import 'package:flutter/material.dart';
import 'package:first_app/controllers/UserChoiceController.dart';
import 'package:first_app/controllers/LoadingController.dart';
import 'package:first_app/views/clientViews/MainClient.dart';
import 'package:first_app/views/workerViews/MainWorker.dart';
import 'package:first_app/views/workerViews/WorkerComplement.dart';
import 'package:flutter/cupertino.dart';

class UserChoice extends StatefulWidget {
  _UserChoice createState() => _UserChoice();
}

class _UserChoice extends State<UserChoice> {

  UserChoiceController userChoiceController;
  LoadingController loadingController;
  bool load;

  @override
  void initState() {
    load = false;
    userChoiceController = new UserChoiceController();
    loadingController = new LoadingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    return new Scaffold(backgroundColor: Theme.of(context).backgroundColor, body: load ? loadingController.initLoadingScreen("BUSCANDO INFORMAÇÕES...") : new Stack(
      children: <Widget>[
        new Container( decoration: BoxDecoration(image: DecorationImage(image: new AssetImage("assets/graphics/background2.png"), fit:  BoxFit.cover))),
        new Center(child: new Padding(padding: EdgeInsets.all(20), child:
        new Container(padding: EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Column(mainAxisSize: MainAxisSize.min,children: <Widget>[
              new Text("OLÁ, COMO VOCÊ QUER ENTRAR ?", style: TextStyle(color: Theme.of(context).primaryColorDark, fontWeight: FontWeight.bold)),
              new Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 10), child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: <Widget>[
                RaisedButton(
                    shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                    child: const Text('CLIENTE', style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold)),
                    textColor: Theme.of(context).primaryColor,
                    color: Theme.of(context).accentColor,
                    elevation: 4.0,
                    onPressed: () {
                      setState(() {load = true;});
                      userChoiceController.clientChoice((){
                        Route route = CupertinoPageRoute(builder: (context) => MainClient());
                        Navigator.pushAndRemoveUntil(context, route, (Route<dynamic> route) => false);
                      });
                    }),
                RaisedButton(
                    shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: const Text('TRABALHADOR', style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold)),
                    textColor: Theme.of(context).primaryColor,
                    color: Theme.of(context).accentColor,
                    elevation: 4.0,
                    onPressed:(){
                      setState(() {load = true;});
                      userChoiceController.workerChoice((result){
                        if(result) Navigator.pushAndRemoveUntil(context, CupertinoPageRoute(builder: (context) => MainWorker()), (Route<dynamic> route) => false);
                        else Navigator.pushAndRemoveUntil(context, CupertinoPageRoute(builder: (context) => WorkerComplement()), (Route<dynamic> route) => false);
                      });
                    }),
              ])),
              new Text("Você poderá mudar de perfil a qualquer momento dentro do aplicativo.", style: TextStyle(color: Theme.of(context).primaryColorDark, fontSize: 12), textAlign: TextAlign.center)]))
          ),
        )
      ],
    ));
  }
}