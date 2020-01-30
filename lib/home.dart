import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jwparticipant/auth.dart';
import 'package:jwparticipant/record.dart';


class MyHomePage extends StatefulWidget {

	MyHomePage({
		this.onSignedOut,this.auth
	});
	final VoidCallback onSignedOut;
	final BaseAuth auth;

	@override
	_MyHomePageState createState() {
		return _MyHomePageState();
	}
}

class _MyHomePageState extends State < MyHomePage > {
	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(title: Text('Accueil')),
			body: _buildBody(context),
		);
	}

	Widget _buildBody(BuildContext context) {
		return AnimatedContainer(
			duration: Duration(seconds: 2),
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