import 'package:firebase_auth/firebase_auth.dart';

class Assemble{
  FirebaseUser owner;
  String nom;
  List assistances;
//   List<FirebaseUser> users;

Assemble({this.owner, this.nom});

Assemble.fromMap(Map snapshot,FirebaseUser owner) :
    owner = owner ?? '',
    nom = snapshot['nom'] ?? 'Lushi-',
	assistances = snapshot['assistances'];
    // users = snapshot['users'] ?? '';


toJson() {
    return {
      "owner": owner,
      "nom": nom,
      "assistances": assistances,
    };
  }
}