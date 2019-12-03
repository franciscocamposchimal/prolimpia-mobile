import 'dart:async';
import 'package:rxdart/rxdart.dart';

import 'package:prolimpia_mobile/providers/user_provider.dart';
import 'package:prolimpia_mobile/bloc/validators.dart';

class LoginBloc with Validators {
  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();
  final _isLoadingController = BehaviorSubject<String>();
  final _isLoginController = BehaviorSubject<bool>();

  //Recuperamos los datos del stream
  Stream<String> get emailStream =>
      _emailController.stream.transform(validarEmail);
  Stream<String> get passwordStream =>
      _passwordController.stream.transform(validarPassword);

  Stream<String> get isLoadingStream => _isLoadingController.stream;
  Stream<bool> get isLoginStream => _isLoginController.stream;

  //Observable combine
  Stream<bool> get formValidStream =>
      Observable.combineLatest2(emailStream, passwordStream, (e, p) => true);

  // Insertar valores al stream
  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;
  void _setIsLoading(String isLoading) => _isLoadingController.add(isLoading);
  void _setIsLogin(bool isLogin) => _isLoginController.add(isLogin);

  // Obtener el ultimo valor
  String get email => _emailController.value;
  String get password => _passwordController.value;

  Future<void> logIn() async {
    try {
      _setIsLogin(true);
      final current = await UserProvider().login(email, password);
      if (current['status'] == 200) {
        _setIsLoading('OK');
      } else {
        _setIsLoading('UNAUTHORIZED');
        _setIsLogin(false);
      }
    } catch (e) {
      _isLoadingController.addError(e);
      _setIsLoading('ERROR');
    } finally {
      _setIsLogin(false);
    }
  }

  Future<void> checkToken() async {
    try {
      _setIsLoading('CHECK');
      final checkExpires = await UserProvider().check();
      print(' check ${checkExpires['status']}');
      if (checkExpires['status'] == 200) {
        _setIsLoading('OK');
      } else {
        _setIsLoading('UNAUTHORIZED');
      }
    } catch (e) {
      _isLoadingController.addError(e);
      _setIsLoading('ERROR');
    }
  }

  Future<void> logOut() async {
    try {
      _setIsLoading('LOGOUT');
      final killToken = await UserProvider().logout();
      if (killToken['status'] == 200 || killToken['status'] == 500) {
        _setIsLoading('UNAUTHORIZED');
      } else {
        _setIsLoading('OK');
      }
    } catch (e) {
      _isLoadingController.addError(e);
      _setIsLoading('ERROR');
    }
  }

  dispose() async {
    await _emailController.drain();
    _emailController?.close();

    await _passwordController.drain();
    _passwordController?.close();

    await _isLoadingController.drain();
    _isLoadingController?.close();

    await _isLoginController.drain();
    _isLoginController?.close();
  }
}
