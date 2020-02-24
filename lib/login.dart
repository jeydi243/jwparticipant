import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:jwparticipant/auth.dart';
import 'package:jwparticipant/home.dart';
// import 'package:flare_flutter/flare_actor.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading/loading.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
// import 'package:loading/indicator/ball_scale_indicator.dart';
// import 'package:loading/indicator/ball_grid_pulse_indicator.dart';
// import 'package:loading/indicator/line_scale_indicator.dart';
// import 'package:loading/indicator/ball_scale_multiple_indicator.dart';
// import 'package:loading/indicator/line_scale_party_indicator.dart';
// import 'package:loading/indicator/ball_beat_indicator.dart';
// import 'package:loading/indicator/line_scale_pulse_out_indicator.dart';
// import 'package:loading/indicator/ball_spin_fade_loader_indicator.dart';


class LoginPage extends StatefulWidget {
	LoginPage({
		this.auth,
		this.move,
		this.onSignedIn
	});
	final BaseAuth auth;
	final VoidCallback onSignedIn;
	final VoidCallback move;
	@override
	_LoginState createState() => _LoginState();
}

class _LoginState extends State < LoginPage > {
	final _formKey = GlobalKey < FormState > ();
	bool _isTrue = true;
	bool _canObscure = false;
	String fin = "#FAD961";
	String _emailOrNom;
	String _password;

	bool _validateandSave() {
		final form = _formKey.currentState;
		if (form.validate()) {
			form.save();
			print("le formulaire est pret");
			print('$_emailOrNom et $_password');
			return true;
		} else {
			print("Erreur dans le formulaire");
			return false;
		}
	}
	void _submit() async {
		if (_validateandSave()) {
			setState(() {
			_isTrue = false;
			  
			});
			try {
				String uid = await widget.auth.signIn(_emailOrNom, _password);
				print("L'utilisateur s'est bien connecté $uid");
				_formKey.currentState.reset();
				setState(() {
				_isTrue = true;
			  
			});
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

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			backgroundColor: Colors.white,
			body: Center(
			  child: new AnimatedContainer(
			  	curve: Curves.fastOutSlowIn,
			  	duration: Duration(seconds: 1),
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
			  						new TextFormField(
			  							onSaved: (value) => _emailOrNom = value,
			  							validator: (value) => value.isEmpty ? "L'email ou nom doit etre renseigné" : null,
			  							decoration: new InputDecoration(
			  								hoverColor: Colors.green,
			  								isDense: true,
			  								prefixIcon: Icon(Icons.email, color: Colors.teal, ),
											  hintText: "Email ou Nom",
											  hasFloatingPlaceholder: true,
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
			  						Row(
			  							children: < Widget > [
			  								Spacer(flex: 2),
			  								new Text("Reinitialisé? ",
			  									style: GoogleFonts.alef(
			  										textStyle: TextStyle(
			  											color: Colors.white
			  										)
			  									)
			  								),
			  							],
			  						),
			  						_isTrue ? new RaisedButton(
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
			  						) : Loading(indicator: BallPulseIndicator(), size: 60.0, color: Colors.teal),
									Row(
										children: <Widget>[
											Spacer(),
											Text("Vous etes nouveau ?"),
											new FlatButton(
			  							textColor: Colors.teal,
			  							child: Text("M'enregistrer"),
			  							onPressed: widget.move,
			  						)
										],
									),
			  						
			  					]
			  				)
			  			),
			  		],
			  	),
			  ),
			),
		);
	}
}