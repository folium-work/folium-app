import 'package:flutter/material.dart';
import 'package:first_app/views/SimpleRegister.dart';
import 'package:flutter/cupertino.dart';
import 'package:first_app/views/workerViews/WorkerComplement.dart';

class UserChoiceRegister extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: options.length,
        child: Scaffold(
          appBar:  AppBar(
            backgroundColor: Theme.of(context).backgroundColor,
            centerTitle: true,
            title:  new Text("Vamos lá"),
            bottom: TabBar(
              indicatorColor: Colors.white,
              tabs:  options.map((Option option) {
                return new Tab(text: option.title.toUpperCase());
              }).toList(),
            ),
          ),
          body: TabBarView(
            children: options.map((Option option) {
              return new ChoiceCard(option, context);
            }).toList(),
          ),
        ),
      ),
    );
  }
}

List<Option> options = <Option>[
  Option(title: "Cliente", text: "NESSA ABA VOCÊ PODE SE CADASTRAR COMO UM CLIENTE. UM CLIENTE PODE VISUALIZAR OS DIVERSOS SERVIÇOS E TRABALHADORES DISPONÍVEIS EM SUA REGIÃO. É POSSÍVEL CONTACTÁ-LOS, CONTRATÁ-LOS E AVALAIÁ-LOS POR MEIO DO APLICATIVO", image: Image.asset("assets/graphics/customer.png", width: 70), backgroundUrl:"assets/graphics/background_client_test.png"),
  Option(title: "Trabalhador", text: "NESSA ABA VOCÊ PODE SE CADASTRAR COMO UM TRABALHADOR. UM TRABALHADOR PODE EXPOR SUAS ATIVIDADES, SERVIÇOES, CONTATO E NOTÍCIAS DE SEU TRABALHO À COMUNIDADE. É UMA ÓTIMA OPORTUNIDADE DE MARKETING COMERCIAL", image: Image.asset("assets/graphics/suitcase.png", width: 70), backgroundUrl:"assets/graphics/background_worker_test.png")
];

class Option {
  Option({this.text, this.title, this.image, this.backgroundUrl});
  String title, text, backgroundUrl;
  Image image;
}

class ChoiceCard extends StatelessWidget {
  const ChoiceCard(this.option, this._context);
  final Option option;
  final BuildContext _context;

  @override
  Widget build(BuildContext context) {
      return new Stack(children: <Widget>[
        new Container(
          decoration: new BoxDecoration(
            image: new DecorationImage(
                image: new AssetImage(option.backgroundUrl),
                fit: BoxFit.cover
            ),
          ),
        ),
        new Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              option.image,
              new Padding(
                  child: new Text(option.text, style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                  padding: EdgeInsets.fromLTRB(15, 20, 15, 0)
              ),
            ])
          ),
        new Align(alignment: Alignment.bottomCenter, child:
          new Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 40),
            child: new RaisedButton(
              elevation: 20,
               padding: EdgeInsets.all(15),
               shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
               child: new Text("CADASTRE-SE COMO ${option.title.toUpperCase()}", style: TextStyle(color: Colors.white)),
               color: Theme.of(_context).backgroundColor,
               onPressed: (){
                 Navigator.push(_context, CupertinoPageRoute(builder: (context) => SimpleRegister(typeUser: option.title)));
//                 Navigator.push(_context, CupertinoPageRoute(builder: (context) => WorkerComplement()));
               }),
          )
        )
    ]);
  }
}