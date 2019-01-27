import 'package:first_app/pojo/Location.dart';
import 'package:first_app/pojo/User.dart';
import 'Snapshot.dart';

class Client extends User{
  Map<String, Object> favoriteList;

  Client(String email, String name, String password, String birth, String imageUrl, String uid, Location location) : super(email, name, password, birth, imageUrl, uid, location){
    favoriteList = new Map();
  }

  Client.fromDB(Snapshot data) : super.fromDB(data){
    favoriteList = data.getData('favorite_list');
  }

  @override
  Map<String, dynamic> toJson() =>
      {
        'name': name,
        'email': email,
        'password': password,
        'image_url': imageUrl,
        'uid': uid,
        'location': location.toJson(),
        'favorite_list': favoriteList
      };
}