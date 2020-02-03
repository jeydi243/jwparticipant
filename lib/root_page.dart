import 'package:flutter/material.dart';
import 'package:jwparticipant/auth.dart';
import 'package:jwparticipant/home.dart';
import 'package:jwparticipant/login.dart';
import 'package:jwparticipant/signup.dart';

enum AuthStatus {
	signedIn,
	notSignedIn
}
enum FormType {
	login,
	signup
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
	FormType _formType = FormType.login;

	
	void _moveToLogin() {
		setState(() {
			_formType = FormType.login;
		});
	}
	void _moveToSignup() {
		setState(() {
			 _formType = FormType.signup;
		});
	}
	void _signedIn() {
		setState(() {
			status = AuthStatus.signedIn;
		});
	}
	void _signedOut() {
		setState(() {
			status = AuthStatus.notSignedIn;
		});
	}
	
	@override
	void initState() {
		super.initState();
		widget.auth.currentUser().then((uid) {
			setState(() {
				status = uid == null ? AuthStatus.notSignedIn : AuthStatus.signedIn;
			});
		});
	}

	@override
	Widget build(BuildContext context) {
		switch (status) {
			case AuthStatus.notSignedIn:
				return AnimatedSwitcher(
					duration: Duration(seconds: 1),
					switchInCurve: Curves.linear,
					child: _formType ==FormType.login? new LoginPage(
						auth: widget.auth,
						onSignedIn: _signedIn,
						move: _moveToSignup
					): new Signup(
						auth: widget.auth,
						move: _moveToLogin,
					),
				);

			case AuthStatus.signedIn:
				return new HomePage(
					auth: widget.auth,
					onSignedOut: _signedOut
				);

		}
		return new Scaffold(
			appBar: AppBar(title: Text("le monde est beau")),
			body: Container(
				child: Text("Le corps"),
			),
		);

	}
}