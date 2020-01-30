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
		this.auth,this.onSignedIn
	});
	final BaseAuth auth;
	final VoidCallback onSignedIn;
	@override
	_LoginState createState() => _LoginState();
}

class _LoginState extends State < LoginPage > {
	final _formKey = GlobalKey < FormState > ();
	String fin ="#FAD961";
	String _email;
	bool _canObscure = true;
	String _nom;
	String _password;
	FormType _formType = FormType.login;
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
				if (_formType == FormType.login) {
					String uid = await widget.auth.signIn(_email, _password);
					print("L'utilisateur s'est bien connecté $uid");
					_formKey.currentState.reset();
					Navigator.of(context).push(_createRoute());
				} else {
					String uid = await widget.auth.signUp(_email, _password,_nom);
					print("L'utilisateur s'est bien enregistré $uid");
					_formKey.currentState.reset();
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
	Color _hexToColor(String code) {
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
	Widget _build2Champ() {
		return Column(
			children: < Widget > [
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
							child: _canObscure ==true ? Text("SHOW"): Text("HIDE"),
							onPressed: (){
								setState(() {
								 _canObscure = _canObscure ? false: true;
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
			],
		);
	}
	Widget _buildLogin() {
		return Column(
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
				_build2Champ(),
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
					child: new Text("Connexion", style: TextStyle(fontSize: 17.0), ),
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
		);
	}
	Widget _buildSignup() {
		return Column(
			mainAxisAlignment: MainAxisAlignment.center,
			children: [
				Image.asset("images/conversation.png", fit: BoxFit.fill),
				Text("Rejoignez-nous!",softWrap: true,
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
				_build2Champ(),
				
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

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			body: new AnimatedContainer(
					height: MediaQuery.of(context).size.height,
					curve: Curves.fastOutSlowIn,
					duration: Duration(seconds: 2),
					alignment: Alignment.center,
					decoration: BoxDecoration(
							color: Colors.white,
							// gradient: LinearGradient(
							// 	begin: Alignment.topCenter,
							// 	end: Alignment.bottomCenter,
							// 	colors: [Colors.white,Colors.white ,_hexToColor(fin)]),
					),
					padding: EdgeInsets.all(20.0),
					child: new Form(
						key: _formKey,
						child: AnimatedSwitcher(
							// switchOutCurve: Curves.fastOutSlowIn,
							duration: const Duration(seconds: 2),
							child: _formType == FormType.login ? _buildLogin() : _buildSignup(),
						)
					),
				),
			
		);
	}
}