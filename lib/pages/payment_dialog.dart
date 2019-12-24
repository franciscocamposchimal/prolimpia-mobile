import 'package:flutter/material.dart';
import 'package:prolimpia_mobile/bloc/provider.dart';

class PaymenDialog extends StatefulWidget {
  final String total;

  PaymenDialog({Key key, @required this.total}) : super(key: key);

  @override
  _PaymenDialogState createState() => _PaymenDialogState();
}

class _PaymenDialogState extends State<PaymenDialog> {
  @override
  Widget build(BuildContext context) {
    final personBloc = Provider.personsBloc(context);
    personBloc.changePagoInput({'pago': '0', 'adeudo': '${widget.total}'});
    personBloc.changeCambio({'recibido': '0', 'pago': '0'});
    personBloc.enableButton();
    return AlertDialog(
      title: Text('Total a pagar: \$ ${widget.total}'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(8.0),
              child: StreamBuilder(
                  stream: personBloc.pagoInputStream,
                  builder: (context, snapshot) {
                    return TextField(
                      autofocus: true,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.attach_money),
                          labelText: 'Pago',
                          hintText: '0.00',
                          errorText: snapshot.error),
                      onChanged: (val) {
                        print(val);
                        personBloc.changePagoInput(
                            {'pago': val, 'adeudo': '${widget.total}'});

                        personBloc.changeCambio({
                          'recibido': personBloc.cambio['recibido'],
                          'pago': val
                        });

                        personBloc.enableButton();
                      },
                    );
                  }),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: StreamBuilder(
                  stream: personBloc.cambioStream,
                  builder: (context, snapshot) {
                    return TextField(
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.attach_money),
                          labelText: 'Recibí',
                          hintText: '0.00',
                          errorText: snapshot.error),
                      onChanged: (val) {
                        personBloc.changeCambio({
                          'recibido': val,
                          'pago': '${personBloc.pagoInput['pago']}'
                        });

                        personBloc.enableButton();
                      },
                    );
                  }),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: StreamBuilder(
                  stream: personBloc.cambioStream,
                  builder: (context, snapshot) {
                    return TextField(
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.perce),
                          labelText: 'Subsidio',
                          hintText: '0.00',
                          errorText: snapshot.error),
                      onChanged: (val) {
                        print(val);
                      },
                    );
                  }),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  StreamBuilder(
                      stream: personBloc.cambioStream,
                      builder: (context, snapshot) {
                        //print(snapshot.data);
                        return Text(
                            'Cambio Total: \$ ${snapshot.hasData ? snapshot.data : 0}');
                      }),
                ],
              ),
            ),
            SizedBox(height: 10.0),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  StreamBuilder(
                      stream: personBloc.pagoInputStream,
                      builder: (context, snapshot) {
                        return Text(
                            'Adeudo final: \$ ${snapshot.hasData ? snapshot.data : widget.total}');
                      })
                ],
              ),
            )
          ],
        ),
      ),
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
        StreamBuilder(
            stream: personBloc.enableStream,
            builder: (context, snapshot) {
              //print('SNAP');
              //print(snapshot.data);
              return FlatButton.icon(
                icon: Icon(Icons.payment),
                label: Text('Aceptar'),
                onPressed: snapshot.data ? () {} : null,
              );
            })
      ],
    );
  }
}
