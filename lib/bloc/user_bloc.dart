import 'dart:async';
import 'package:prolimpia_mobile/providers/person_provider.dart';
import 'package:rxdart/rxdart.dart';

import 'package:prolimpia_mobile/providers/user_provider.dart';
import 'package:prolimpia_mobile/bloc/validators.dart';

class LoginBloc with Validators {
  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();
  final _isLoadingController = BehaviorSubject<String>();
  final _isLoginController = BehaviorSubject<bool>();
  final _collectController = BehaviorSubject<Map<String, dynamic>>();
  final _pagosController = BehaviorSubject<Map<String, dynamic>>();

  //Recuperamos los datos del stream
  Stream<String> get emailStream =>
      _emailController.stream.transform(validarEmail);
  Stream<String> get passwordStream =>
      _passwordController.stream.transform(validarPassword);

  Stream<String> get isLoadingStream => _isLoadingController.stream;
  Stream<bool> get isLoginStream => _isLoginController.stream;
  Stream<Map<String, dynamic>> get collectStream => _collectController.stream;
  Stream<Map<String, dynamic>> get pagosStream => _pagosController.stream;

  //Observable combine
  Stream<bool> get formValidStream =>
      Observable.combineLatest2(emailStream, passwordStream, (e, p) => true);

  // Insertar valores al stream
  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;
  void _setIsLoading(String isLoading) => _isLoadingController.add(isLoading);
  void _setIsLogin(bool isLogin) => _isLoginController.add(isLogin);
  void _setCollect(Map<String, dynamic> collect) =>
      _collectController.add(collect);
  void _setPago(Map<String, dynamic> pago) => _pagosController.add(pago);

  // Obtener el ultimo valor
  String get email => _emailController.value;
  String get password => _passwordController.value;

  Future<void> logIn() async {
    try {
      _setIsLogin(true);
      //print("LOGIN TRUE");
      final current = await UserProvider().login(email, password);
      if (current['status'] == 200) {
        //print("LOGIN OK");
        _setIsLoading('OK');
      } else {
        //print("LOGIN UNAUTHORIZED");
        _setIsLoading('UNAUTHORIZED');
        _setIsLogin(false);
      }
    } catch (e) {
      _isLoadingController.addError(e);
      //print("LOGIN ERROR");
      //print('$e');
      _setIsLoading('ERROR');
    } finally {
      _setIsLogin(false);
    }
  }

  Future<void> checkToken() async {
    try {
      _setIsLoading('CHECK');
      final checkExpires = await UserProvider().check();
      //print(' check ${checkExpires['status']}');
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

  Future<void> getCollect() async {
    final data = {'action': ''};
    try {
      data['action'] = 'GET';
      _setCollect(data);
      final collect = await UserProvider().getCollect();
      if (collect['status'] == 200) {
        _setCollect(collect);
      } else {
        data['action'] = 'UNAUTHORIZED';
        _setCollect(data);
      }
    } catch (e) {
      _collectController.addError(e);
      data['action'] = 'ERROR';
      _setCollect(data);
    }
  }

  Future<void> getPago(String id) async {
    final data = {'action': ''};
    try {
      data['action'] = 'GET';
      _setPago(data);
      final payments = await PersonProvider().getOne(id);
      if (payments['status'] == 200) {
        _setPago(payments);
      } else {
        data['action'] = 'UNAUTHORIZED';
        _setPago(data);
      }
    } catch (e) {
      _pagosController.addError(e);
      data['action'] = 'ERROR';
      _setPago(data);
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

    await _collectController.drain();
    _collectController?.close();

    await _pagosController.drain();
    _pagosController?.close();
  }
}
