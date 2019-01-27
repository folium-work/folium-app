import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Environment {
  static final Environment environment = new Environment._internal();

  factory Environment() {
    return environment;
  }

  FirebaseAuth getAuth(){
    return FirebaseAuth.instance;
  }

  FirebaseDatabase getDatabase(){
    return FirebaseDatabase.instance;
  }

  FirebaseStorage getStorage(){
    return FirebaseStorage(storageBucket: "gs://keesir-app.appspot.com/");
  }

  Environment._internal();
}