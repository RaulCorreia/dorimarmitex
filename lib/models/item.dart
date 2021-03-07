import 'package:Dorimarmitex/database/database_creator.dart';

class Item {
  int id;
  String nome;
  int tipo;
  bool selec;
  bool oculto;

  Item({this.id, this.nome, this.tipo, this.selec, this.oculto});

  Item.fromJson(Map<String, dynamic> json) {
    id = json[DatabaseCreator.id];
    nome = json[DatabaseCreator.nome];
    tipo = json[DatabaseCreator.tipo];
    selec = json[DatabaseCreator.selec] == 1;
    oculto = json[DatabaseCreator.oculto] == 1;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[DatabaseCreator.id] = this.id;
    data[DatabaseCreator.nome] = this.nome;
    data[DatabaseCreator.tipo] = this.tipo;
    data[DatabaseCreator.selec] = this.selec ? 1 : 0;
    data[DatabaseCreator.oculto] = this.oculto ? 1 : 0;
    return data;
  }
}
