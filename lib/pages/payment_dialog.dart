import 'package:after_init/after_init.dart';
import 'package:flutter/material.dart';

import 'package:prolimpia_mobile/bloc/provider.dart';
import 'package:prolimpia_mobile/models/payments_model.dart';

class PaymenDialog extends StatefulWidget {
  final String usrNumCon;

  PaymenDialog({Key key, @required this.usrNumCon}) : super(key: key);

  @override
  _PaymenDialogState createState() => _PaymenDialogState();
}

class _PaymenDialogState extends State<PaymenDialog>
    with AfterInitMixin<PaymenDialog> {
  int _valueList;
  bool _rePrint = false;
  Payment _payToPrint;
  @override
  void didInitState() {
    Provider.personsBloc(context).getPago(widget.usrNumCon).then((value) {
      print('get payment complete');
    }, onError: (error) {
      print('get payment error $error');
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final personBloc = Provider.personsBloc(context);

    return AlertDialog(
      title: Text('Historial de pagos'),
      contentPadding: EdgeInsets.all(0.0),
      content: Container(
          width: double.maxFinite,
          padding:
              EdgeInsets.only(top: 20.0, bottom: 20.0, left: 5.0, right: 5.0),
          child: StreamBuilder(
              stream: personBloc.pagosStream,
              builder: (BuildContext ctx,
                  AsyncSnapshot<Map<String, dynamic>> snapshot) {
                List<Payment> listPagos = snapshot.data['body'];
                return snapshot.hasData && snapshot.data['action'] == 'SUCCESS'
                    ? _listCards(listPagos)
                    : Container(
                        width: 80.0,
                        height: 80.0,
                        child: Center(child: CircularProgressIndicator()),
                      );
              })),
      actions: <Widget>[
        FlatButton.icon(
          icon: Icon(Icons.cancel, color: Colors.red),
          label: Text(
            'Cancelar',
            style: TextStyle(color: Colors.red),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        FlatButton.icon(
          icon: Icon(Icons.print, color: _rePrint ? Colors.blue : Colors.grey),
          label: Text(
            'Re-imprimir',
            style: TextStyle(color: _rePrint ? Colors.blue : Colors.grey),
          ),
          onPressed: _rePrint
              ? () {
                  print('PAY: ${_payToPrint.saldoant}');
                }
              : null,
        ),
      ],
    );
  }

  Widget _listCards(List<Payment> pagos) {
    return pagos.length > 0
        ? ListView.builder(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemCount: pagos.length,
            itemBuilder: (context, index) {
              return Card(
                elevation: 5.0,
                child: RadioListTile(
                    /*leading: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 15.0,
                        ),
                        Icon(
                          Icons.check,
                          color: Colors.green,
                        )
                      ],
                    ),*/
                    value: index,
                    groupValue: _valueList,
                    onChanged: (ind) {
                      debugPrint('VAL= $ind');
                      setState(() {
                        _valueList = ind;
                        _payToPrint = pagos[index];
                        if (_rePrint == false) _rePrint = true;
                      });
                    },
                    title: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Saldo ant: \$ ${pagos[index].saldoant}',
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(
                              width: 5.0,
                            ),
                            Text(
                              'Saldo post: \$ ${pagos[index].saldopost}',
                              overflow: TextOverflow.ellipsis,
                            ),
                            /*Text(
                            '${pagos[index].tipopago}',
                            overflow: TextOverflow.ellipsis,
                          ),*/
                          ],
                        ),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'F. pago: ${pagos[index].fpago}',
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'Recibido: \$ ${pagos[index].efectivo}',
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'Cambio: \$ ${pagos[index].cambio}',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    /*trailing: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 20.0,
                        ),
                        Text('${pagos[index].referencia}'),
                      ],
                    ),*/
                    isThreeLine: true),
              );
            },
          )
        : Center(child: Text('Sin pagos anteriores...'));
  }
}
