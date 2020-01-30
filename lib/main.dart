// import 'package:flare_flutter/flare_actor.dart';
// import 'package:flare_splash_screen/flare_splash_screen.dart';
import 'package:flutter/material.dart';
// import 'package:jwparticipant/auth.dart';
import 'package:jwparticipant/login.dart';
import 'package:jwparticipant/home.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
	@override
	Widget build(BuildContext context) {
		return MaterialApp(
			debugShowCheckedModeBanner: false,
			initialRoute: "/login",
			routes: < String, WidgetBuilder > {
				'/home': (BuildContext context) {
					return MyHomePage();
				},
				'/login': (BuildContext context) {
					return LoginPage();
				}
			},
		);
	}
}

