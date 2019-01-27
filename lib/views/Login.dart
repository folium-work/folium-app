import 'package:flutter/material.dart';
import 'package:first_app/controllers/LoginController.dart';
import 'package:first_app/controllers/LoadingController.dart';
import 'package:first_app/views/UserChoiceRegister.dart';
import 'UserChoice.dart';
import 'package:flutter/cupertino.dart';

class Login extends StatefulWidget {
  @override
  _Login createState() => _Login();
}

class _Login extends State<Login> {
  TextEditingController emailController, passwordController;
  bool load;
  LoadingController loadingController;
  LoginController loginController;

  @override
  initState(){
    super.initState();
    loginController = new LoginController();
    emailController = new TextEditingController();
    passwordController = new TextEditingController();
    loadingController = new LoadingController();
    load = false;
  }


  Widget build(BuildContext context){
      return new Scaffold(backgroundColor: Theme.of(context).backgroundColor,
        body: Builder(builder: (context) => load ? contentLoading() : contentLogin(context))
      );
  }

  void login(BuildContext context) async{
    setState(() {load = true;});

    bool _result = await loginController.login(emailController.text, passwordController.text);

    if(_result){
      Route route = CupertinoPageRoute(builder: (context) => UserChoice());
      setState(() {load = false;});
      Navigator.pushAndRemoveUntil(context, route, (Route<dynamic> route) => false);
    }
    else {
      setState(() {load = false;});
      Scaffold.of(context).showSnackBar(new SnackBar(content: new Text("Email ou senha incorretos")));
    }
  }

  Widget contentLoading(){
    return loadingController.initLoadingScreen("CARREGANDOS DADOS...");
  }

  Widget contentLogin(BuildContext context){
    return new Center(child: new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        new Text("Seja bem vindo", textAlign: TextAlign.right,
            style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor, fontSize: 22)),
        new Padding(
            padding: EdgeInsets.fromLTRB(20, 25, 20, 0), child:
        new Column(children: <Widget>[
          TextField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelStyle: new TextStyle(color: Theme.of(context).primaryColor),
              focusedBorder: const OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white, width: 1.5),
              ),
              labelText: "Email:",
              hintText: "Ex: willrcneto@gmail.com",
              border: OutlineInputBorder(),
            ),
          ),new Padding(
              padding: EdgeInsets.fromLTRB(0, 15, 0, 0), child: TextField(
            controller: passwordController,
            obscureText: true,
            decoration: InputDecoration(
              labelStyle: new TextStyle(color: Theme.of(context).primaryColor),
              focusedBorder: const OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white, width: 0.0),
              ),
              labelText: "Senha:",
              border: OutlineInputBorder(),
            ),
          )
          ), new Container(child: new Align(child: FlatButton(onPressed: (){}, child: Text("ESQUECEU SUA SENHA?", style: TextStyle(fontSize: 10),)), alignment: Alignment.centerRight))
        ])
        ),
        new Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            width: double.infinity,
            child:
            new RaisedButton(
                padding: EdgeInsets.all(15),
                child: new Text("LOGIN", style: TextStyle(color: Theme.of(context).backgroundColor)),
                color: Theme.of(context).primaryColor,
                onPressed: (){
                  login(context);
                })
        ),
        new Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            width: double.infinity,
            child:
            new RaisedButton(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
                padding: EdgeInsets.all(15),
                child: new Text("CADASTRE-SE", style: TextStyle(color: Theme.of(context).primaryColor)),
                color: Theme.of(context).accentColor,
                onPressed: (){
                  Navigator.push(context, CupertinoPageRoute(builder: (context) => UserChoiceRegister()));
                })
        )
      ],
    ));
  }
}