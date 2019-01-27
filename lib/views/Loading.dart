import 'package:flutter/material.dart';

class Loading extends StatelessWidget {

  final String text;
  Loading({Key key, @required this.text}): super(key: key);

  Widget build(BuildContext context) {
    return new Center(child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new SizedBox(
            child: new CircularProgressIndicator(valueColor:  new AlwaysStoppedAnimation<Color>(Colors.white)),
//            child: Image.asset("assets/graphics/loadgif.gif"),
            height: 30.0,
            width: 30.0,
          ),
          new Padding(padding: EdgeInsets.only(top: 20), child: Text(this.text, textAlign: TextAlign.center, style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold)))
        ]
    ));
  }

}