import 'Snapshot.dart';

class Attendance {
  bool cash, check, creditCard, homeCare, freeBudget;

  Attendance(this.cash, this.check, this.creditCard, this.homeCare,
      this.freeBudget);

  Attendance.fromDB(Snapshot data){
    cash = data.getData('cash');
    check = data.getData('check');
    creditCard = data.getData('credit_card');
    homeCare = data.getData('home_care');
    freeBudget = data.getData('free_budget');
  }

  Map<String, dynamic> toJson() =>
      {
        'cash': cash,
        'check': check,
        'credit_card': creditCard,
        'home_care': homeCare,
        'free_budget': freeBudget
      };
}