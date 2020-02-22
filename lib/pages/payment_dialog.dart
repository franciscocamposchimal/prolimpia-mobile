import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:prolimpia_mobile/bloc/provider.dart';
import 'package:prolimpia_mobile/utils/custom_icon_icons.dart';

class PaymenDialog extends StatefulWidget {
  final String total;

  PaymenDialog({Key key, @required this.total}) : super(key: key);

  @override
  _PaymenDialogState createState() => _PaymenDialogState();
}

class _PaymenDialogState extends State<PaymenDialog> {
  
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final personBloc = Provider.personsBloc(context);
    personBloc.changeCambio({'recibido': '0', 'pago': '0'});
    personBloc.changePagoTotal({'pago': '0.0'});
    personBloc.changeSubsidio({'subsidio': '0.0'});
    personBloc.changePagoInput({
      'totalAdeudo': '${widget.total}',
      'pago': '0.0',
      'adeudo': '${widget.total}',
      'subsidio': '0.0',
    });

    return AlertDialog(
      title: Text('Total a pagar: \$ ${widget.total ?? 0.00}'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.all(5.0),
                child: TextField(
                  textAlign: TextAlign.center,
                  inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                  keyboardType: TextInputType.numberWithOptions(
                      decimal: true, signed: false),
                  decoration: InputDecoration(
                      prefixIcon: Icon(CustomIcon.percent),
                      labelText: 'Subsidio',
                      hintText: '0'),
                  onChanged: (val) {
                    final valueChange = val.isNotEmpty ? val : "0.0";
                    personBloc.changeSubsidio({'subsidio': valueChange});
                    personBloc.changePagoInput({
                      'totalAdeudo': '${widget.total}',
                      'pago': personBloc.pagoTotal['pago'],
                      'adeudo': '${widget.total}',
                      'subsidio': personBloc.subsidio['subsidio'],
                    });
                    personBloc.enableButton();
                  },
                )),
            Padding(
                padding: const EdgeInsets.all(5.0),
                child: TextField(
                  textAlign: TextAlign.center,
                  autofocus: true,
                  inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                  keyboardType: TextInputType.numberWithOptions(
                      decimal: true, signed: false),
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.attach_money),
                      labelText: 'Pago',
                      hintText: '0.00'),
                  onChanged: (val) {
                    final valueChange = val.isNotEmpty ? val : "0.0";
                    personBloc.changePagoTotal({'pago': valueChange});

                    personBloc.changePagoInput({
                      'totalAdeudo': '${widget.total}',
                      'pago': personBloc.pagoTotal['pago'],
                      'adeudo': '${widget.total}',
                      'subsidio': personBloc.subsidio['subsidio'],
                    });

                    personBloc.enableButton();
                  },
                )),
            StreamBuilder(
              stream: personBloc.cambioStream,
              builder: (context, snapshot) {
                return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: TextField(
                    textAlign: TextAlign.center,
                    inputFormatters: [
                      WhitelistingTextInputFormatter.digitsOnly
                    ],
                    keyboardType: TextInputType.numberWithOptions(
                        decimal: true, signed: false),
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.attach_money),
                        labelText: 'Recibí',
                        hintText: '0.00',
                        errorText: snapshot.error),
                    onChanged: (val) {
                      final valTosend = val ?? 0;
                      print("VAL: $valTosend");
                      print("PAGO: ${personBloc.pagoInput['pago']}");
                      personBloc.changeCambio({
                        'recibido': valTosend,
                        'pago': '${personBloc.pagoInput['pago']}'
                      });

                      personBloc.enableButton();
                    },
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
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
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  StreamBuilder(
                      stream: personBloc.pagoInputStream,
                      builder: (context, snapshot) {
                        final total = snapshot.hasData
                            ? snapshot.data ?? widget.total
                            : widget.total;
                        return Text('Adeudo final: \$ $total');
                      })
                ],
              ),
            ),
            StreamBuilder(
                stream: personBloc.pagoInputStream,
                builder: (context, snapshot) {
                  final error = snapshot.error ?? "";
                  return Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Text(
                      '$error',
                      style: TextStyle(color: Colors.red),
                    ),
                  );
                }),
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
              return FlatButton.icon(
                icon: Icon(Icons.payment),
                label: Text('Pagar'),
                onPressed: snapshot.hasData
                ? snapshot.data 
                ? () {} 
                : null 
                : null,
              );
            })
      ],
    );
  }
}
