import 'Snapshot.dart';

class Occupation {
  String description;
  int area;

  Occupation(this.area, this.description);

  Occupation.fromDB(Snapshot snapshot){
    if(snapshot.getData('area') is String) area = int.fromEnvironment(snapshot.getData('area'));
    else area =  snapshot.getData('area');
    description = snapshot.getData('description');
  }

  Map<String, dynamic> toJson() => {
    'area': area,
    'description': description
  };


}