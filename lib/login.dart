import 'package:flutter/material.dart';
import 'package:jwparticipant/auth.dart';
import 'package:jwparticipant/home.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:google_fonts/google_fonts.dart';

enum FormType {
	login,
	signup
}
class LoginPage extends StatefulWidget {
	LoginPage({
		this.auth
	});
	final BaseAuth auth;

	@override
	_LoginState createState() => _LoginState();
}

class _LoginState extends State < LoginPage > {
	final formKey = GlobalKey < FormState > ();
	String _email;
	String _password;
	String debut = "#71A38C";
	String fin = "#124A2C";
	FormType _formType = FormType.login;


	bool _validateandSave() {
		final form = formKey.currentState;
		if (form.validate()) {
			form.save();
			print("le formulaire est pret");
			print('$_email et $_password');
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
					String uid = await widget.auth.signIn(_email, _password);
					print("L'utilisateur s'est bien connecté $uid");
					formKey.currentState.reset();
					Navigator.of(context).push(_createRoute());
				} else {
					String uid = await widget.auth.signup(_email, _password);
					print("L'utilisateur s'est bien enregistré $uid");
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
			debut = "#FFE53B";

		});
	}
	_moveToLogin() {
		setState(() {
			_formType = FormType.login;
			fin = "#FF2525";
		});
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			body: SafeArea(
				child: Center(
					child: new AnimatedContainer(
						curve: Curves.fastOutSlowIn,
						duration: Duration(seconds: 2),
						alignment: Alignment.center,
						decoration: BoxDecoration(
							gradient: LinearGradient(
								begin: Alignment.topRight,
								end: Alignment.bottomLeft,
								colors: [hexToColor(debut), hexToColor(fin)]),
						),
						padding: EdgeInsets.all(15.0),
						child: Center(child: new Form(
							key: formKey,
							child: new Column(
								mainAxisAlignment: MainAxisAlignment.center,
								children: _buildBody() + _buildSubmitButtons()
							),
						), )
					),
				)
			)
		);

	}

	List < Widget > _buildBody() {
		return [
			new Text("Bonjour!,", 
			style: GoogleFonts.bubblegumSans(
				textStyle: TextStyle(
					color: Colors.white,
					letterSpacing: .5,
					fontSize: 25.0,
				)
			)),
			new Text("Ravis de vous revoir", 
			style: GoogleFonts.bubblegumSans(textStyle: TextStyle(
				color: Colors.white,
				fontSize: 35.0,
				letterSpacing: .5
			))),
			new TextFormField(

				onSaved: (value) => _email = value,
				validator: (value) => value.isEmpty ? "L'email doit etre renseigné" : null,
				decoration: new InputDecoration(
					hoverColor: Colors.green,
					isDense: true,
					suffixIcon: Icon(Icons.account_circle, color: Colors.white, ),
					labelText: "Email",
					labelStyle: GoogleFonts.bubblegumSans(textStyle: TextStyle(
						color: Colors.white,
					))
				),
			),
			new TextFormField(
				onSaved: (value) => _password = value,
				validator: (value) => value.isEmpty ? "Le mot de passe doit etre renseigné" : null,
				decoration: new InputDecoration(
					suffixIcon: Icon(Icons.lock, color: Colors.white, ),
					labelText: "Mot de passe",
					labelStyle: GoogleFonts.bubblegumSans(textStyle: TextStyle(
						color: Colors.white,
					))
				),
				obscureText: true,
			),
			Row(
				children: <Widget>[
					Spacer(flex: 2,),
					new Text("Reinitialisé? ",
						style: GoogleFonts.alef(
							textStyle: TextStyle(
								color: Colors.white
							)
						)
					),
				],
			),
			
		];
	}

	List < Widget > _buildSubmitButtons() {
		if (_formType == FormType.login) {
			return [
				new RaisedButton(
					elevation: 12.0,
					highlightElevation: 12.0,
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