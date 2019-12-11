import 'package:flutter/material.dart';

import 'package:prolimpia_mobile/bloc/user_bloc.dart';
export 'package:prolimpia_mobile/bloc/user_bloc.dart';

import 'package:prolimpia_mobile/bloc/person_bloc.dart';
export 'package:prolimpia_mobile/bloc/person_bloc.dart';

class Provider extends InheritedWidget {
  final loginBloc = new LoginBloc();
  final personBloc = new PersonBloc();

  static Provider _instancia;

  factory Provider({Key key, Widget child}) {
    if (_instancia == null) {
      _instancia = new Provider._internal(key: key, child: child);
    }

    return _instancia;
  }
  Provider._internal({Key key, Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static LoginBloc authBloc(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(Provider) as Provider)
        .loginBloc;
  }

  static PersonBloc personsBloc(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(Provider) as Provider)
        .personBloc;
  }
}
