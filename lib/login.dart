import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:jwparticipant/auth.dart';
import 'package:jwparticipant/home.dart';
// import 'package:flare_flutter/flare_actor.dart';
import 'package:google_fonts/google_fonts.dart';

enum FormType {
	login,
	signup
}
class LoginPage extends StatefulWidget {
	LoginPage({
		this.auth,
		this.onSignedIn
	});
	final BaseAuth auth;
	final VoidCallback onSignedIn;
	@override
	_LoginState createState() => _LoginState();
}

class _LoginState extends State < LoginPage > {
	final _formKey = GlobalKey < FormState > ();
	String fin = "#FAD961";
	String _email;
	String _password;

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
	void _submit() async {
		if (_validateandSave()) {
			try {
				String uid = await widget.auth.signIn(_email, _password);
				print("L'utilisateur s'est bien connecté $uid");
				_formKey.currentState.reset();
				Navigator.of(context).push(_createRoute());
			} catch (e) {
				print(e);
			}
		}
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
	Color _hexToColor(String code) {
		return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
	}
	_moveTocreerCompte() {
		setState(() {
			// _formType = FormType.signup;
		});
	}

	@override
	void initState() {
		super.initState();
		// _formType = FormType.login;
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			backgroundColor: Colors.white,
			body: new AnimatedContainer(
				curve: Curves.fastOutSlowIn,
				duration: Duration(seconds: 2),
				alignment: Alignment.center,
				decoration: BoxDecoration(
					color: Colors.white,
					borderRadius: BorderRadius.only(topRight: Radius.circular(10.0))
					// gradient: LinearGradient(
					// 	begin: Alignment.topCenter,
					// 	end: Alignment.bottomCenter,
					// 	colors: [Colors.white,Colors.white ,_hexToColor(fin)]),
				),
				padding: EdgeInsets.all(20.0),
				child: Column(
					mainAxisAlignment: MainAxisAlignment.center,
					children: < Widget > [
						new Form(
							key: _formKey,
							child: Column(
								children: [
									Image.asset("images/conversation.png", fit: BoxFit.fill, ),
									new Text("Bonjour!,",
										style: GoogleFonts.bubblegumSans(
											textStyle: TextStyle(
												color: Colors.yellow[800],
												letterSpacing: .5,
												fontSize: 25.0,
											)
										)),
									new Text("Ravis de vous revoir",
										style: GoogleFonts.bubblegumSans(
											textStyle: TextStyle(
												color: Colors.yellow[800],
												fontSize: 35.0,
												letterSpacing: .5
											)
										)
									),

									Row(
										children: < Widget > [
											Spacer(flex: 2, ),
											new Text("Reinitialisé? ",
												style: GoogleFonts.alef(
													textStyle: TextStyle(
														color: Colors.white
													)
												)
											),
										],
									),
									new RaisedButton(
										elevation: 12.0,
										textColor: _hexToColor("#124A2C"),
										child: new Text("Connexion", style: TextStyle(fontSize: 17.0)),
										shape: RoundedRectangleBorder(
											borderRadius: new BorderRadius.circular(18.0),
										),
										color: Colors.white,
										onPressed: () {
											_submit();
										},
									),
									new FlatButton(
										textColor: Colors.teal,
										child: Text("Vous possedez deja compte? Connexion"),
										onPressed: _moveTocreerCompte,
									)
								]
							)
						),
					],
				),
			),
		);
	}
}