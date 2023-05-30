class DispositivoModel{
  late int id;
  late String descricao;
  late String serial;
  late int condominioId;

  DispositivoModel({
    required this.id,
    required this.descricao,
    required this.serial,
    required this.condominioId
  });

  DispositivoModel.fromJson(Map<String, dynamic> json){
    id = json["id"] ?? 0;
    descricao = json["descricao"] ?? "";
    serial = json["serial"] ?? "";
    condominioId = json["condominioId"] ?? 0;
  }
}
