import 'package:flutter/material.dart';

Widget crearFondo(BuildContext context, String texto) {
  final size = MediaQuery.of(context).size;

  final fondoModaro = Container(
    height: size.height * 0.4,
    width: double.infinity,
    decoration: BoxDecoration(
        gradient: LinearGradient(colors: <Color>[
      Color.fromRGBO(103, 218, 255, 1.0),
      Color.fromRGBO(3, 169, 244, 1.0),
      Color.fromRGBO(0, 122, 193, 1.0)
    ])),
  );

  final circulo = Container(
    width: 100.0,
    height: 100.0,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100.0),
        color: Color.fromRGBO(255, 255, 255, 0.05)),
  );

  return Stack(
    children: <Widget>[
      fondoModaro,
      Positioned(top: 90.0, left: 30.0, child: circulo),
      Positioned(top: -40.0, right: -30.0, child: circulo),
      Positioned(bottom: -50.0, right: -10.0, child: circulo),
      Positioned(bottom: 120.0, right: 20.0, child: circulo),
      Positioned(bottom: -50.0, left: -20.0, child: circulo),
      Container(
        padding: EdgeInsets.only(top: 80.0),
        child: Column(
          children: <Widget>[
            Hero(
                tag: 'hero-tag',
                child: Image.asset(
                  'assets/logo-progreso.png',
                  width: 100.0,
                  height: 100.0,
                )),
            SizedBox(height: 10.0, width: double.infinity),
            Text(texto, style: TextStyle(color: Colors.white, fontSize: 25.0))
          ],
        ),
      )
    ],
  );
}
