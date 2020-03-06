import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class Assemble {
	FirebaseUser owner;
	String nom;
	List assistances;
	//   List<FirebaseUser> users;

	Assemble({
		this.owner,
		this.nom
	});
	factory Assemble.fromFirestore(DocumentSnapshot snap) {
		Map data = snap.data;
		return Assemble(
			nom: data['nom']?? '',
			owner: data["owner"]?? ''
		);
	}

	Assemble.fromMap(Map snapshot, FirebaseUser owner):
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