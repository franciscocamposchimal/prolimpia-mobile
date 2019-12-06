import 'package:flutter/material.dart';
import 'package:prolimpia_mobile/models/collect_model.dart';
import 'package:prolimpia_mobile/widgets/build_tile.dart';

List<Widget> dasboardGrid(Collect collect) {
  final collectsItem = collect.todayCollects.map((item) {
    return buildTile(
      Padding(
        padding: const EdgeInsets.all(24.0),
        child: ListTile(
          leading: Icon(Icons.monetization_on),
          title: Text('${item.data.nombre}'),
          subtitle: Row(
            children: <Widget>[
              Text(
                'Pago: ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('\$ ${item.data.pago}'),
              SizedBox(width: 20.0),
              Text(
                'tipo de pago: ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('${item.data.tipoPago}')
            ],
          ),
          trailing: Icon(Icons.keyboard_arrow_right),
        ),
      ),
      onTap: () {},
    );
  });

  return <Widget>[
    buildTile(
      Padding(
        padding: const EdgeInsets.all(24.0),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Total recolectado',
                      style: TextStyle(color: Colors.blueAccent)),
                  Text('\$ ${collect.total}',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: 34.0))
                ],
              ),
              Material(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(24.0),
                  child: Center(
                      child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child:
                        Icon(Icons.timeline, color: Colors.white, size: 30.0),
                  )))
            ]),
      ),
    ),
    buildTile(
      Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Material(
                  color: Colors.teal,
                  shape: CircleBorder(),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Icon(Icons.settings_applications,
                        color: Colors.white, size: 30.0),
                  )),
              Padding(padding: EdgeInsets.only(bottom: 16.0)),
              Text('General',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 24.0)),
              Text('Images, Videos', style: TextStyle(color: Colors.black45)),
            ]),
      ),
    ),
    buildTile(
      Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Material(
                  color: Colors.amber,
                  shape: CircleBorder(),
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Icon(Icons.notifications,
                        color: Colors.white, size: 30.0),
                  )),
              Padding(padding: EdgeInsets.only(bottom: 16.0)),
              Text('Alerts',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 24.0)),
              Text('All ', style: TextStyle(color: Colors.black45)),
            ]),
      ),
    ),
  ]..addAll(collectsItem);
}
