import 'package:flutter/material.dart';
import 'package:after_init/after_init.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:prolimpia_mobile/bloc/provider.dart';
import 'package:prolimpia_mobile/models/collect_model.dart';
import 'package:prolimpia_mobile/pages/search_delegate.dart';
//import 'package:prolimpia_mobile/models/collect_model.dart';
import 'package:prolimpia_mobile/widgets/dash_grid.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AfterInitMixin<HomePage> {
  @override
  void didInitState() {
    Provider.authBloc(context).getCollect().then((value) {
      print('check token complete');
    }, onError: (error) {
      print('check token error $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    final authBloc = Provider.authBloc(context);
    final primaryColor = Theme.of(context).primaryColor;
    return Scaffold(
      appBar: _appBar(authBloc, primaryColor),
      body: StreamBuilder(
          stream: authBloc.collectStream,
          builder:
              (BuildContext cxt, AsyncSnapshot<Map<String, dynamic>> snapshot) {
            return !snapshot.hasData || snapshot.data['action'] == 'GET'
                ? Center(child: CircularProgressIndicator())
                : StaggeredGridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12.0,
                    mainAxisSpacing: 12.0,
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    children: dasboardGrid(snapshot.data['body']),
                    staggeredTiles: _staggeds(snapshot.data['body']),
                  );
          }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: () {
          showSearch(context: context, delegate: DataSearch());
        },
      ),
    );
  }

  List<StaggeredTile> _staggeds(Collect collect) {
    var staggeds = [
      StaggeredTile.fit(2),
      StaggeredTile.fit(1),
      StaggeredTile.fit(1),
    ];
    final collectsItem = collect.todayCollects;
    for (final _ in collectsItem) {
      staggeds.add(StaggeredTile.fit(2));
    }
    return staggeds;
  }

  Widget _appBar(LoginBloc bloc, Color primary) {
    return AppBar(
      elevation: 2.0,
      //backgroundColor: primary,
      leading: Hero(
        tag: 'logo-hero',
        child: Image.asset(
          'assets/prolimpiaMobile2_blanco.png',
          width: 200.0,
          height: 200.0,
        ),
      ),
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
            children: <Widget>[
              _getOut(bloc),
            ],
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

  Widget _getOut(LoginBloc bloc) {
    return FlatButton.icon(
      label: Text('Salir',
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 14.0)),
      onPressed: () => bloc.logOut(),
      icon: Icon(Icons.power_settings_new, color: Colors.white),
    );
  }
}
