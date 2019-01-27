import 'package:first_app/pojo/PhotoListener.dart';
import 'package:first_app/pojo/Snapshot.dart';
import 'package:first_app/pojo/Photo.dart';
import 'package:first_app/environment/Environment.dart';
import 'dart:io';

class PhotosController {
  List<PhotoListener> _list;

  PhotosController(){
    _list = new List();
  }

  void addListener(PhotoListener listener){
    _list.add(listener);
  }

  Future<void> loadPictures() async{
    List<Photo> _photos = new List();
    String uid = await Environment().getAuth().currentUser().then((user) => user.uid);
    var data = await Environment().getDatabase().reference().child("users").child(uid).child("photos").once();
    Map names = data.value;
    if(names != null){
      names.forEach((key, value) => _photos.add(new Photo.fromDB(new Snapshot(value))));
      _list.forEach( (listener) => listener.action(_photos));
    }
  }

  Future<bool> addPicture(String description, File file) async {
    try{
      String uidUser = await Environment().getAuth().currentUser().then((user) => user.uid);
      String uidPhoto = Environment().getDatabase().reference().push().key;
      String url = await _uploadImage(file, uidUser, uidPhoto);
      bool _complete = await new Snapshot(new Photo(description, url, uidPhoto).toJson()).sendData("users/$uidUser/photos/$uidPhoto");
      return _complete;
    } catch(e){
      return false;
    }
  }

  Future<bool> deletePicture(String uidPhoto) async {
    String uidUser = await Environment().getAuth().currentUser().then((user) => user.uid);
    await Environment().getStorage().ref().child('images').child('user').child(uidUser).child(uidPhoto+".jpg").delete();
    await Environment().getDatabase().reference().child("users/$uidUser/photos/$uidPhoto").remove();
    return true;
  }

  Future<String> _uploadImage(File file, String uidUser, String uidPhoto) async {
    var ref = Environment().getStorage().ref().child('images').child('user').child(uidUser).child(uidPhoto+".jpg");
    var _task = ref.putFile(file);
    var _data = await _task.onComplete;
    return (await _data.ref.getDownloadURL()).toString();
  }
}