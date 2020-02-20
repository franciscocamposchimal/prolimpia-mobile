import 'package:flutter/material.dart';
import 'package:after_init/after_init.dart';

import 'package:prolimpia_mobile/bloc/provider.dart';
import 'package:prolimpia_mobile/models/payments_model.dart';
import 'package:prolimpia_mobile/models/person_model.dart';
import 'package:prolimpia_mobile/pages/payment_dialog.dart';

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
            _paymentItems(personBloc),
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
              onPressed: () async {
                await _formDialog(context);
              },
              child: Text("PAGAR"),
            )
          ],
        ),
      ),
    );
  }

  Future _formDialog(BuildContext context) async {
    return await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return PaymenDialog(total: '${widget.person.usrTotal}');
        });
  }

  Widget _appBar(BuildContext context) {
    return AppBar(
      iconTheme: IconThemeData(
        color: Theme.of(context).primaryColor,
      ),
      backgroundColor: Colors.white,
      elevation: 0.0,
      title: Text(
        'Cobros',
        style: TextStyle(color: Colors.black),
      ),
      centerTitle: true,
    );
  }

  Widget _paymentItems(PersonBloc bloc) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Container(
          padding:
              EdgeInsets.only(top: 20.0, bottom: 20.0, left: 5.0, right: 5.0),
          child: StreamBuilder(
              stream: bloc.pagosStream,
              builder: (BuildContext ctx,
                  AsyncSnapshot<Map<String, dynamic>> snapshot) {
                return snapshot.hasData && snapshot.data['action'] == 'SUCCESS'
                    ? _listCards(snapshot.data['body'])
                    : Center(child: CircularProgressIndicator());
              })),
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
                child: ListTile(
                  leading: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 20.0,
                      ),
                      Icon(
                        Icons.check,
                        color: Colors.green,
                      )
                    ],
                  ),
                  title: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 20.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'S. ant: \$ ${pagos[index].saldoant}',
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            'S. post: \$ ${pagos[index].saldopost}',
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            '${pagos[index].tipopago}',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ],
                  ),
                  subtitle: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 20.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      SizedBox(
                        height: 20.0,
                      ),
                    ],
                  ),
                  trailing: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 30.0,
                      ),
                      Text('${pagos[index].referencia}'),
                    ],
                  ),
                ),
              );
            },
          )
        : Center(child: Text('Sin pagos anteriores...'));
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
          Color.fromRGBO(0, 122, 193, 1.0)
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
                  'Último pago: ${widget.person.usrMesFac}',
                  style: TextStyle(color: Colors.white, fontSize: 10.0),
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
