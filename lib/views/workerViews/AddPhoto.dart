import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:first_app/controllers/LoadingController.dart';
import 'package:first_app/controllers/PhotosController.dart';
import 'dart:io';

class AddPhoto extends StatefulWidget {
  _AddPhoto createState() => _AddPhoto();
}

class _AddPhoto extends State<AddPhoto> {

  TextEditingController _descriptionTxtController;
  PhotosController _photosController;
  LoadingController _loadingController;
  File _image;
  bool _load;

  @override
  void initState() {
    _load = false;
    _loadingController = new LoadingController();
    _descriptionTxtController = new TextEditingController();
    _photosController = new PhotosController();
    super.initState();
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context){
    return new Scaffold(backgroundColor: Theme.of(context).backgroundColor, body: _load ? _loadingController.initLoadingScreen("enviando imagem".toUpperCase()) :
      new SingleChildScrollView(child:
        new Padding(padding: EdgeInsets.only(top: 40, left: 20, right: 10), child:
          new Column(children: <Widget>[
            new Align(alignment: Alignment.centerLeft, child: new Text("Adicionar foto", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 50))),
            new Align(alignment: Alignment.centerLeft, child: new Text("Uma foto fala mais que mil palavras.", style: TextStyle(fontStyle: FontStyle.italic, fontSize: 13))),
            new Padding(padding: EdgeInsets.only(top: 40, bottom: 20), child:
              new GestureDetector(child:
                new Center(child:
                  new ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      child: _image == null ? new Image.asset("assets/graphics/add_image.png", width: MediaQuery.of(context).size.width, height: MediaQuery.of(context).size.width) : Image.file(_image, fit: BoxFit.cover, width: MediaQuery.of(context).size.width, height: MediaQuery.of(context).size.width)
                  )),
                  onTap: getImage,
              )
            ),
            new TextField(
                maxLines: 3,
                keyboardType: TextInputType.text,
                controller: _descriptionTxtController,
                maxLength: 400,
                decoration: InputDecoration(
                  labelStyle: new TextStyle(color: Theme.of(context).primaryColor),
                  focusedBorder: const OutlineInputBorder(borderSide: const BorderSide(color: Colors.white, width: 1)),
                  labelText: "Descrição:",
                  helperText: "Fale um pouco sobre esta foto",
                  border: OutlineInputBorder(),
                ),
                style: TextStyle(fontSize: 16)
            ),
              new Container(padding: EdgeInsets.only(top: 30, bottom: 20),child:
                new RaisedButton(onPressed: () async {
                  if(_image != null){
                    setState(() {_load = true;});
                    bool _complete = await _photosController.addPicture(_descriptionTxtController.text, _image);
                    if(_complete) Navigator.pop(context);
                  }
                }, child: new Text("enviar foto".toUpperCase(), style: TextStyle(fontWeight: FontWeight.bold)), color: Theme.of(context).accentColor, padding: EdgeInsets.all(20))
              , width: double.infinity)
          ])
        )
      )
    );
  }
}