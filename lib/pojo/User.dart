import 'package:first_app/pojo/Location.dart';
import 'Snapshot.dart';

abstract class User {
  String email, name, password, birth, imageUrl, uid;
  Location location;

  User(this.email, this.name, this.password, this.birth,
      this.imageUrl, this.uid, this.location);

  User.fromDB(Snapshot data){
    email = data.getData('email');
    name = data.getData('name');
    password = data.getData('password');
    birth = data.getData('birth');
    imageUrl = data.getData('image_url');
    uid = data.getData('uid');
    location = Location.fromBD(new Snapshot(data.getData('location')));
  }

  Map<String, dynamic> toJson() =>
      {
        'name': name,
        'email': email,
        'password': password,
        'image_url': imageUrl,
        'uid': uid,
        'location': location.toJson()
      };

}