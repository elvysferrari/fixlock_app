class ChamadoListModel {
  int? id;
  int? tecnicoId;
  String? tecnico;
  int? dispositivoId;
  String? dispositivo;
  int? condominioId;
  String? condominio;
  String? data;
  String? observacao;
  String? status;
  int? clienteId;
  String? cliente;
  int? regiaoId;
  String? regiao;
  Null? checklists;
  Null? interacoes;
  Null? fotos;

  ChamadoListModel(
      {this.id,
        this.tecnicoId,
        this.tecnico,
        this.dispositivoId,
        this.dispositivo,
        this.condominioId,
        this.condominio,
        this.data,
        this.observacao,
        this.status,
        this.clienteId,
        this.cliente,
        this.regiaoId,
        this.regiao,
        this.checklists,
        this.interacoes,
        this.fotos});

  ChamadoListModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tecnicoId = json['tecnicoId'];
    tecnico = json['tecnico'];
    dispositivoId = json['dispositivoId'];
    dispositivo = json['dispositivo'];
    condominioId = json['condominioId'];
    condominio = json['condominio'];
    data = json['data'];
    observacao = json['observacao'];
    status = json['status'];
    clienteId = json['clienteId'];
    cliente = json['cliente'];
    regiaoId = json['regiaoId'];
    regiao = json['regiao'];
    checklists = json['checklists'];
    interacoes = json['interacoes'];
    fotos = json['fotos'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['tecnicoId'] = tecnicoId;
    data['tecnico'] = tecnico;
    data['dispositivoId'] = dispositivoId;
    data['dispositivo'] = dispositivo;
    data['condominioId'] = condominioId;
    data['condominio'] = condominio;
    data['data'] = data;
    data['observacao'] = observacao;
    data['status'] = status;
    data['clienteId'] = clienteId;
    data['cliente'] = cliente;
    data['regiaoId'] = regiaoId;
    data['regiao'] = regiao;
    data['checklists'] = checklists;
    data['interacoes'] = interacoes;
    data['fotos'] = fotos;
    return data;
  }
}