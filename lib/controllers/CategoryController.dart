import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:first_app/pojo/Category.dart';

class CategoryController {

  var jsonResult;

  CategoryController(){
    this.jsonResult = _loadAsset();
  }

  Future<Map> _loadAsset() async {
    var _data = await rootBundle.loadString('assets/data/categories.json');
    var _scores = jsonDecode(_data);
    assert(_scores is Map);
    return _scores;
  }

  Future<List<Category>> getCategories() async {
    Map _json = await jsonResult;
    List _categoriesMap = _json['br'];
    List<Category> _categoriesList = new List();
    for(Map data in _categoriesMap) _categoriesList.add(new Category(data['uid'], data['content']));
    return _categoriesList;
  }

}