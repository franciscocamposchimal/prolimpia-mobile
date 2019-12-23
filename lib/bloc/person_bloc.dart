import 'dart:async';
import 'package:prolimpia_mobile/bloc/validators.dart';
import 'package:rxdart/rxdart.dart';
import 'package:prolimpia_mobile/providers/person_provider.dart';

class PersonBloc with Validators {
  final _pagosController = BehaviorSubject<Map<String, dynamic>>();
  final _pagoInputController = BehaviorSubject<Map<String, dynamic>>();
  final _cambioController = BehaviorSubject<Map<String, dynamic>>();
  final _enableButtonController = BehaviorSubject<bool>();
  //final _subsidioController = BehaviorSubject<Map<String, dynamic>>();

  Stream<Map<String, dynamic>> get pagosStream => _pagosController.stream;
  Stream<String> get pagoInputStream =>
      _pagoInputController.stream.transform(validarPago);
  Stream<String> get cambioStream =>
      _cambioController.stream.transform(validarCambio);
  Stream<bool> get enableStream => _enableButtonController.stream;

  void _setPago(Map<String, dynamic> pago) => _pagosController.add(pago);
  Function(Map<String, dynamic>) get changePagoInput =>
      _pagoInputController.sink.add;
  Function(Map<String, dynamic>) get changeCambio => _cambioController.sink.add;
  void _setEnable(bool enable) => _enableButtonController.add(enable);

  Map<String, dynamic> get pagoInput => _pagoInputController.value;
  Map<String, dynamic> get cambio => _cambioController.value;
  bool get enable => _enableButtonController.value;

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
    var pago = int.parse(pagoInput['pago']);
    var recibido = int.parse(cambio['recibido']);
    //print(pagoInput);
    //print(cambio);
    if (pago > 0 && recibido > 0 && recibido >= pago) {
      _setEnable(true);
      //print(pagoInput);
      //print(cambio);
    } else {
      _setEnable(false);
    }
  }

  void subsidio(int subs){
    var pago = int.parse(pagoInput['pago']);
    var subtotal = double.parse((((subs?? 0) / 100) * pago).toStringAsFixed(2));
    var total = pago - subtotal;
    print('Subs $subtotal');
    print('Total $total');
  }

  dispose() {
    _pagosController?.close();

    _pagoInputController?.close();

    _cambioController?.close();
  }
}
