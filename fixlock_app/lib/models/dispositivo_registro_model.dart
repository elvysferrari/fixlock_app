class DispositivoRegistroModel{
  late String? descricao;
  late int? dispositivoId;
  late int? tecnicoId;
  late DateTime? data;


  Map<String, dynamic> toJson() => {
    "descricao": descricao,
    "dispositivoId": dispositivoId,
    "tecnicoId": tecnicoId,
    "data": data
  };

  DispositivoRegistroModel({
    required this.descricao,
    required this.dispositivoId,
    required this.tecnicoId,
    required this.data
  });
}

