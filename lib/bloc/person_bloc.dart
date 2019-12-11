import 'dart:async';
import 'package:prolimpia_mobile/bloc/validators.dart';
import 'package:rxdart/rxdart.dart';
import 'package:prolimpia_mobile/providers/person_provider.dart';

class PersonBloc with Validators {
  final _pagosController = BehaviorSubject<Map<String, dynamic>>();
  final _pagoInputController = BehaviorSubject<Map<String, dynamic>>();
  final _cambioController = BehaviorSubject<Map<String, dynamic>>();

  Stream<Map<String, dynamic>> get pagosStream => _pagosController.stream;
  Stream<String> get pagoInputStream =>
      _pagoInputController.stream.transform(validarPago);
  Stream<String> get cambioStream =>
      _cambioController.stream.transform(validarCambio);

  void _setPago(Map<String, dynamic> pago) => _pagosController.add(pago);
  Function(Map<String, dynamic>) get changePagoInput =>
      _pagoInputController.sink.add;
  Function(Map<String, dynamic>) get changeCambio => _cambioController.sink.add;

  Map<String, dynamic> get pagoInput => _pagoInputController.value;
  Map<String, dynamic> get cambio => _cambioController.value;

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

  dispose() {
    _pagosController?.close();

    _pagoInputController?.close();

    _cambioController?.close();
  }
}
