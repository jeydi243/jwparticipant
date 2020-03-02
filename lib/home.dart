// import 'dart:async';
import 'package:vibration/vibration.dart';
// import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jwparticipant/auth.dart';
import 'package:jwparticipant/record.dart';

import 'chart.dart';

class HomePage extends StatefulWidget {

	HomePage({
		this.onSignedOut,
		this.auth
	});
	final VoidCallback onSignedOut;
	final BaseAuth auth;

	@override
	_HomePageState createState() {
		return _HomePageState();
	}
}

class _HomePageState extends State < HomePage > {
	final format = DateFormat("dd-MM-yyyy");
	String datee = DateTime.now().toLocal().toString();
	void _signOut() async {
		try {
			print("la methode est appelé");
			await widget.auth.signOut();
			print("Ca passe");
			//   Navigator.of(context).pushNamed("/login");
			widget.onSignedOut();
		} catch (e) {
			print(e);
		}

	}
	@override
	Widget build(BuildContext context) {
		return Scaffold(
			resizeToAvoidBottomInset: false,
			backgroundColor: Colors.grey[300],
			// appBar: AppBar(
			// 	centerTitle: true,
			// 	title: Text('Accueil'),
			// 	backgroundColor: Colors.teal,
			// ),
			body: SafeArea(
				child: Center(
					child: Container(
						padding: EdgeInsets.all(15.0),
						child: Column(
							mainAxisSize: MainAxisSize.max,
							mainAxisAlignment: MainAxisAlignment.spaceBetween,
							children: < Widget > [
								Container(
									child: BarChartSample1(),
								),

								ConstrainedBox(
									constraints: BoxConstraints(
										minWidth: 300,
										maxWidth: double.infinity,
										minHeight: 300,
										maxHeight: double.infinity,
									),
									child: Container(
										padding: EdgeInsets.only(left: 25.0, right: 25.0),
										decoration: BoxDecoration(
											color: Colors.grey[300],
											borderRadius: BorderRadius.all(Radius.circular(40)),
											boxShadow: [
												BoxShadow(
													color: Colors.white,
													offset: Offset(-10.0, -10.0),
													blurRadius: 10.0,
													spreadRadius: 1.0
												),
												BoxShadow(
													color: Colors.grey[500],
													offset: Offset(10.0, 10.0),
													blurRadius: 10.0,
													spreadRadius: 1.0
												)
											]
										),
										child: IntrinsicWidth(
											child: Column(
												mainAxisSize: MainAxisSize.max,
												mainAxisAlignment: MainAxisAlignment.spaceBetween,
												children: < Widget > [
													FlatButton(
														onPressed: () {
															DatePicker.showDatePicker(
																context,
																showTitleActions: true,
																minTime: DateTime(2018, 3, 5),
																maxTime: DateTime(2019, 6, 7),
																onChanged: (date) {
																	Vibration.vibrate();
																	print('change $date');
																}, onConfirm: (date) {
																	print('confirm $date');
																}, currentTime: DateTime.now(), locale: LocaleType.fr);
														},
														child: Text(
															'CHOISIR LA DATE',
															style: TextStyle(
																color: Colors.blue
															),
														)
													),
													Text('Date: ${datee}'),
													TextField(
														textInputAction: TextInputAction.send,
														cursorColor: Colors.teal,
														
														decoration: InputDecoration(
															hintText: "Nombre d'assistant",
															hintStyle: TextStyle(
																
															)
														),
													),
													SizedBox(
														child: FittedBox(
															fit: BoxFit.fill,
															child: FlatButton(
																onPressed: () {},
																color: Colors.teal,
																child: Text("Envoyer", style: TextStyle(
																	color: Colors.white,
																	fontSize: 20
																))
															),
														)
													),
												],
											),
										),
									),
								),
							],
						),
					),
				),
			),
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