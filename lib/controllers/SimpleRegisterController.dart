import 'package:first_app/environment/Environment.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:first_app/pojo/Snapshot.dart';
import 'package:first_app/pojo/User.dart';
import 'package:first_app/pojo/Client.dart';
import 'package:first_app/pojo/Worker.dart';
import 'package:first_app/pojo/Location.dart';
import 'LoginController.dart';
import 'dart:io';

class SimpleRegisterController{

  Environment _environment;

  SimpleRegisterController(){
    _environment = Environment();
  }

  Future<Map<String, dynamic>> registerUser(String email, String password, File profilePicture) async{
    try{
      String uid = await _createUid(email, password);
      String imageUrl;
      if(profilePicture != null) imageUrl = await _uploadProfilePicture(profilePicture, uid);
      else imageUrl = "";
      return {'result':true,'uid':uid,'imageUrl': imageUrl};
    } catch(e){
      return {'result':false,'uid':"",'imageUrl': ""};
    }
  }

  Future<Map<String, dynamic>> registerClient(String name, String email, String country, String city, String state, DateTime birth, String uid, String imageUrl) async {
    try{
      Client client = new Client(email, name, "", birth.toString(), imageUrl, uid, new Location(city, state, country, "", "", ""));
      await _sendData(client);
      LoginController().setCurrentUser(client);
      return {'result': true, 'message': "success"};
    } catch(e){
      return {'result': false, 'message': e};
    }
  }

  Future<Map<String, dynamic>> registerWorker(String name, String email, String country, String city, String state, DateTime birth, String uid, String imageUrl) async {
    try{
      Worker worker = new Worker(email, name, "", birth.toString(), imageUrl, uid, new Location(city, state, country, "", "", ""), null, null, null);
      LoginController().setCurrentUser(worker);
      return {'result': true, 'message': "success"};
    } catch(e){
      return {'result': false, 'message': e};
    }
  }

  Future<String> _createUid(String email, password) async {
    FirebaseUser fbUser = await _environment.getAuth().createUserWithEmailAndPassword(email: email, password: password);
    return fbUser.uid;
  }

  Future<String> _uploadProfilePicture(File file, String uid) async {
      StorageReference ref = _environment.getStorage().ref().child('images').child('user').child(uid).child(uid+"profile_image.jpg");
      StorageUploadTask _task = ref.putFile(file);
      StorageTaskSnapshot _data = await _task.onComplete;
      return (await _data.ref.getDownloadURL()).toString();
  }

  Future<bool> _sendData(User user) async {
    return await new Snapshot(user.toJson()).sendData("users/${user.uid}/data");
  }
}