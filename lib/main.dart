import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jwparticipant/services/auth.dart';
import 'package:jwparticipant/root_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
	@override
	Widget build(BuildContext context) {
		return MultiProvider(
			providers: [
				StreamProvider<FirebaseUser>.value(
					value: FirebaseAuth.instance.onAuthStateChanged
				),
			],
			child: MaterialApp(
				localizationsDelegates: [
					GlobalMaterialLocalizations.delegate,
					GlobalWidgetsLocalizations.delegate,
					GlobalCupertinoLocalizations.delegate,
				],

				locale: Locale("fr"),
				debugShowCheckedModeBanner: false,
				home: RootPage(auth: Auth()),
			),
		);
	}
}