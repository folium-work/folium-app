import 'package:first_app/environment/Environment.dart';
import 'package:first_app/controllers/LoginController.dart';
import 'package:first_app/pojo/Client.dart';
import 'package:first_app/pojo/Worker.dart';
import 'package:first_app/pojo/Snapshot.dart';

class UserChoiceController {
  var reference;

  UserChoiceController(){
    reference = Environment().getDatabase().reference().child('users');
  }

  void workerChoice(Function success) async {
    var user = await Environment().getAuth().currentUser();
    var data = await Environment().getDatabase().reference().child("users").child(user.uid).child("data").once();

    try{
      Worker worker = Worker.fromDB(new Snapshot(data.value));
      LoginController().setCurrentUser(worker);
      success(true);
    }catch(e){
      success(false);
    }
  }

  void clientChoice(Function success) async {
    var user = await Environment().getAuth().currentUser();
    var data = await Environment().getDatabase().reference().child("users").child(user.uid).child("data").once();

    Client client = Client.fromDB(new Snapshot(data.value));
    LoginController().setCurrentUser(client);
    success();
  }

}