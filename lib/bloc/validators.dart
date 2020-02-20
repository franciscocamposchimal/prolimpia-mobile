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

  final calcularPago =
      StreamTransformer<Map<String, dynamic>, String>.fromHandlers(
          handleData: (data, sink) {
    //Total, fijo, sacar porcentaje (100 o -100)
    var totalAdeudo = data['totalAdeudo'].isEmpty
        ? 0.0
        : double.parse(data['totalAdeudo']); //Puede ser negativo
    //Lo que voy a abonar (20)
    var pago = data['pago'].isEmpty ? 0.0 : double.parse(data['pago']);
    if (pago > totalAdeudo) {
      print("PAGO MAYOR");
      sink.addError("PAGO MAYOR AL ADEUDO");
    } else {
      //Total, puede variar (100)
      var adeudo = data['adeudo'].isEmpty ? 0.0 : double.parse(data['adeudo']);
      //Descuento (50)
      var subsidio =
          data['subsidio'].isEmpty ? 0.0 : double.parse(data['subsidio']);
      if (subsidio > 50) {
        print("SUBS MAYOR");
        sink.addError("SUBSIDIO MAYOR AL PERMITIDO");
      } else {
        //Porcentaje (descuento/totalAdeudo)(%50 = 50.00)
        var porcentaje = double.parse(
            (((subsidio ?? 0) / 100) * totalAdeudo).toStringAsFixed(2));
        //Total menos el descuento (100.00 - %50(50.00) = 50 )
        var subtotal = adeudo - porcentaje;
        // Total menos el descuento, menos el pago (50 - 20 = 30)
        var total = subtotal - pago;
        print("CALCULAR TOTAL: $total");
        sink.add(total.toStringAsFixed(2));
      }
    }
  });

  final validarCambio =
      StreamTransformer<Map<String, dynamic>, String>.fromHandlers(
          handleData: (cambioPago, sink) {
    var recibiStream = cambioPago['recibido'].isEmpty
        ? 0.0
        : double.parse(cambioPago['recibido']);
    var pagotream =
        cambioPago['pago'].isEmpty ? 0.0 : double.parse(cambioPago['pago']);
    //print('recibi: $recibiStream, pago: $pagotream');
    if (recibiStream > 0.0) {
      if (recibiStream >= pagotream && pagotream != 0.0) {
        sink.add('${recibiStream - pagotream}');
      } else {
        if (pagotream == 0.0) {
          sink.addError('Importe a pagar es 0');
        } else {
          sink.addError('Faltan \$ ${pagotream - recibiStream}');
        }
      }
    } else {
      sink.addError('La cantidad debe ser mayor a 0.');
    }
  });
}
