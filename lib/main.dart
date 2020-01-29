import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_splash_screen/flare_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:jwparticipant/login.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
	@override
	Widget build(BuildContext context) {
		return MaterialApp(
			initialRoute: "/login",
			debugShowCheckedModeBanner: false,
			routes: < String, WidgetBuilder > {
				'/': (BuildContext context) {
					return MyHomePage();
				},
				'/login': (BuildContext context) {
					return LoginPage();
				}
			},
		);
	}
}

class MyHomePage extends StatefulWidget {
	@override
	_MyHomePageState createState() {
		return _MyHomePageState();
	}
}

class _MyHomePageState extends State < MyHomePage > {
	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(title: Text('Baby Name Votes')),
			body: _buildBody(context),
		);
	}

	Widget _buildBody(BuildContext context) {
		return Container(
			child: Column(
				children: [
					StreamBuilder < QuerySnapshot > (
						stream: Firestore.instance.collection('baby').snapshots(),
						builder: (context, snapshot) {
							if (!snapshot.hasData) return LinearProgressIndicator();
							return _buildList(context, snapshot.data.documents);
						},
					),
					RaisedButton(
						color: Colors.white,
						onPressed: () {
							print('le Button est appuyé');
							Navigator.pushNamed(context, '/login');

						},
						child: Text(
							'Go',
						),
					),
				],
			)
		);
	}

	Widget _buildList(BuildContext context, List < DocumentSnapshot > snapshot) {
		return ListView(
			shrinkWrap: true,
			padding: const EdgeInsets.only(top: 20.0),
				children: snapshot.map((data) => _buildListItem(context, data)).toList(),
		);
	}

	Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
		final record = Record.fromSnapshot(data);

		return Padding(
			key: ValueKey(record.name),
			padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
				child: Container(
					decoration: BoxDecoration(
						border: Border.all(color: Colors.grey),
						borderRadius: BorderRadius.circular(5.0),
					),
					child: ListTile(
						title: Text(record.name),
						trailing: Text(record.votes.toString()),
						onTap: () => record.reference.updateData({
							'votes': FieldValue.increment(1)
						}), ),
				),
		);
	}
}

class Record {

	final String name;
	final int votes;
	final DocumentReference reference;

	Record.fromMap(Map < String, dynamic > map, {
			this.reference
		}): assert(map['name'] != null),
		assert(map['votes'] != null),
		name = map['name'],
		votes = map['votes'];

	Record.fromSnapshot(DocumentSnapshot snapshot): this.fromMap(snapshot.data, reference: snapshot.reference);

	@override
	String toString() => "Record<$name:$votes>";
}