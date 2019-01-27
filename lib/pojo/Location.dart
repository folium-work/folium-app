import 'Snapshot.dart';

class Location {

  String city, state, country, address, latitude, longitude;

  Location(this.city, this.state, this.country, this.address, this.latitude,
      this.longitude);

  Location.fromBD(Snapshot data){
    city = data.getData('city');
    state = data.getData('state');
    country = data.getData('country');
    address = data.getData('address');
  }

  Map<String, dynamic> toJson() =>
      {
        'city' : city,
        'state' : state,
        'country' : country,
        'address' : address,
        'latitude' : latitude,
        'longidute' : longitude,
      };

}