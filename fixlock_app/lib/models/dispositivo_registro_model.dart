class DispositivoRegistroModel{
  late String? descricao;
  late int? dispositivoId;
  late int? tecnicoId;
  late String? data;


  Map<String, dynamic> toJson() => {
    "descricao": descricao,
    "dispositivoId": dispositivoId,
    "tecnicoId": tecnicoId,
    "data": data
  };

  DispositivoRegistroModel.fromJson(Map<String, dynamic> json){
    descricao = json["descricao"] ?? "";
    dispositivoId = json["dispositivoId"] ?? 0;
    tecnicoId = json["tecnicoId"] ?? 0;
    data = json["data"] ?? "";
  }

  DispositivoRegistroModel({
    required this.descricao,
    required this.dispositivoId,
    required this.tecnicoId,
    required this.data
  });
}

