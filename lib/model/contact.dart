class Contact {
  String _id;
  String _nome;
  String _telefone;
  String _endereco;

  Contact(this._id, this._nome, this._telefone,this._endereco);

  Contact.map(dynamic obj){
    this._id = obj['id'];
    this._nome = obj['nome'];
    this._telefone = obj['telefone'];
    this._endereco = obj['endereco'];
  }

  String get id => _id;
  String get nome => _nome;
  String get endereco => _endereco;
  String get telefone => _telefone;

  Map<String, dynamic> toMap(){
    var map = new Map<String, dynamic>();

    if(_id != null){
      map['id'] = _id;
    }
    map['nome'] = _nome;
    map['telefone'] = _telefone;
    map['endereco'] = _endereco;

    return map;
  }

  Contact.fromMap(Map<String, dynamic> map){
    this._id = map['id'];
    this._nome = map['nome'];
    this._telefone = map['telefone'];
    this._endereco = map['endereco'];
  }
}