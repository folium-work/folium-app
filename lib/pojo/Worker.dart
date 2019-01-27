import 'package:first_app/pojo/Location.dart';
import 'package:first_app/pojo/User.dart';
import 'package:first_app/pojo/Attendance.dart';
import 'package:first_app/pojo/Social.dart';
import 'package:first_app/pojo/Occupation.dart';
import 'Snapshot.dart';

class Worker extends User {

  Attendance attendance;
  Social social;
  Occupation occupation;

  Worker(String email, String name, String password, String birth, String imageUrl, String uid, Location location, this.attendance, this.social, this.occupation) : super(email, name, password, birth, imageUrl, uid, location);

  Worker.fromDB(Snapshot data) : super.fromDB(data){
    attendance = new Attendance.fromDB(new Snapshot(data.getData('attendance')));
    social = new Social.fromDB(new Snapshot(data.getData('social')));
    occupation = new Occupation.fromDB(new Snapshot(data.getData('occupation')));
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
        'attendance':attendance.toJson(),
        'social': social.toJson(),
        'occupation': occupation.toJson()
      };
}