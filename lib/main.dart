// import 'package:flare_flutter/flare_actor.dart';
// import 'package:flare_splash_screen/flare_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:jwparticipant/login.dart';
import 'package:jwparticipant/home.dart';
import 'package:jwparticipant/auth.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
	@override
	Widget build(BuildContext context) {
		return MaterialApp(
			initialRoute: "/login",
			debugShowCheckedModeBanner: false,
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

