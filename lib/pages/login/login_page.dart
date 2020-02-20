import 'package:flutter/material.dart';

import 'package:prolimpia_mobile/bloc/provider.dart';
import 'package:prolimpia_mobile/widgets/custom_widgets.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          crearFondo(context, 'Sesión de usuario'),
          _loginForm(context)
        ],
      ),
    );
  }

  Widget _loginForm(BuildContext context) {
    final authBloc = Provider.authBloc(context);
    final size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SafeArea(
            child: Container(
              height: 180.0,
            ),
          ),
          Container(
            width: size.width * 0.85,
            margin: EdgeInsets.symmetric(vertical: 30.0),
            padding: EdgeInsets.only(top: 40.0, bottom: 20.0),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5.0),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Colors.black26,
                      blurRadius: 3.0,
                      offset: Offset(0.0, 5.0),
                      spreadRadius: 3.0)
                ]),
            child: Column(
              children: <Widget>[
                Text('Inicia sesión', style: TextStyle(fontSize: 20.0)),
                SizedBox(height: 40.0),
                _crearEmail(authBloc),
                SizedBox(height: 30.0),
                _crearPassword(authBloc),
                SizedBox(height: 30.0),
                _crearBoton(authBloc),
                SizedBox(height: 20.0),
              ],
            ),
          ),
          SizedBox(height: 100.0)
        ],
      ),
    );
  }

  Widget _crearEmail(LoginBloc bloc) {
    return StreamBuilder(
        stream: bloc.emailStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: TextField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                icon: Icon(Icons.alternate_email,
                    color: Theme.of(context).primaryColor),
                hintText: 'ejemplo@correo.com',
                labelText: 'Correo electrónico',
                counterText: snapshot.data,
                errorText: snapshot.error,
              ),
              onChanged: bloc.changeEmail,
            ),
          );
        });
  }

  Widget _crearPassword(LoginBloc bloc) {
    return StreamBuilder(
        stream: bloc.passwordStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                    icon: Icon(Icons.lock_outline,
                        color: Theme.of(context).primaryColor),
                    labelText: 'Contraseña',
                    counterText: snapshot.data,
                    errorText: snapshot.error),
                onChanged: bloc.changePassword),
          );
        });
  }

  Widget _crearBoton(LoginBloc bloc) {
    return StreamBuilder(
        stream: bloc.formValidStream,
        builder: (BuildContext context, AsyncSnapshot formSnapshot) {
          return StreamBuilder(
              stream: bloc.isLoginStream,
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                return !snapshot.hasData
                    ? _button(bloc, formSnapshot)
                    : snapshot.data
                        ? Center(child: CircularProgressIndicator())
                        : _button(bloc, formSnapshot);
              });
        });
  }

  Widget _button(LoginBloc bloc, AsyncSnapshot snapshot) {
    return RaisedButton(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 15.0),
          child: Text('Ingresar'),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        elevation: 10.0,
        color: Theme.of(context).primaryColor,
        textColor: Colors.white,
        onPressed:
            snapshot.hasData ? () async => await _hideAndSeek(bloc) : null);
  }

  _hideAndSeek(LoginBloc bloc) async {
    FocusScope.of(context).requestFocus(FocusNode());
    bloc.logIn();
  }
}
