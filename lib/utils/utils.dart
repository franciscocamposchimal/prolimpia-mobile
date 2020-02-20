import 'package:flutter/material.dart';

bool isEmail(String email) {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regExp = new RegExp(pattern);
  return (regExp.hasMatch(email)) ? true : false;
}

bool isPass(String pass) {
  //Pattern pattern = '/\s/';
  //RegExp regExp = new RegExp(pattern);
  return ((pass.length > 4) && (!pass.contains(' '))) ? true : false;
}

void mostrarAlerta(BuildContext context, String title, String mensaje, bool dissmisable) {
  showDialog(
      context: context,
      barrierDismissible: dissmisable,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(mensaje),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () => dissmisable ? Navigator.of(context).pop() : (){},
            )
          ],
        );
      });
}
