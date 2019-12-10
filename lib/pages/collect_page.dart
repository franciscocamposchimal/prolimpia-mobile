import 'package:flutter/material.dart';
import 'package:prolimpia_mobile/bloc/provider.dart';
import 'package:prolimpia_mobile/models/person_model.dart';

class CollectPage extends StatelessWidget {
  final Person person;

  CollectPage({Key key, @required this.person}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authBloc = Provider.authBloc(context);
    return Scaffold(
        appBar: _appBar(context),
        body: Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              _topArea(authBloc),
              SizedBox(
                height: 40.0,
                child: Icon(
                  Icons.refresh,
                  size: 35.0,
                  color: Color(0xFF015FFF),
                ),
              )
            ],
          ),
        ));
  }

  Widget _appBar(BuildContext context) {
    return AppBar(
      iconTheme: IconThemeData(
        color: Theme.of(context).primaryColor,
      ),
      backgroundColor: Colors.white,
      elevation: 0.0,
      title: Text(
        'Cobros',
        style: TextStyle(color: Colors.black),
      ),
      centerTitle: true,
    );
  }

  Widget _topArea(LoginBloc bloc) {
    return Card(
      margin: EdgeInsets.all(10.0),
      elevation: 1.0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(50.0))),
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          Color.fromRGBO(103, 218, 255, 1.0),
          Color.fromRGBO(0, 122, 193, 1.0)
        ])),
        padding: EdgeInsets.all(5.0),
        child: Column(
          children: <Widget>[
            SizedBox(height: 10.0),
            Center(
              child: Padding(
                padding: EdgeInsets.all(5.0),
                child: Text(
                  '${person.usrNumcon}',
                  style: TextStyle(color: Colors.white, fontSize: 12.0),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.all(5.0),
                child: Text(
                  '${person.usrNombre}',
                  style: TextStyle(color: Colors.white, fontSize: 20.0),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.all(5.0),
                child: Text(
                  '${person.usrDomici}',
                  style: TextStyle(color: Colors.white, fontSize: 12.0),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Zona: ${person.usrZona}',
                  style: TextStyle(color: Colors.white, fontSize: 20.0),
                ),
                Text(
                  'Total: \$ ${person.usrTotal}',
                  style: TextStyle(color: Colors.white, fontSize: 24.0),
                ),
                Text(
                  'Ruta: ${person.usrRuta}',
                  style: TextStyle(color: Colors.white, fontSize: 20.0),
                )
              ],
            ),
            SizedBox(height: 5.0),
            Center(
              child: Padding(
                padding: EdgeInsets.all(5.0),
                child: Text(
                  'Último pago: ${person.usrMesFac}',
                  style: TextStyle(color: Colors.white, fontSize: 10.0),
                ),
              ),
            ),
            SizedBox(height: 25.0),
            /*StreamBuilder(
              stream: bloc.pagosStream,
              builder: (BuildContext ctx, AsyncSnapshot<Map<String, dynamic>> snapshot) {
                return snapshot.hasData
                ? Text('data')
                : CircularProgressIndicator();
              }
            )*/
          ],
        ),
      ),
    );
  }
}
