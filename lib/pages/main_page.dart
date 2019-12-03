import 'package:flutter/material.dart';
import 'package:after_init/after_init.dart';

import 'package:prolimpia_mobile/bloc/provider.dart';
import 'package:prolimpia_mobile/pages/home_page.dart';
import 'package:prolimpia_mobile/pages/login/login_page.dart';
import 'package:prolimpia_mobile/pages/login/splash_page.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with AfterInitMixin<MainPage>{
  @override
  void initState() {
    super.initState();
  }

  @override
  void didInitState() {
    Provider.authBloc(context).checkToken().then((value) {
      print('check token complete');
    }, onError: (error) {
      print('check token error $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    final authBloc = Provider.authBloc(context);
    return StreamBuilder(
      stream: authBloc.isLoadingStream,
      builder: (BuildContext ctx, AsyncSnapshot<String> snapshot) {
        return (!snapshot.hasData || snapshot.data == 'UNAUTHORIZED')
            ? LoginPage()
            : (snapshot.data == 'OK') ? HomePage() : SplashPage();
      },
    );
  }
}
