import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projetomega/model/contact.dart';

final CollectionReference contactCollection = Firestore.instance.collection('contatos');

class FirebaseFirestoreService {
  static final FirebaseFirestoreService _instance = new FirebaseFirestoreService
      .internal();

  factory FirebaseFirestoreService() => _instance;

  FirebaseFirestoreService.internal();

  Future<Contact> createContact(String nome, String telefone, String endereco) async {
    final TransactionHandler createTransaction = (Transaction tx) async {
      final DocumentSnapshot ds = await tx.get(contactCollection.document());

      final Contact contact = new Contact(ds.documentID, nome, telefone, endereco);
      final Map<String, dynamic> data = contact.toMap();

      await tx.set(ds.reference, data);

      return data;
    };

    return Firestore.instance.runTransaction(createTransaction).then((mapData) {
      return Contact.fromMap(mapData);
    }).catchError((error) {
      print('error: $error');
      return null;
    });
  }


  Stream<QuerySnapshot> getContactList({int offset, int limit}) {
    Stream<QuerySnapshot> snapshots = contactCollection.orderBy("nome").snapshots();

    if (offset != null) {
      snapshots = snapshots.skip(offset);
    }

    if (limit != null) {
      snapshots = snapshots.take(limit);
    }

    return snapshots;
  }

  Future<dynamic> updateContact(Contact contact) async {
    final TransactionHandler updateTransaction = (Transaction tx) async {
      final DocumentSnapshot ds = await tx.get(contactCollection.document(contact.id));

      await tx.update(ds.reference, {"nome": contact.nome, "endereco": contact.endereco, "telefone": contact.telefone});
      return {'updated': true};
    };

    return Firestore.instance
        .runTransaction(updateTransaction)
        .then((result) => result['updated'])
        .catchError((error) {
      print('errror: $error');
      return false;
    });
  }

  Future<dynamic> deleteContact(String id) async {
    final TransactionHandler deleteTransaction = (Transaction tx) async {
      final DocumentSnapshot ds = await tx.get(contactCollection.document(id));

      await tx.delete(ds.reference);
      return {'deleted': true};
    };

    return Firestore.instance
        .runTransaction(deleteTransaction)
        .then((result) => result['deleted'])
        .catchError((error) {
      print('error: $error');
    });
  }

}