import 'package:firebase_auth/firebase_auth.dart';

abstract class BaseAuth {
	Future < String > signIn(String email, String password);
	Future < String > signUp(String email, String password,String nom);
    Future < String > currentUser();
	Future < String > signOut();

}
class Auth implements BaseAuth {
	Future < String > signIn(String email, String password) async {
		FirebaseUser user = (await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password)).user;
		return user.uid;
	}
	Future < String > signUp(String email, String password,String nom) async {
		FirebaseUser user = (await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password)).user;
		return user.uid;
	}
  Future <String> signOut() async {
		return "us";
	}
  Future < String > currentUser()async{
    FirebaseUser user = await  FirebaseAuth.instance.currentUser();
    return user.uid;
  }
}