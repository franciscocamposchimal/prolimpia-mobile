import 'dart:convert';
import 'package:prolimpia_mobile/models/current_user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferenciasUsuario {

  static final PreferenciasUsuario _instancia = new PreferenciasUsuario._internal();

  factory PreferenciasUsuario() {
    return _instancia;
  }

  PreferenciasUsuario._internal();

  SharedPreferences _prefs;

  initPrefs() async {
    this._prefs = await SharedPreferences.getInstance();
  }

  // GET y SET de la última página
  get user {
    final getUserString = _prefs.getString('user') ?? null;
    //print('PREFS $getUserString');
    if(getUserString == null){
      return null;
    }
    final getUser = CurrentUser.fromJson(json.decode(getUserString));
    return getUser;
  }

  set user( CurrentUser user ) {
    final currentUser = user.toJson();
    _prefs.setString('user', json.encode(currentUser));
  }
  

  // GET y SET de la última página
  get ultimaPagina {
    return _prefs.getString('ultimaPagina') ?? 'login';
  }

  set ultimaPagina( String value ) {
    _prefs.setString('ultimaPagina', value);
  }

}