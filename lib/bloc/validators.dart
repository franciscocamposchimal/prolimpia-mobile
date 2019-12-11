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

  final validarPago =
      StreamTransformer<Map<String, dynamic>, String>.fromHandlers(
          handleData: (restaPago, sink) {
    var pagoStream = restaPago['pago'].isEmpty || restaPago['pago'] == '-'
        ? 0
        : int.parse(restaPago['pago']);
    var adeudoStream =
        restaPago['adeudo'].isEmpty ? 0 : int.parse(restaPago['adeudo']);
    if (pagoStream > 0) {
      if ((adeudoStream == 0 || adeudoStream < 0) && pagoStream > 0) {
        sink.add('${adeudoStream - pagoStream}');
      }
      if (pagoStream > adeudoStream && adeudoStream > 0) {
        sink.addError('No puede ser mayor a $adeudoStream');
      }

      if (pagoStream <= adeudoStream) {
        sink.add('${adeudoStream - pagoStream}');
      }
    } else {
      sink.addError('La cantidad debe ser mayor a 0.');
    }
  });

  final validarCambio =
      StreamTransformer<Map<String, dynamic>, String>.fromHandlers(
          handleData: (cambioPago, sink) {
    var recibiStream =
        cambioPago['recibido'].isEmpty || cambioPago['recibido'] == '-'
            ? 0
            : int.parse(cambioPago['recibido']);
    var pagotream =
        cambioPago['pago'].isEmpty ? 0 : int.parse(cambioPago['pago']);
    //print('recibi: $recibiStream, pago: $pagotream');
    if (recibiStream > 0) {
      if (recibiStream >= pagotream && pagotream != 0 ) {
        sink.add('${recibiStream - pagotream}');
      } else {
        if(pagotream == 0){
          sink.addError('Importe a pagar es 0');
        }else{
        sink.addError('Faltan \$ ${pagotream - recibiStream}');
        }
      }
    } else {
      sink.addError('La cantidad debe ser mayor a 0.');
    }
  });
}
