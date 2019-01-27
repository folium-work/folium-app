import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:first_app/controllers/LocationController.dart' show LocationController;
import 'package:first_app/controllers/LoadingController.dart';
import 'package:first_app/controllers/SimpleRegisterController.dart';
import 'package:first_app/views/clientViews/MainClient.dart';
import 'package:first_app/views/workerViews/WorkerComplement.dart';

class SimpleRegister extends StatefulWidget {

  SimpleRegister({key: Key, this.typeUser});
  final String typeUser;

  _SimpleRegisterState createState() => new _SimpleRegisterState(typeUser: typeUser);

}

class _SimpleRegisterState extends State<SimpleRegister> {
  _SimpleRegisterState({this.typeUser});
  final String typeUser;

  TextEditingController emailController = new TextEditingController(), passwordController = new TextEditingController(), confirmPasswordController = new TextEditingController(), birthDayController = new TextEditingController(), nameController = new TextEditingController();
  List<DropdownMenuItem<String>> _dropDownCountriesMenuItems = new List(), _dropDownStatesMenuItems = new List(), _dropDownCitiesMenuItems = new List();
  String _selectedCountry = "Selecione o seu país".toUpperCase(),_selectedState = "Selecione o seu estado".toUpperCase(), _selectedCity = "Selecione sua cidade".toUpperCase();

  bool _load;
  DateTime date;
  File _image;

  @override
  void initState() {
    _load = false;
    _dropDownCountriesMenuItems.add(new DropdownMenuItem(value: _selectedCountry, child: new Text(_selectedCountry)));
    _dropDownStatesMenuItems.add(new DropdownMenuItem(value: _selectedState, child: new Text(_selectedState)));
    _dropDownCitiesMenuItems.add(new DropdownMenuItem(value: _selectedCity, child: new Text(_selectedCity)));
    _loadCountriesMenu();
    super.initState();
  }

  void changedCountryDropDownItem(String selectedCountry) {
      setState(() {
        _selectedCountry = selectedCountry;
        _loadStatesMenu(_selectedCountry);
      });
  }

  void changedStateDropDownItem(String selectedState) {
      setState(() {
        _selectedState = selectedState;
        _loadCitiesMenu(_selectedCountry, _selectedState);
      });
  }

  void changedCityDropDownItem(String selectedCity) {
    setState(() {
      _selectedCity = selectedCity;
    });
  }

  void _loadCountriesMenu() async{
    List<DropdownMenuItem<String>> items = _dropDownCountriesMenuItems;
    for (String country in await LocationController().getCountries()) {
      items.add(new DropdownMenuItem(value: country, child: new Text(country)));
    }

    setState(() {
      _dropDownCountriesMenuItems = items;
      _selectedCountry = _dropDownCountriesMenuItems[0].value;
      _selectedState = _dropDownStatesMenuItems[0].value;
      _selectedCity = _dropDownCitiesMenuItems[0].value;
    });
  }

  void _loadStatesMenu(String country) async{
    if(_dropDownStatesMenuItems.length>1) _dropDownStatesMenuItems.removeRange(1, _dropDownStatesMenuItems.length);

    List<DropdownMenuItem<String>> items = _dropDownStatesMenuItems;
    if(_dropDownCountriesMenuItems[0].value != _selectedCountry){
      for (String state in await LocationController().getStates(country)) {
        items.add(new DropdownMenuItem(value: state, child: new Text(state)));
      }
    }

    setState(() {
      _dropDownStatesMenuItems = items;
      _selectedState = _dropDownStatesMenuItems[0].value;
      _selectedCity = _dropDownCitiesMenuItems[0].value;
    });
  }

  void btnRegisterClicked(BuildContext context) async{
    bool validateEmail =  RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(emailController.text);
    if(nameController.text.trim().length<6){
      Scaffold.of(context).showSnackBar(new SnackBar(content: new Text("Digite o seu nome completo")));
    } else if(!validateEmail){
      Scaffold.of(context).showSnackBar(new SnackBar(content: new Text("Email inválido")));
    } else if(passwordController.text.trim().length <6){
      Scaffold.of(context).showSnackBar(new SnackBar(content: new Text("Senha deve conter mais de 6 dígitos")));
    } else if(passwordController.text != confirmPasswordController.text){
      Scaffold.of(context).showSnackBar(new SnackBar(content: new Text("Senhas não coincidem")));
    } else if(date == null) {
      Scaffold.of(context).showSnackBar(new SnackBar(content: new Text("Data de nascimento não fornecida")));
    } else if((DateTime.now().difference(date).inDays/365).floor() < 18 || (date.difference(DateTime.now()).inDays/365).floor()>70){
      Scaffold.of(context).showSnackBar(new SnackBar(duration: Duration(seconds: 3),content: new Text("A aplicação é restrita apenas para maiores de 18 anos e menores de 70 anos")));
    } else if(_selectedCountry == _dropDownCountriesMenuItems[0].value){
      Scaffold.of(context).showSnackBar(new SnackBar(content: new Text("País não selecionado")));
    } else if(_selectedState == _dropDownStatesMenuItems[0].value){
      Scaffold.of(context).showSnackBar(new SnackBar(content: new Text("Estado não selecionado")));
    } else if(_selectedCity == _dropDownCitiesMenuItems[0].value){
      Scaffold.of(context).showSnackBar(new SnackBar(content: new Text("Cidade não selecionada")));
    } else {
      var _simpleRegisterController = new SimpleRegisterController();
      _dialogTerms(() async {
        setState(() {_load = true;});
        var _result = await _simpleRegisterController.registerUser(emailController.text, passwordController.text, _image);
        if(_result['result'] != true) Scaffold.of(context).showSnackBar(new SnackBar(content: new Text("Erro")));
        else {
          if(typeUser == "Cliente"){
            _result = await _simpleRegisterController.registerClient(nameController.text, emailController.text, _selectedCountry, _selectedCity, _selectedState, date, _result['uid'], _result['imageUrl']);
            print(_result);
            if(_result['result'] != true)
              Scaffold.of(context).showSnackBar(new SnackBar(content: new Text("Erro")));
            else
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MainClient()), (Route<dynamic> route) => false);
          } else {
            _result = await _simpleRegisterController.registerWorker(nameController.text, emailController.text, _selectedCountry, _selectedCity, _selectedState, date, _result['uid'], _result['imageUrl']);
            print(_result);
            if(_result['result'] != true)
              Scaffold.of(context).showSnackBar(new SnackBar(content: new Text("Erro")));
            else
              Navigator.push(context, MaterialPageRoute(builder: (context) => WorkerComplement()));
          }
        }
      });
    }
  }

  void _loadCitiesMenu(String country, String state) async {
    if(_dropDownCitiesMenuItems.length>1) _dropDownCitiesMenuItems.removeRange(1, _dropDownCitiesMenuItems.length);

    List<DropdownMenuItem<String>> items = _dropDownCitiesMenuItems;
    if(_dropDownStatesMenuItems[0].value != _selectedState && _dropDownCountriesMenuItems[0].value != _selectedCountry){
      for (String city in await LocationController().getCities(country, state)) {
        items.add(new DropdownMenuItem(value: city, child: new Text(city)));
      }
    }

    setState(() {
      _dropDownCitiesMenuItems = items;
      _selectedCity = _dropDownCitiesMenuItems[0].value;
    });
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
  }

  Future _selectDate() async {
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: new  DateTime(1988),
        firstDate: new DateTime(1968),
        lastDate: new DateTime(2001)
    );
    if(picked != null){
      setState(() => date = picked); birthDayController.text = DateFormat("dd/MM/yyyy").format(date);
    }
  }

  Future<void> _dialogTerms(Function agree) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return Theme(
          data: Theme.of(context).copyWith(dialogBackgroundColor: Colors.white),
          child: AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
            title: Text('Termos de Uso e Privacidade', style: TextStyle(color: Theme.of(context).primaryColorDark, fontSize: 18)),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Ao continuar você concorda com os termos de uso e privacidade disponíveis nesse link.', style: TextStyle(color: Theme.of(context).primaryColorDark, fontSize: 14)),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('cancelar'.toUpperCase(), style: TextStyle(color: Colors.grey)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text('concordo'.toUpperCase(), style: TextStyle(fontWeight: FontWeight.bold)),
                onPressed: (){
                  Navigator.of(context).pop();
                  agree();
                }
              ),
            ],
          ),
        );
      },
    );
  }

  Widget contentLoading(){
    return LoadingController().initLoadingScreen("registrando dados ...".toUpperCase());
  }

  Widget contentSimpleRegister(BuildContext _context) {
    return SingleChildScrollView(scrollDirection: Axis.vertical,child: new Column(children: <Widget>[
      new Stack(children: <Widget>[
        new Container(
          height: 200,
          width: double.infinity,
          child: _image == null ? new Image.asset("assets/graphics/default_user.png", fit: BoxFit.cover) : new Image.file(_image, fit: BoxFit.cover),
        ),
        new Padding(
            padding: EdgeInsets.fromLTRB(0, 180, 0, 0),
            child: new Center(child:
            new RaisedButton(
                elevation: 20,
                padding: EdgeInsets.all(15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
                child: new Text("SELECIONAR IMAGEM", style: TextStyle(color: Theme.of(context).backgroundColor)),
                color: Colors.white,
                onPressed: (){
                  getImage();
                }
            ))
        )
      ]),
      new Container(padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20), child:
      new TextField(
              keyboardType: TextInputType.text,
              controller: nameController,
              decoration: InputDecoration(
                icon: Image.asset("assets/graphics/user_menu.png", width: 20, height: 20),
                labelStyle: new TextStyle(color: Theme.of(context).primaryColor),
                focusedBorder: const UnderlineInputBorder(borderSide: const BorderSide(color: Colors.white, width: 1)),
                labelText: "Nome:",
                hintText: "Ex: Wilton Neto",
                border: UnderlineInputBorder(),
              ),
              style: TextStyle(fontSize: 16),
            ),
          ),
      new Container(padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20), child:
      new TextField(
              keyboardType: TextInputType.emailAddress,
              controller: emailController,
              decoration: InputDecoration(
                icon: Image.asset("assets/graphics/mail.png", width: 20, height: 20),
                labelStyle: new TextStyle(color: Theme.of(context).primaryColor),
                focusedBorder: const UnderlineInputBorder(borderSide: const BorderSide(color: Colors.white, width: 1)),
                labelText: "Email:",
                hintText: "Ex: willrcneto@gmail.com",
                border: UnderlineInputBorder(),
              ),
              style: TextStyle(fontSize: 16),
            ),
          ),
      new Container(padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20), child:
          new TextField(
              keyboardType: TextInputType.text,
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                icon: Image.asset("assets/graphics/padlock.png", width: 20, height: 20),
                labelStyle: new TextStyle(color: Theme.of(context).primaryColor),
                focusedBorder: const UnderlineInputBorder(borderSide: const BorderSide(color: Colors.white, width: 1)),
                labelText: "Senha:",
                border: UnderlineInputBorder(),
              ),
              style: TextStyle(fontSize: 16),
            ),
          ),
      new Container(padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20), child: new TextField(
              keyboardType: TextInputType.text,
              controller: confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                icon: Image.asset("", width: 20, height: 20),
                labelStyle: new TextStyle(color: Theme.of(context).primaryColor),
                focusedBorder: const UnderlineInputBorder(borderSide: const BorderSide(color: Colors.white, width: 1)),
                labelText: "Confirmar senha:",
                border: UnderlineInputBorder(),
              ),
              style: TextStyle(fontSize: 16),
            ),
          ),
      new Container(padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20), child:
      new TextField(
        keyboardType: TextInputType.text,
        controller: birthDayController,
        decoration: InputDecoration(
          icon: Image.asset("assets/graphics/calendar.png", width: 20, height: 20),
          labelStyle: new TextStyle(color: Theme.of(context).primaryColor),
          focusedBorder: const UnderlineInputBorder(borderSide: const BorderSide(color: Colors.white, width: 1)),
          labelText: "Data de nascimento:",
          border: UnderlineInputBorder(),
        ),
        style: TextStyle(fontSize: 16),
        onChanged: (a){
          birthDayController.text = DateFormat("dd/MM/yyyy").format(date);
        },
        onTap: _selectDate,
      ),
          ),
      new Container(padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10), child: new Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new Padding(padding: EdgeInsets.symmetric(vertical: 0, horizontal: 15), child:  Image.asset("assets/graphics/worldwide.png", width: 20, height: 20)),
          new DropdownButton(
            value: _selectedCountry,
            items: _dropDownCountriesMenuItems,
            onChanged: changedCountryDropDownItem,
          )
        ],
      )),
      new Container(padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),child: new Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new Padding(padding: EdgeInsets.symmetric(vertical: 0, horizontal: 15), child: Image.asset("assets/graphics/flag.png", width: 20, height: 20)),
          new DropdownButton(
            value: _selectedState,
            items: _dropDownStatesMenuItems,
            onChanged: changedStateDropDownItem,
          )
        ],
      )),
      new Container(padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),child: new Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new Padding(padding: EdgeInsets.symmetric(vertical: 0, horizontal: 15), child: Image.asset("assets/graphics/building.png", width: 20, height: 20)),
          new DropdownButton(
            value: _selectedCity,
            items: _dropDownCitiesMenuItems,
            onChanged: changedCityDropDownItem,
          )
        ],
      )),
      new Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          width: double.infinity,
          child:
          new RaisedButton(
              padding: EdgeInsets.all(15),
              child: new Text("registrar-se".toUpperCase(), style: TextStyle(color: Theme.of(context).backgroundColor)),
              color: Theme.of(context).primaryColor,
              onPressed:(){ btnRegisterClicked(_context);}
          )
      ),
    ]));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body:  Builder(builder: (_context) =>  _load ? contentLoading() : contentSimpleRegister(_context)
      ));
  }
}

