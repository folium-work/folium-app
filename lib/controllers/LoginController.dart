import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/environment/Environment.dart';
import 'package:first_app/pojo/User.dart';
import 'package:first_app/pojo/Client.dart';
import 'package:first_app/pojo/Worker.dart';

class LoginController implements Exception{
   FirebaseAuth _auth;
   User currentUser;

   static final LoginController loginController = new LoginController._internal();

   factory LoginController() {
      return loginController;
   }

   LoginController._internal(){
      _auth = Environment().getAuth();
   }

   Future<bool> login(String email, password) async{
      try{
         await _auth.signInWithEmailAndPassword(email: email, password: password);
         return true;
      }catch(e){
         print(e);
         return false;
      }
   }

   void logOut(Function success) async {
      await Environment().getAuth().signOut();
      success();
   }

   void setCurrentUser(User user){
      currentUser = user;
   }

   Future<bool> checkUserLogged() async{
      var user = await Environment().getAuth().currentUser();
      bool exists = user != null;
      return exists;
   }

   Worker getCurrentWorker(){
      return currentUser as Worker;
   }

   Client getCurrentClient(){
      return currentUser as Client;
   }


}