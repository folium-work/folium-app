import 'package:flutter/material.dart';
import 'package:first_app/pojo/Photo.dart';
import 'package:first_app/pojo/PhotoListener.dart';
import 'package:first_app/controllers/PhotosController.dart';
import 'package:flutter/cupertino.dart';
import 'package:first_app/controllers/LoadingController.dart';
import 'package:transparent_image/transparent_image.dart';
import 'AddPhoto.dart';

class PhotosWorker extends StatefulWidget {
  _PhotosWorker createState() => _PhotosWorker();
}

class _PhotosWorker extends State<PhotosWorker> implements PhotoListener {

  List<Photo> _list;
  bool _load;
  PhotosController _photosController;
  LoadingController _loadingController;

  @override
  initState(){
    _list = [null];
    _load = false;
    _loadingController = new LoadingController();
    _photosController = new PhotosController();
    _photosController.addListener(this);
    _photosController.loadPictures();
    super.initState();
  }

  void _updatePhotosList(){
    _list.clear();
    _list.add(null);
    _photosController.loadPictures();
    setState(() => _load = false);
  }

  Widget _buildImage(Photo photo){
    double _size = MediaQuery.of(context).size.width - 40;
    return new GestureDetector(child:
      new Padding(padding: EdgeInsets.only(right: 20), child:
        new ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            child: photo == null ? Image.asset("assets/graphics/add_image.png", height: _size, width: _size, fit: BoxFit.cover) : new FadeInImage.memoryNetwork(height: _size, width: _size, fit: BoxFit.cover, image:photo.imageUrl, placeholder: kTransparentImage)
        )
      ), onTap: (){
        if(photo!=null) _photoDialog(photo);
        else Navigator.push(context, CupertinoPageRoute(builder: (context) => AddPhoto())).then((_) => _updatePhotosList());
      },
    );
  }

  Future<void> _photoDialog(Photo photo){
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Theme(
          data: Theme.of(context).copyWith(dialogBackgroundColor: Colors.white),
          child: AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
            title: new Text("Descrição:", style: TextStyle(color: Colors.black, fontSize: 18)),
            content: new Text(photo.description, style: TextStyle(color: Theme.of(context).primaryColorDark, fontSize: 14)),
            actions: <Widget>[
              FlatButton(onPressed: () async {
                Navigator.pop(context);
                setState(() => _load = true);
                await _photosController.deletePicture(photo.uidImage);
                _updatePhotosList();
              }, child: new Text("EXCLUIR", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold))),
              FlatButton(onPressed: () => Navigator.pop(context), child: new Text("cancelar".toUpperCase(), style: TextStyle(color: Colors.grey, fontSize: 12)))
            ],
          ),
        );
      },
    );
  }

  Widget build(BuildContext context){
    return new Scaffold(backgroundColor: Theme.of(context).backgroundColor, body: _load ? _loadingController.initLoadingScreen("excluindo foto".toUpperCase()) :
      new Padding(padding: EdgeInsets.only(top: 40, left: 20, right: 10), child:
        new Column(children: <Widget>[
          new Align(alignment: Alignment.centerLeft, child: new Text("Minhas\nfotos", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 50))),
          new Align(alignment: Alignment.centerLeft, child: new Text("O registro de fotos dos seu trabalhos são importantes para dar confiança à possíveis clientes.", style: TextStyle(fontStyle: FontStyle.italic, fontSize: 13))),
          new Expanded(child:
            new Center(
              child: Container(
                child: new Container(height: MediaQuery.of(context).size.width - 40, child: new ListView.builder(scrollDirection: Axis.horizontal,itemCount: _list.length,itemBuilder: (context, position) => _buildImage(_list[position])))
              ),
            )
          )
        ])
      )
    );
  }

  @override
  void action(List<Photo> list) {
    _list.clear();
    _list.add(null);
    setState(() {
      _list = new List.from(_list)..addAll(list);
    });
  }
}