import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jwparticipant/home.dart';

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
				return child;
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
			// appBar: AppBar(
			// 	title: Text("Login"),
			// ),
			body: SafeArea(
				child: Center(
					child: new Container(
						// height: 200.0,
						// width: 200.0,
						alignment: Alignment.center,
						decoration: BoxDecoration(
							gradient: LinearGradient(
								begin: Alignment.topRight,
								end: Alignment.bottomLeft,
								colors: [hexToColor("#71A38C"), hexToColor("#124A2C")])
						),
						padding: EdgeInsets.all(15.0),
						child: new Form(
							key: formKey,
							child: new Column(
								children: _buildBody() + _buildSubmitButtons()
							),
						),
					),
				))
		);

	}

	List < Widget > _buildBody() {
		return [
			new Text("Hello,", style: TextStyle(
				color: Colors.white
			)),
			new Text("Bienvenue, Ravis de vous voir", style: TextStyle(
				color: Colors.white,
				fontWeight: FontWeight.bold,
				fontSize: 22.0
			)),
			new TextFormField(
				onSaved: (value) => email = value,
				validator: (value) => value.isEmpty ? "L'email doit etre renseigné" : null,
				decoration: new InputDecoration(
					labelText: "Email",
					labelStyle: TextStyle(
						color: Colors.white,

					)
				),
			),
			new TextFormField(
				onSaved: (value) => password = value,
				validator: (value) => value.isEmpty ? "Le mot de passe doit etre renseigné" : null,
				decoration: new InputDecoration(
					labelText: "Mot de passe",
					labelStyle: TextStyle(
						color: Colors.white,

					)
				),
				obscureText: true,
			),
		];
	}

	List < Widget > _buildSubmitButtons() {
		if (_formType == FormType.login) {
			return [
				new RaisedButton(
					textColor: hexToColor("#124A2C"),
					child: new Text("Connexion"),
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