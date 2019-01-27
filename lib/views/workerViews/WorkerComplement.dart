import 'package:flutter/material.dart';
import 'package:first_app/controllers/LoadingController.dart';
import 'package:first_app/controllers/CategoryController.dart';
import 'package:first_app/pojo/Category.dart';
import 'package:first_app/views/workerViews/MainWorker.dart';
import 'package:first_app/controllers/WorkerComplementController.dart';

class WorkerComplement extends StatefulWidget {
  _WorkerComplement createState() => _WorkerComplement();
}

class _WorkerComplement extends State<WorkerComplement> {

  final TextEditingController addressTxtController = new TextEditingController(), descriptionTxtController = new TextEditingController(), instagramTxtController = new TextEditingController(), whatsAppTxtController = new TextEditingController(),
      facebookTxtController = new TextEditingController(), curriculumTxtController = new TextEditingController();

  bool _load, _valueCreditCard, _valueCheck, _valueCash, _valueHomeCare, _valueFreeBudget;
  List<Category> _categories;
  List<Widget> _categoriesWidgets;
  Category _categorySelected;

  @override
  void initState() {
    _categoriesWidgets = new List();
    _categorySelected = new Category(-1, "selecionar profissão".toUpperCase());
    _load = _valueCash = _valueCheck =_valueCreditCard = _valueHomeCare = _valueFreeBudget = false;
    _loadCategoriesMenu();
    super.initState();
  }

  void openSheet(){
    showModalBottomSheet<void>(context: context,
        builder: (BuildContext context) {
          return new SingleChildScrollView(child:
            new Column(
              mainAxisSize: MainAxisSize.max,
              children: _categoriesWidgets
            )
          );
        });
  }
  
  void _loadCategoriesMenu() async {
    _categories = await CategoryController().getCategories();
    _categoriesWidgets = _categories.map((item) =>
      new ListTile(
        title: new Text(item.content),
        onTap: (){
          setState(() {
            _categorySelected = item;
          });
          Navigator.pop(context);
        },
      )).toList();
  }

  void _finishComplement(BuildContext _context) async {
    if(!_valueCreditCard && !_valueCash && !_valueCheck){
      Scaffold.of(_context).showSnackBar(new SnackBar(content: new Text("Selecione ao menos uma forma de pagamento")));
    } else if(_categorySelected.uid == -1){
      Scaffold.of(_context).showSnackBar(new SnackBar(content: new Text("Selecione a sua profissão")));
    } else if(addressTxtController.text.trim().length < 5){
      Scaffold.of(_context).showSnackBar(new SnackBar(content: new Text("Endereço obgrigatório")));
    }else{
      setState(() {
        _load = true;
      });
      bool result = await new WorkerComplementController().registerCompleteWorker(_categorySelected, addressTxtController.text, descriptionTxtController.text,
          _valueCreditCard, _valueCheck, _valueCash, _valueHomeCare, _valueFreeBudget, whatsAppTxtController.text, instagramTxtController.text, facebookTxtController.text);
      if(!result) Scaffold.of(_context).showSnackBar(new SnackBar(content: new Text("Erro")));
      else
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MainWorker()), (Route<dynamic> route) => false);
    }
  }

  void _changeValueCreditCard(bool value) => setState(()=> _valueCreditCard = value);
  void _changeValueCheck(bool value) => setState(()=> _valueCheck = value);
  void _changeValueMoney(bool value) => setState(()=> _valueCash = value);
  void _changeHomeCare(bool value) => setState(()=> _valueHomeCare = value);
  void _changeFreeBudget(bool value) => setState(()=> _valueFreeBudget = value);

  Widget contentLoading(){
    return LoadingController().initLoadingScreen("finalizando cadastro...".toUpperCase());
  }

  Widget contentWorkerComplement(BuildContext _context){
    return new SingleChildScrollView(child:
        new Column(children: <Widget>[
        new Stack(children: <Widget>[
          new Container(
            height: 250,
            width: double.infinity,
            child: new Image.asset("assets/graphics/background2.png", fit: BoxFit.cover)
          ),
          new Padding(padding: EdgeInsets.fromLTRB(0, 150, 0, 0), child:
            new Container(decoration: BoxDecoration(color: Theme.of(_context).backgroundColor, borderRadius: BorderRadius.only(topRight: Radius.circular(80))), child: new Column(children: <Widget>[
                new Container(padding: EdgeInsets.fromLTRB(20, 20, 20, 10), child:
                  new Align(alignment: Alignment.centerLeft, child: Text("quase lá".toUpperCase(), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white), textAlign: TextAlign.start))
                ),
                new Container(padding: EdgeInsets.only(left: 20, right: 20, top: 20), child:
                  new Padding(padding: EdgeInsets.only(left: 0,bottom: 20, top: 20), child: new Align(alignment: Alignment.centerLeft, child:
                      new Column(children: <Widget>[
                        new Row(mainAxisSize: MainAxisSize.max,children: <Widget>[
                          new Image.asset("assets/graphics/briefcase.png", width: 20, height: 20),
                          new Padding(padding: EdgeInsets.only(left: 20), child: SizedBox(width: 200, child: Text(_categorySelected.content, style: TextStyle(fontSize: 14), overflow: TextOverflow.ellipsis))),
                          new Expanded(child: new Align(alignment: Alignment.centerRight,child: new ButtonTheme(height: 30, minWidth: 30,child: new RaisedButton(color: Theme.of(_context).accentColor, child: new Icon(Icons.mode_edit), onPressed: openSheet))))
                        ]),

                      ])
                  )),
                ),
                new Container(padding: EdgeInsets.only(left: 20, right: 20, top: 10), child:
                  new TextField(
                    keyboardType: TextInputType.text,
                    controller: addressTxtController,
                    maxLength: 200,
                    decoration: InputDecoration(
                      helperText: "campo obrigatório",
                      errorMaxLines: 200,
                      icon: Image.asset("assets/graphics/location.png", width: 20, height: 20),
                      labelStyle: new TextStyle(color: Theme.of(_context).primaryColor),
                      focusedBorder: const UnderlineInputBorder(borderSide: const BorderSide(color: Colors.white, width: 1)),
                      labelText: "Endereço:",
                      hintText: "Rua Veras de Holanda, Irapuá 2 - 101",
                      border: UnderlineInputBorder(),
                    ),
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                new Container(padding: EdgeInsets.only(left: 20, right: 20, top: 20), child:
                  new TextField(
                    maxLines: 3,
                    keyboardType: TextInputType.text,
                    controller: descriptionTxtController,
                    maxLength: 400,
                    decoration: InputDecoration(
                      icon: Image.asset("assets/graphics/text.png", width: 20, height: 20),
                      labelStyle: new TextStyle(color: Theme.of(_context).primaryColor),
                      focusedBorder: const OutlineInputBorder(borderSide: const BorderSide(color: Colors.white, width: 1)),
                      labelText: "Descrição:",
                      helperText: "Diga algo sobre você e seu trabalho",
                      border: OutlineInputBorder(),
                    ),
                    style: TextStyle(fontSize: 16)
                  ),
                ),
                new Container(padding: EdgeInsets.only(left: 5, right: 20, top: 20), child:
                new Column(children: <Widget>[
                    new Padding(padding: EdgeInsets.only(left: 15,bottom: 20, top: 20), child: new Align(alignment: Alignment.centerLeft, child:
                      new Row(children: <Widget>[
                        new Image.asset("assets/graphics/payment.png", width: 20, height: 20),
                        new Padding(padding: EdgeInsets.only(left: 20), child: Text("Selecione suas formas de gagamento:"))
                      ])
                    )),
                    new SwitchListTile(
                      value: _valueCreditCard,
                      onChanged: _changeValueCreditCard,
                      title: new Text('Cartão de Crédito'),
                      activeColor: Theme.of(_context).accentColor,
                    ),
                    new SwitchListTile(
                      value: _valueCheck,
                      onChanged: _changeValueCheck,
                      title: new Text('Cheque'),
                      activeColor: Theme.of(_context).accentColor,
                    ),
                    new SwitchListTile(
                      value: _valueCash,
                      onChanged: _changeValueMoney,
                      title: new Text('Em espécie'),
                      activeColor: Theme.of(_context).accentColor,
                    ),
                  ],
                )),
                new Container(padding: EdgeInsets.only(left: 5, right: 20, top: 20), child:
                new Column(children: <Widget>[
                  new Padding(padding: EdgeInsets.only(left: 15,bottom: 20, top: 20), child: new Align(alignment: Alignment.centerLeft, child:
                  new Row(children: <Widget>[
                    new Image.asset("assets/graphics/service.png", width: 20, height: 20),
                    new Padding(padding: EdgeInsets.only(left: 20), child: Text("Outros dados de serviço:"))
                  ])
                  )),
                  new SwitchListTile(
                    value: _valueHomeCare,
                    onChanged: _changeHomeCare,
                    title: new Text('Atendimento a domocílio'),
                    activeColor: Theme.of(_context).accentColor,
                  ),
                  new SwitchListTile(
                    value: _valueFreeBudget,
                    onChanged: _changeFreeBudget,
                    title: new Text('Orçamento gratuito'),
                    activeColor: Theme.of(_context).accentColor,
                  )
                ])
              ),
              new Container(padding: EdgeInsets.only(left: 20, right: 20, top: 20), child:
                new Column(children: <Widget>[
                  new Padding(padding: EdgeInsets.only(bottom: 20,top: 20), child: new Align(alignment: Alignment.centerLeft, child:
                    new Row(children: <Widget>[
                      new Image.asset("assets/graphics/chat.png", width: 20, height: 20), new Padding(padding: EdgeInsets.only(left: 20), child: Text("Redes para contato:"))
                    ])
                  )),
                  new Padding(padding: EdgeInsets.only(bottom: 15), child: new TextField(
                    keyboardType: TextInputType.phone,
                    controller: whatsAppTxtController,
                    decoration: InputDecoration(
                      helperText: "Ex: 88998394528",
                      labelStyle: new TextStyle(color: Theme.of(_context).primaryColor),
                      focusedBorder: const OutlineInputBorder(borderSide: const BorderSide(color: Colors.white, width: 1)),
                      labelText: "WhatsApp",
                      hintText: "Ex: 88998394528",
                      border: OutlineInputBorder(),
                    ),
                    style: TextStyle(fontSize: 14),
                  )),
                  new Padding(padding: EdgeInsets.only(bottom: 15), child: new TextField(
                    keyboardType: TextInputType.text,
                    controller: instagramTxtController,
                    decoration: InputDecoration(
                      helperText: "Ex: @neto_will",
                      labelStyle: new TextStyle(color: Theme.of(_context).primaryColor),
                      focusedBorder: const OutlineInputBorder(borderSide: const BorderSide(color: Colors.white, width: 1)),
                      labelText: "Instagram",
                      hintText: "Ex: @neto_will",
                      border: OutlineInputBorder(),
                    ),
                    style: TextStyle(fontSize: 14),
                  )),
                  new Padding(padding: EdgeInsets.only(bottom: 15), child: new TextField(
                    keyboardType: TextInputType.text,
                    controller: facebookTxtController,
                    decoration: InputDecoration(
                      helperText: "facebook.com/neto_will",
                      labelStyle: new TextStyle(color: Theme.of(_context).primaryColor),
                      focusedBorder: const OutlineInputBorder(borderSide: const BorderSide(color: Colors.white, width: 1)),
                      labelText: "Facebook",
                      hintText: "Ex: facebook.com/neto_will",
                      border: OutlineInputBorder(),
                    ),
                    style: TextStyle(fontSize: 14),
                  )),
                ])
              ),
              new Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                width: double.infinity,
                child:
                new RaisedButton(
                    padding: EdgeInsets.all(15),
                    child: new Text("concluir".toUpperCase(), style: TextStyle(color: Theme.of(_context).primaryColor)),
                    color: Theme.of(_context).accentColor,
                    onPressed: () => _finishComplement(_context)
                )
              ),
            ]),
          ))
        ]),
      ]));
  }

  @override
  Widget build(BuildContext context){
    return new Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body:  Builder(builder: (_context) =>  _load ? contentLoading() : contentWorkerComplement(_context)
        ));
  }

}