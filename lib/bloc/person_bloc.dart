import 'dart:async';
import 'package:prolimpia_mobile/bloc/validators.dart';
import 'package:rxdart/rxdart.dart';
import 'package:prolimpia_mobile/providers/person_provider.dart';

class PersonBloc with Validators {
  final _pagoTotalController = BehaviorSubject<String>();
  final _pagosController = BehaviorSubject<Map<String, dynamic>>();
  final _pagoInputController = BehaviorSubject<Map<String, dynamic>>();
  final _cambioController = BehaviorSubject<Map<String, dynamic>>();
  final _enableButtonController = BehaviorSubject<bool>();
  final _subsidioController = BehaviorSubject<Map<String, dynamic>>();

  Stream<String> get pagoTotalInputStream => _pagoTotalController.stream;
  Stream<Map<String, dynamic>> get pagosStream => _pagosController.stream;
  Stream<String> get pagoInputStream =>
      _pagoInputController.stream.transform(validarPago);
  Stream<String> get cambioStream =>
      _cambioController.stream.transform(validarCambio);
  Stream<bool> get enableStream => _enableButtonController.stream;
  Stream<Map<String, dynamic>> get subsidioInputStream =>
      _subsidioController.stream;

  void _setPago(Map<String, dynamic> pago) => _pagosController.add(pago);
  Function(Map<String, dynamic>) get changePagoInput =>
      _pagoInputController.sink.add;
  Function(Map<String, dynamic>) get changeCambio => _cambioController.sink.add;
  void _setEnable(bool enable) => _enableButtonController.add(enable);
  Function(Map<String, dynamic>) get changeSubsidio =>
      _subsidioController.sink.add;
  Function(String) get changePagoTotal => _pagoTotalController.sink.add;
  void _setPagoTotal(String pagoTotal) => _pagoTotalController.add(pagoTotal);

  Map<String, dynamic> get pagoInput => _pagoInputController.value;
  Map<String, dynamic> get cambio => _cambioController.value;
  bool get enable => _enableButtonController.value;
  Map<String, dynamic> get subsidio => _subsidioController.value;
  String get pagoTotal => _pagoTotalController.value;

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

  void subsidioBloc(String totalToPay) {
    //print('SUBSIDIO DESPUES ${subsidio['subs'] ?? 0}');
    if (subsidio['subs'] == 0 || subsidio['subs'] > 100) {
      _setPagoTotal(totalToPay);
    } else {
      var totalAdeudo = double.parse(pagoTotal);
      var subtotal = double.parse(
          (((subsidio['subs'] ?? 0) / 100) * totalAdeudo).toStringAsFixed(2));
      var total = totalAdeudo - subtotal;
      //print('pago $totalAdeudo');
      //print('subsidio ${subsidio['subs']}');
      //print('Subs $subtotal');
      //print('Total $total');
      _setPagoTotal(total.toStringAsFixed(2));
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
