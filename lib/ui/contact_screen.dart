import 'package:flutter/material.dart';
import 'package:projetomega/service/firebase_firestore_service.dart';
import 'package:projetomega/model/contact.dart';
import 'package:projetomega/ui/avatar.dart';

class ContactScreen extends StatefulWidget{
  final Contact contact;

  ContactScreen(this.contact);

  @override
  _ContactScreenState createState() => new _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen>{
  FirebaseFirestoreService db = new FirebaseFirestoreService();

  TextEditingController _nomeController;
  TextEditingController _telefoneController;
  TextEditingController _enderecoController;

  @override
  void initState(){
      super.initState();
      _nomeController = new TextEditingController(text: widget.contact.nome);
      _telefoneController = new TextEditingController(text: widget.contact.telefone);
      _enderecoController = new TextEditingController(text: widget.contact.endereco);
  }

  @override
  Widget build(BuildContext context) {

    var url = 'https://robohash.org/${widget.contact.id}';
    var avatar = new Avatar(url: url, size: 150.0);

    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text('Contato')),
      body: Container(
        margin: EdgeInsets.all(15.0),
        alignment: Alignment.center,
        child: ListView(
          children: <Widget>[
            //avatar vai aqui
            avatar,

            TextField(
              controller: _nomeController,
              decoration: InputDecoration(
                  icon: const Icon(Icons.person),
                  labelText: 'Nome'
              ),
            ),
            TextField(
              controller: _telefoneController,
              decoration: InputDecoration(
                  icon: const Icon(Icons.phone),
                  labelText: 'Telefone'
              ),
            ),
            TextField(
              controller: _enderecoController,
              decoration: InputDecoration(
                  icon: const Icon(Icons.location_on),
                  labelText: 'Endereço'
              ),
            ),
            Padding(padding: new EdgeInsets.all(15.0),),
            RaisedButton(
              child: (widget.contact.id != null ? Text('Salvar') : Text('Salvar')),
              color: (widget.contact.id != null ? Colors.blue : Colors.blue),
              onPressed: (){
                if(widget.contact.id != null){
                  db
                  .updateContact(Contact(widget.contact.id, _nomeController.text, _telefoneController.text, _enderecoController.text))
                      .then((_){
                        Navigator.pop(context);
                  });
                }else{
                  db.createContact(_nomeController.text, _telefoneController.text, _enderecoController.text).then((_){
                    Navigator.pop(context);
                  });
                }
              },
            )
          ],
        )
      ),
    );
  }
}