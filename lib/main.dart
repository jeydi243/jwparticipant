import 'package:flutter/material.dart';
import 'package:jwparticipant/auth.dart';
import 'package:jwparticipant/root_page.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
	@override
	Widget build(BuildContext context) {
		return MaterialApp(
      
			debugShowCheckedModeBanner: false,
			home: RootPage(auth: Auth()),
			// initialRoute: "/login",
			// routes: < String, WidgetBuilder > {
			// 	'/home': (BuildContext context) {
			// 		return MyHomePage();
			// 	},
			// 	'/login': (BuildContext context) {
			// 		return LoginPage();
			// 	}
			// },
		);
	}
}

