import 'dart:async';
import 'package:prolimpia_mobile/bloc/validators.dart';
import 'package:rxdart/rxdart.dart';
import 'package:prolimpia_mobile/providers/person_provider.dart';

class PersonBloc with Validators {
  // <<<< CONTROLLERS >>>>
  // input pago
  final _pagoTotalController = BehaviorSubject<Map<String, dynamic>>();
  // API call
  final _pagosController = BehaviorSubject<Map<String, dynamic>>();
  // operacion del total
  final _pagoInputController = BehaviorSubject<Map<String, dynamic>>();
  // input cambio
  final _cambioController = BehaviorSubject<Map<String, dynamic>>();
  // boton de cobrar
  final _enableButtonController = BehaviorSubject<bool>();
  // input subsidio
  final _subsidioController = BehaviorSubject<Map<String, dynamic>>();
  // <<<< ADD DATA >>>>
  // input pago
  Stream<Map<String, dynamic>> get pagoTotalInputStream => _pagoTotalController.stream;
  // API call
  Stream<Map<String, dynamic>> get pagosStream => _pagosController.stream;
  // operacion del total
  Stream<String> get pagoInputStream =>
      _pagoInputController.stream.transform(calcularPago);
  // input cambio
  Stream<String> get cambioStream =>
      _cambioController.stream.transform(validarCambio);
  // boton de cobrar
  Stream<bool> get enableStream => _enableButtonController.stream;
  // input subsidio
  Stream<Map<String, dynamic>> get subsidioInputStream =>
      _subsidioController.stream;
  // API call
  void _setPago(Map<String, dynamic> pago) => _pagosController.add(pago);
 // <<<< CHANGE VALORES >>>>
 // operacion del total
  Function(Map<String, dynamic>) get changePagoInput =>
      _pagoInputController.sink.add;
  // input cambio
  Function(Map<String, dynamic>) get changeCambio => _cambioController.sink.add;
  // boton de cobrar
  void _setEnable(bool enable) => _enableButtonController.add(enable);
  // input subsidio
  Function(Map<String, dynamic>) get changeSubsidio =>
      _subsidioController.sink.add;
  // input pago
  Function(Map<String, dynamic>) get changePagoTotal => _pagoTotalController.sink.add;
  // <<<< GET VALORES >>>>
  // operacion del total
  Map<String, dynamic> get pagoInput => _pagoInputController.value;
  // input cambio
  Map<String, dynamic> get cambio => _cambioController.value;
  // boton de cobrar
  bool get enable => _enableButtonController.value;
  // input subsidio
  Map<String, dynamic> get subsidio => _subsidioController.value;
  // input pago
  Map<String, dynamic> get pagoTotal => _pagoTotalController.value;
  // <<<< FUNCTIONS >>>>
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

  void enableButton() {
    var pago = double.parse(pagoInput['pago']);
    var recibido = double.parse(cambio['recibido']);
    if (pago > 0 && recibido > 0 && recibido >= pago) {
      _setEnable(true);
    } else {
      _setEnable(false);
    }
  }

  dispose() {
    _pagosController?.close();

    _pagoInputController?.close();

    _cambioController?.close();

    _subsidioController?.close();

    _pagoTotalController?.close();
  }
}
