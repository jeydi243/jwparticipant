import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class Signup extends StatefulWidget {
  Signup({Key key}) : super(key: key);

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
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