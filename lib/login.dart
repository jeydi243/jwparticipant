import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jwparticipant/home.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:google_fonts/google_fonts.dart';

enum FormType {
	login,
	signup
}
class LoginPage extends StatefulWidget {
	LoginPage({
		Key key
	}): super(key: key);

	@override
	_LoginState createState() => _LoginState();
}

class _LoginState extends State < LoginPage > {
	final formKey = GlobalKey < FormState > ();
	String email;
	String password;
	FormType _formType = FormType.login;


	bool _validateandSave() {
		final form = formKey.currentState;
		if (form.validate()) {
			form.save();
			print("le formulaire est pret");
			print('$email et $password');
			return true;
		} else {
			print("Erreur dans le formulaire");
			return false;
		}
	}
	void _submit() async {
		if (_validateandSave()) {
			try {
				if (_formType == FormType.login) {
					FirebaseUser user = (await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password)).user;
					print("L'utilisateur s'est bien connecté ${user.uid}");
					formKey.currentState.reset();
					Navigator.of(context).push(_createRoute());
				} else {
					FirebaseUser user = (await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password)).user;
					print("L'utilisateur s'est bien enregistré ${user.uid}");
					formKey.currentState.reset();
					Navigator.of(context).push(_createRoute());
				}
			} catch (e) {
				print(e);
			}
		}
	}
	Route _createRoute() {
		return PageRouteBuilder(
			pageBuilder: (context, animation, secondaryAnimation) => MyHomePage(),
			transitionsBuilder: (context, animation, secondaryAnimation, child) {
				var begin = Offset(0.0, 1.0);
				var end = Offset.zero;
				var tween = Tween(begin: begin, end: end);
				var offsetAnimation = animation.drive(tween);

				return SlideTransition(
					position: offsetAnimation,
					child: child,
				);
			},
		);
	}
	Color hexToColor(String code) {
		return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
	}
	_moveTocreerCompte() {
		setState(() {
			_formType = FormType.signup;
		});
	}
	_moveToLogin() {
		setState(() {
			_formType = FormType.login;
		});
	}
	@override
	Widget build(BuildContext context) {
		return Scaffold(
			body: SafeArea(
				child: Stack(
					fit: StackFit.passthrough,
					children: [
						FlareActor("assets/Lowpoly.flr",
							animation: "move",
						),
						Center(
							child: new AnimatedContainer(
								curve: Curves.fastOutSlowIn,
								duration: Duration(seconds: 2),
								alignment: Alignment.center,
								decoration: BoxDecoration(
									gradient: LinearGradient(
										begin: Alignment.topRight,
										end: Alignment.bottomLeft,
										colors: [hexToColor("#71A38C"), hexToColor("#124A2C")]),
								),
								padding: EdgeInsets.all(15.0),
								child: new Form(
									key: formKey,
									child: new Column(
										children: _buildBody() + _buildSubmitButtons()
									),
								),
							),
						)
					],
				)
			)
		);

	}

	List < Widget > _buildBody() {
		return [
			new Text("Bonjour!,", style: GoogleFonts.bubblegumSans(
				textStyle: TextStyle(color: Colors.white, letterSpacing: .5)
			)),
			new Text("Bienvenue, Ravis de vous voir", style: GoogleFonts.bubblegumSans(textStyle: TextStyle(
				color: Colors.white,
				fontSize: 22.0,
				letterSpacing: .5
			))),
			new TextFormField(
				onSaved: (value) => email = value,
				validator: (value) => value.isEmpty ? "L'email doit etre renseigné" : null,
				decoration: new InputDecoration(
					labelText: "Email",
					labelStyle: GoogleFonts.bubblegumSans(textStyle: TextStyle(
						color: Colors.white,
					))
				),
			),
			new TextFormField(
				onSaved: (value) => password = value,
				validator: (value) => value.isEmpty ? "Le mot de passe doit etre renseigné" : null,
				decoration: new InputDecoration(
					labelText: "Mot de passe",
					labelStyle: GoogleFonts.bubblegumSans(textStyle: TextStyle(
						color: Colors.white,
					))
				),
				obscureText: true,
			),
		];
	}

	List < Widget > _buildSubmitButtons() {
		if (_formType == FormType.login) {
			return [
				new RaisedButton(
					elevation: 22.0,
					textColor: hexToColor("#124A2C"),
					child: new Text("Connexion"),
					shape: RoundedRectangleBorder(
						borderRadius: new BorderRadius.circular(18.0),
					),
					color: Colors.white,
					onPressed: () {
						_submit();
					},
				),
				new FlatButton(
					child: Text("Creer un compte", style: TextStyle(color: Colors.white)),
					onPressed: _moveTocreerCompte,
				)
			];
		} else {
			return [
				new RaisedButton(
					textColor: hexToColor("#124A2C"),
					child: new Text("Creer compte"),
					color: Colors.white,
					onPressed: () {
						_submit();
					},
				),
				new FlatButton(
					child: Text("Vous possedez deja compte? Connexion", style: TextStyle(color: Colors.white)),
					onPressed: _moveToLogin,
				)
			];
		}
	}

}