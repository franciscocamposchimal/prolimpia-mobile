import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:path_provider/path_provider.dart';
import 'package:prolimpia_mobile/bloc/provider.dart';
import 'package:prolimpia_mobile/utils/custom_icon_icons.dart';

class PaymenDialog extends StatefulWidget {
  final String total;

  PaymenDialog({Key key, @required this.total}) : super(key: key);

  @override
  _PaymenDialogState createState() => _PaymenDialogState();
}

class _PaymenDialogState extends State<PaymenDialog> {
  //Bluetooth
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;

  List<BluetoothDevice> _devices = [];
  BluetoothDevice _device;
  bool _connected = false;
  bool _pressed = false;
  String pathImage;
  //Bluetooth

  @override
  void initState() {
    super.initState();
    initPlatformState();
    initSavetoPath();
  }

  initSavetoPath() async {
    final filename = 'logo-ticket.png';
    var bytes = await rootBundle.load("assets/logo-ticket.png");
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String dir = appDocDir.path;
    writeToFile(bytes, '$dir/$filename');
    setState(() {
      pathImage = '$dir/$filename';
    });
  }

  Future<void> initPlatformState() async {
    List<BluetoothDevice> devices = [];

    try {
      devices = await bluetooth.getBondedDevices();
    } on PlatformException {
      print("ERROR...");
    }

    bluetooth.onStateChanged().listen((state) {
      switch (state) {
        case BlueThermalPrinter.CONNECTED:
          setState(() {
            _connected = true;
            _pressed = false;
          });
          break;
        case BlueThermalPrinter.DISCONNECTED:
          setState(() {
            _connected = false;
            _pressed = false;
          });
          break;
        default:
          print(state);
          break;
      }
    });

    if (!mounted) return;
    setState(() {
      _devices = devices;
    });
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
//write to app path
Future<void> writeToFile(ByteData data, String path) {
  final buffer = data.buffer;
  return new File(path)
      .writeAsBytes(buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
}
