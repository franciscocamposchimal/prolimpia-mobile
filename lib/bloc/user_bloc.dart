import 'dart:async';
import 'package:rxdart/rxdart.dart';

import 'package:prolimpia_mobile/providers/user_provider.dart';
import 'package:prolimpia_mobile/bloc/validators.dart';

class LoginBloc with Validators {
  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();
  final _isLoadingController = BehaviorSubject<bool>();
  final _isLoginController = BehaviorSubject<bool>();

  //Recuperamos los datos del stream
  Stream<String> get emailStream =>
      _emailController.stream.transform(validarEmail);
  Stream<String> get passwordStream =>
      _passwordController.stream.transform(validarPassword);

  Stream<bool> get isLoadingStream => _isLoadingController.stream;
  Stream<bool> get isLoginStream => _isLoginController.stream;

  //Observable combine
  Stream<bool> get formValidStream =>
      Observable.combineLatest2(emailStream, passwordStream, (e, p) => true);

  // Insertar valores al stream
  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;
  void _setIsLoading(bool isLoading) => _isLoadingController.add(isLoading);
  void _setIsLogin(bool isLogin) => _isLoginController.add(isLogin);

  // Obtener el ultimo valor
  String get email => _emailController.value;
  String get password => _passwordController.value;

  Future<void> logIn() async {
    try {
      _setIsLogin(true);
      final current = await UserProvider().login(email, password);
      if (current['status'] == 200) {
        _setIsLoading(true);
      } else {
        _setIsLoading(false);
        _setIsLogin(false);
      }
    } catch (e) {
      _isLoadingController.addError(e);
      _setIsLoading(false);
    } finally {
      _setIsLogin(false);
    }
  }

  Future<void> checkToken() async {
    try {
      print('BLOC TRY');
      final checkExpires = await UserProvider().check();
      print(' check ${checkExpires['status']}');
      if (checkExpires['status'] == 200) {
        _setIsLoading(true);
      } else {
        _setIsLoading(false);
      }
    } catch (e) {
      _isLoadingController.addError(e);
      _setIsLoading(false);
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
