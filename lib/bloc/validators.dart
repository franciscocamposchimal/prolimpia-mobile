import 'dart:async';
import 'package:prolimpia_mobile/utils/utils.dart' as utils;

class Validators {
  final validarEmail =
      StreamTransformer<String, String>.fromHandlers(handleData: (email, sink) {
    if (utils.isEmail(email)) {
      sink.add(email);
    } else {
      sink.addError('Email no es correcto');
    }
  });

  final validarPassword = StreamTransformer<String, String>.fromHandlers(
      handleData: (password, sink) {
    if (utils.isPass(password)) {
      sink.add(password);
    } else {
      sink.addError('Más de 6 caracteres por favor');
    }
  });

  final matchPassword =
      StreamTransformer<Map<String, String>, String>.fromHandlers(
          handleData: (data, sink) {
    print(data);
    if (data['password'] == data['passwordVerification']) {
      sink.add(data['passwordVerification']);
    } else {
      sink.addError('Las contraseñas no coinciden');
    }
  });
}
