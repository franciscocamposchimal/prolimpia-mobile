import 'package:flutter/material.dart';
import 'package:after_init/after_init.dart';
import 'package:flutter/services.dart';
import 'package:prolimpia_mobile/bloc/provider.dart';
import 'package:prolimpia_mobile/models/person_model.dart';
import 'package:prolimpia_mobile/utils/custom_icon_icons.dart';

class CollectPage extends StatefulWidget {
  final Person person;

  CollectPage({Key key, @required this.person}) : super(key: key);

  @override
  _CollectPageState createState() => _CollectPageState();
}

class _CollectPageState extends State<CollectPage>
    with AfterInitMixin<CollectPage> {
  @override
  void didInitState() {
    Provider.personsBloc(context).getPago(widget.person.usrNumcon).then(
        (value) {
      print('get payment complete');
    }, onError: (error) {
      print('get payment error $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    final personBloc = Provider.personsBloc(context);
    personBloc.changeCambio({'recibido': '0', 'pago': '0'});
    personBloc.changePagoTotal({'pago': '0.0'});
    personBloc.changeSubsidio({'subsidio': '${widget.person.usrSubsidio}'});
    personBloc.changePagoInput({
      'totalAdeudo': '${widget.person.usrTotal}',
      'pago': '0.0',
      'adeudo': '${widget.person.usrTotal}',
      'subsidio': '${widget.person.usrSubsidio}',
    });
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: _appBar(context),
      body: Container(
        color: Colors.white,
        child: ListView(
          children: <Widget>[
            _topArea(),
            SizedBox(
              height: 40.0,
              child: Center(
                child: Text(
                  'Historial de pagos',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            _formToPay(personBloc),
          ],
        ),
      ),
      bottomNavigationBar: _bottomApp(),
    );
  }

  Widget _bottomApp() {
    return BottomAppBar(
      elevation: 5.0,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            OutlineButton(
              padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 28.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0.0)),
              borderSide: BorderSide(color: Color(0xFF015FFF), width: 1.0),
              onPressed: () {},
              child: Text("Historial"),
            )
          ],
        ),
      ),
    );
  }

  Widget _appBar(BuildContext context) {
    return AppBar(
      elevation: 2.0,
      title: Text('PROLIMPIA',
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 30.0)),
      centerTitle: true,
      actions: <Widget>[
        Container(
          margin: EdgeInsets.only(right: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
          ),
        )
      ],
      flexibleSpace: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[
              Color.fromRGBO(103, 218, 255, 1.0),
              Color.fromRGBO(0, 47, 67, 1.0),
              Color.fromRGBO(0, 47, 67, 1.0)
            ])),
      ),
    );
  }

  Widget _formToPay(PersonBloc bloc) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(30.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              enabled: false,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(CustomIcon.percent),
                  labelText: 'Subsidio ${widget.person.usrSubsidio}'),
            ),
            SizedBox(height: 20.0),
            TextField(
              textAlign: TextAlign.center,
              autofocus: true,
              inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
              keyboardType:
                  TextInputType.numberWithOptions(decimal: true, signed: false),
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.attach_money),
                  labelText: 'Pago',
                  hintText: '0.00'),
              onChanged: (val) {
                final valueChange = val.isNotEmpty ? val : "0.0";
                bloc.changePagoTotal({'pago': valueChange});

                bloc.changePagoInput({
                  'totalAdeudo': '${widget.person.usrTotal}',
                  'pago': bloc.pagoTotal['pago'],
                  'adeudo': '${widget.person.usrTotal}',
                  'subsidio': '${widget.person.usrSubsidio}',
                });

                bloc.enableButton();
              },
            ),
            SizedBox(height: 20.0),
            StreamBuilder(
              stream: bloc.cambioStream,
              builder: (context, snapshot) {
                return TextField(
                  textAlign: TextAlign.center,
                  inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                  keyboardType: TextInputType.numberWithOptions(
                      decimal: true, signed: false),
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.attach_money),
                      labelText: 'Recibí',
                      hintText: '0.00',
                      errorText: snapshot.error),
                  onChanged: (val) {
                    final valTosend = val ?? 0;
                    print("VAL: $valTosend");
                    print("PAGO: ${bloc.pagoInput['pago']}");
                    bloc.changeCambio({
                      'recibido': valTosend,
                      'pago': '${bloc.pagoInput['pago']}'
                    });

                    bloc.enableButton();
                  },
                );
              },
            ),
            SizedBox(height: 10.0),
            Container(
              decoration: BoxDecoration(border: Border.all(width: 2)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  SizedBox(height: 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child:
                            Text('Recargo: \$ ${widget.person.usrRecargo.toStringAsFixed(2)}'),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child:
                            Text('Subtotal: \$ ${widget.person.usrSubtotal}'),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Total: \$ ${widget.person.usrTotal}'),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      StreamBuilder(
                          stream: bloc.cambioStream,
                          builder: (context, snapshot) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                  'Cambio Total: \$ ${snapshot.hasData ? snapshot.data : 0}'),
                            );
                          }),
                    ],
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      StreamBuilder(
                          stream: bloc.pagoInputStream,
                          builder: (context, snapshot) {
                            final total = snapshot.hasData
                                ? snapshot.data ?? widget.person.usrTotal
                                : widget.person.usrTotal;
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Adeudo final: \$ $total'),
                            );
                          })
                    ],
                  ),
                  StreamBuilder(
                      stream: bloc.pagoInputStream,
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
          ],
        ),
      ),
    );
  }

  Widget _topArea() {
    return Card(
      margin: EdgeInsets.all(10.0),
      elevation: 1.0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(50.0))),
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          Color.fromRGBO(103, 218, 255, 1.0),
          Color.fromRGBO(0, 47, 67, 1.0),
          Color.fromRGBO(0, 47, 67, 1.0)
        ])),
        padding: EdgeInsets.all(5.0),
        child: Column(
          children: <Widget>[
            SizedBox(height: 10.0),
            Center(
              child: Padding(
                padding: EdgeInsets.all(5.0),
                child: Text(
                  '${widget.person.usrNumcon}',
                  style: TextStyle(color: Colors.white, fontSize: 12.0),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.all(5.0),
                child: Text(
                  '${widget.person.usrNombre}',
                  style: TextStyle(color: Colors.white, fontSize: 20.0),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.all(5.0),
                child: Text(
                  '${widget.person.usrDomici}',
                  style: TextStyle(color: Colors.white, fontSize: 12.0),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Zona: ${widget.person.usrZona}',
                  style: TextStyle(color: Colors.white, fontSize: 20.0),
                ),
                Text(
                  'Total: \$ ${widget.person.usrTotal}',
                  style: TextStyle(color: Colors.white, fontSize: 24.0),
                ),
                Text(
                  'Ruta: ${widget.person.usrRuta}',
                  style: TextStyle(color: Colors.white, fontSize: 20.0),
                )
              ],
            ),
            SizedBox(height: 5.0),
            Center(
              child: Padding(
                padding: EdgeInsets.all(5.0),
                child: Text(
                  'Mes facturado: ${widget.person.usrMesFac}',
                  style: TextStyle(color: Colors.white, fontSize: 15.0),
                ),
              ),
            ),
            SizedBox(height: 25.0),
          ],
        ),
      ),
    );
  }
}
