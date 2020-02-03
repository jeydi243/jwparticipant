import 'package:flutter/material.dart';
import 'package:jwparticipant/auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jwparticipant/home.dart';

class Signup extends StatefulWidget {
	Signup({this.auth});
	final BaseAuth auth;

	@override
	_SignupState createState() => _SignupState();
}

class _SignupState extends State < Signup > {
	final _formKey = GlobalKey < FormState > ();
	bool _canObscure = true;
	String _email;
	String _nom;
	String _password;

	_moveToLogin() {
		setState(() {
			// _formType = FormType.login;
		});
	}
	Route _createRoute() {
		return PageRouteBuilder(
			pageBuilder: (context, animation, secondaryAnimation) => HomePage(),
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
	bool _validateandSave() {
		final form = _formKey.currentState;
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
	void _submit() async{
		try {
			if(_validateandSave()){
				String uid = await widget.auth.signUp(_email, _password, _nom);
				print("L'utilisateur s'est bien enregistré $uid");
				_formKey.currentState.reset();
				Navigator.of(context).push(_createRoute());
			}
		} catch (e) {
			print(e);
		}
	}

	@override
	Widget build(BuildContext context) {
		return Column(
			mainAxisAlignment: MainAxisAlignment.center,
			children: [
				Image.asset("images/conversation.png", fit: BoxFit.fill),
				Text("Rejoignez-nous!", softWrap: true,
					style: TextStyle(
						color: Colors.yellow[800],
						fontSize: 30,

					),
				),
				new TextFormField(
					onSaved: (value) => _nom = value,

					validator: (value) => value.isEmpty ? "Le nom doit etre renseigné" : null,
					decoration: new InputDecoration(
						isDense: true,
						prefixIcon: Icon(Icons.account_circle, color: Colors.teal, ),
						labelText: "Nom",
						labelStyle: GoogleFonts.bubblegumSans(textStyle: TextStyle(
							color: Colors.teal,
						))
					),
				),
				new TextFormField(
					onSaved: (value) => _email = value,
					validator: (value) => value.isEmpty ? "L'email doit etre renseigné" : null,
					decoration: new InputDecoration(
						hoverColor: Colors.green,
						isDense: true,
						prefixIcon: Icon(Icons.email, color: Colors.teal, ),
						labelText: "Email",
						labelStyle: GoogleFonts.bubblegumSans(textStyle: TextStyle(
							color: Colors.teal,
						))
					),
				),
				new TextFormField(
					onSaved: (value) => _password = value,
					validator: (value) => value.isEmpty ? "Le mot de passe doit etre renseigné" : null,
					decoration: new InputDecoration(
						isDense: true,
						prefixIcon: Icon(Icons.lock, color: Colors.teal),
						suffixIcon: FlatButton(
							child: _canObscure == true ? Text("SHOW") : Text("HIDE"),
							onPressed: () {
								setState(() {
									_canObscure = _canObscure ? false : true;
								});
							},
						),
						labelText: "Mot de passe",
						labelStyle: GoogleFonts.bubblegumSans(textStyle: TextStyle(
							color: Colors.teal,
						))
					),
					obscureText: _canObscure,
				),
				new RaisedButton(
					elevation: 12.0,
					padding: EdgeInsets.all(10.0),

					shape: RoundedRectangleBorder(
						borderRadius: new BorderRadius.circular(18.0),
					),
					textColor: Colors.teal,
					child: Text("CREER"),
					onPressed: _submit,
				),
				Row(
					children: < Widget > [
						Spacer(),
						Text("Déja enregistré?"),
						FlatButton(
							padding: EdgeInsets.zero,
							child: Text("Connexion",
								style: TextStyle(
									color: Colors.teal,
									fontWeight: FontWeight.bold
								), ),
							onPressed: _moveToLogin,
						),

					],
				)
			]
		);
	}
}