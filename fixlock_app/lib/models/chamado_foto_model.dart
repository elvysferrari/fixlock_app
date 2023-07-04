import 'package:image_picker/image_picker.dart';

class ChamadoFotoModel{
  late int id;
  late int chamadoId;
  late String? data;
  late String observacao;
  late bool flAntes;
  late String celPath = "";
  late XFile foto;

  late int index;
  late String? nome;

  ChamadoFotoModel(this.id, this.chamadoId, this.data, this.observacao, this.flAntes, this.celPath, this.foto, this.index, this.nome);

  ChamadoFotoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    chamadoId= json['chamadoId'];
    data = json['data'];
    observacao = json['observacao'];
    flAntes = json['flAntes'];
    celPath = "";
    nome = json["nome"];
  }
}