import 'package:first_app/pojo/Snapshot.dart';
import 'package:first_app/pojo/Category.dart';
import 'package:first_app/pojo/Attendance.dart';
import 'package:first_app/pojo/Social.dart';
import 'package:first_app/pojo/Occupation.dart';
import 'package:first_app/pojo/Worker.dart';
import 'package:first_app/controllers/LoginController.dart';

class WorkerComplementController {

  Worker _worker;

  WorkerComplementController(){
    _worker = LoginController().getCurrentWorker();
  }

  Future<bool> registerCompleteWorker(Category category, String address, String description, bool creditCard, bool check, bool cash, bool homeCare, bool freeBudget, String whatsApp, String instagram, String facebook) async {
      _worker.location.address = address;
      _worker.occupation = new Occupation(category.uid, description);
      _worker.attendance = new Attendance(cash, check, creditCard, homeCare, freeBudget);
      _worker.social = new Social(facebook, instagram, whatsApp, "");
      bool _data = await new Snapshot(_worker.toJson()).sendData("users/${_worker.uid}/data");
      bool _reference = await new Snapshot({'time':DateTime.now().toString()}).sendData("workers/${_worker.location.country}/${_worker.location.state}/${_worker.location.city}/${_worker.occupation.area}/${_worker.uid}");
      return _data && _reference;
  }

}