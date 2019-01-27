import 'package:flutter/material.dart';
import 'package:first_app/views/Loading.dart';

class LoadingController {

  Widget initLoadingScreen(String text){
    return new Loading(text: text);
  }

}