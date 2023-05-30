class RegiaoModel{
  late int id;
  late String nome;

  RegiaoModel({
    required this.id,
    required this.nome
  });

  RegiaoModel.fromJson(Map<String, dynamic> json){
    id = json["id"] ?? 0;
    nome = json["nome"] ?? "";
  }

}