import 'package:flutter/material.dart';

import 'package:prolimpia_mobile/bloc/provider.dart';
import 'package:prolimpia_mobile/pages/home_page.dart';
import 'package:prolimpia_mobile/pages/login/login_page.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authBloc = Provider.authBloc(context);
    return StreamBuilder(
      stream: authBloc.isLoadingStream,
      builder: (BuildContext ctx, AsyncSnapshot<bool> snapshot) {
        return !snapshot.hasData
            ? LoginPage()
            : snapshot.data ? HomePage() : LoginPage();
      },
    );
  }

}
