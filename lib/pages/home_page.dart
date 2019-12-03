import 'package:flutter/material.dart';
import 'package:prolimpia_mobile/bloc/provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authBloc = Provider.authBloc(context);
    return Scaffold(
      appBar: _appBar(authBloc),
      body: Center(
        child: Text('Logged!!..'),
      ),
    );
  }

    Widget _appBar(LoginBloc bloc) {
    return AppBar(
      elevation: 2.0,
      backgroundColor: Colors.deepPurple,
      leading: Text('User'),
      title: Text('PROLIMPIA',
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 30.0)),
      centerTitle: true,
      actions: <Widget>[
        Container(
          margin: EdgeInsets.only(right: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              _getOut(bloc),
            ],
          ),
        )
      ],
    );
  }

    Widget _getOut(LoginBloc bloc) {
    return FlatButton.icon(
      label: Text('Log out',
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 14.0)),
      onPressed: () => bloc.logOut(),
      icon: Icon(Icons.power_settings_new, color: Colors.white),
    );
  }

}
