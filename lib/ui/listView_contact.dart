import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:projetomega/service/firebase_firestore_service.dart';

import 'package:projetomega/model/contact.dart';
import 'package:projetomega/ui/contact_screen.dart';

class ListViewContact extends StatefulWidget{
  @override
  _ListViewContactState createState() => new _ListViewContactState();
}

class _ListViewContactState extends State<ListViewContact>{
  List<Contact> items;

  FirebaseFirestoreService db = new FirebaseFirestoreService();

  StreamSubscription<QuerySnapshot> contactSub;

  @override

  void initState(){
    super.initState();

    items = new List();

    contactSub?.cancel();
    contactSub = db.getContactList().listen((QuerySnapshot snapshot){
      final List<Contact> contact = snapshot.documents
      .map((documentSnapshot) => Contact.fromMap(documentSnapshot.data)).toList();

      setState(() {
        this.items = contact;
      });


    });

  }

  void dispose(){
    contactSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      title: 'Projeto Mega',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Contatos'),
        ),
        body:Center(
          child: ListView.builder(
            itemCount: items.length,
            padding: const EdgeInsets.all(20.0),
            itemBuilder: (context, position){
              return Column(
                children: <Widget>[
                  Divider(height: 5.0),
                  ListTile(
                    title: Text(
                        '${items[position].nome}',
                      style: TextStyle(fontSize: 20.0),
                   ),
                    trailing: IconButton(icon: const Icon(Icons.delete, size: 30.0, color: Colors.red,), onPressed: ()=> _deleteContact(context, items[position], position)),
                    onTap: ()=> _navigateToContact(context, items[position]),
                  ),

                ],
              );
            }),
        ),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.person_add),
            onPressed: ()=> _createNewContact(context)),
      )
    );
  }


  void _createNewContact(BuildContext context) async{
    Contact contactFun = new Contact(null, '', '', '');

    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ContactScreen(contactFun)),
    );
  }


  void _navigateToContact(BuildContext context, Contact contact) async{

    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ContactScreen(contact)),
    );
  }

  void _deleteContact(BuildContext context, Contact contact, int position) async{
    db.deleteContact(contact.id).then((contact){
      setState(){
        items.removeAt(position);
      }
    });
  }
}

























