class CondominioModel{
  late int id;
  late String nome;
  late int regiaoId;

  CondominioModel({
    required this.id,
    required this.nome,
    required this.regiaoId
  });

  CondominioModel.fromJson(Map<String, dynamic> json){
    id = json["id"] ?? 0;
    nome = json["nome"] ?? "";
    regiaoId = json["regiaoId"] ?? 0;
  }
}