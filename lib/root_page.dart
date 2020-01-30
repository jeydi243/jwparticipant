import 'package:flutter/material.dart';
import 'package:jwparticipant/auth.dart';
import 'package:jwparticipant/home.dart';
import 'package:jwparticipant/login.dart';

enum AuthStatus {
	signedIn,
	notSignedIn
}

class RootPage extends StatefulWidget {
	RootPage({
		this.auth
	});
	final BaseAuth auth;
	@override
	_RootPageState createState() => _RootPageState();
}

class _RootPageState extends State < RootPage > {
	AuthStatus status = AuthStatus.notSignedIn;
	@override
	Widget build(BuildContext context) {
		switch (status) {
			case AuthStatus.notSignedIn:
				return Container(
					child: new LoginPage(auth: widget.auth),
				);
				break;
			case AuthStatus.signedIn:
				return Container(
					child: new MyHomePage(),
				);
				break;
		}

	}
}