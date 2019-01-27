import 'package:first_app/environment/Environment.dart';

class Snapshot {
  final Map<dynamic, dynamic> _data;

  Snapshot(this._data);

  dynamic getData(String param){
    return _data[param];
  }

  Future<bool> sendData(String path) async{
    try{
      await Environment().getDatabase().reference().child(path).set(_data);
      return true;
    }catch(e){
      print(e);
      return false;
    }
  }

}