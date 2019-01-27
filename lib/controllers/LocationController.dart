import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class LocationController {

  var jsonResult;

  LocationController(){
    this.jsonResult = _loadAsset();
  }

  Future<Map> _loadAsset() async {
    var data = await rootBundle.loadString('assets/data/locations.json');
    var scores = jsonDecode(data);
    assert(scores is Map);
    return scores;
  }

  Future<List<String>> getCountries() async{
    Map data = await jsonResult;
    List<String> countries = new List();
    for(String key in data.keys) countries.add(key);
    return countries;
  }

  Future<List<String>> getStates(String country) async{
    Map data = await jsonResult;
    Map statesMap = data[country][0];
    List<String> states = new List();
    for(String key in statesMap.keys) states.add(key);
    return states;
  }

  Future<List<String>> getCities(String country, String state) async{
    Map data = await jsonResult;
    List<String> cities = new List();
    for(String city in data[country][0][state]) cities.add(city);
    return cities;
  }

}