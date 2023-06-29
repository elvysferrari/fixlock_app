class ChamadoModel {
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
  List<Checklists>? checklists;
  List<Interacoes>? interacoes;
  List<void>? fotos;

  ChamadoModel(
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

  ChamadoModel.fromJson(Map<String, dynamic> json) {
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
    if (json['checklists'] != null) {
      checklists = <Checklists>[];
      json['checklists'].forEach((v) {
        checklists!.add(Checklists.fromJson(v));
      });
    }
    if (json['interacoes'] != null) {
      interacoes = <Interacoes>[];
      json['interacoes'].forEach((v) {
        interacoes!.add(Interacoes.fromJson(v));
      });
    }
    if (json['fotos'] != null) {
      fotos = <Null>[];
      json['fotos'].forEach((v) {

      });
    }
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
    if (checklists != null) {
      data['checklists'] = checklists!.map((v) => v.toJson()).toList();
    }
    if (interacoes != null) {
      data['interacoes'] = interacoes!.map((v) => v.toJson()).toList();
    }
    if (fotos != null) {

    }
    return data;
  }

  Map<String, dynamic> toSaveJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['tecnicoId'] = tecnicoId;
    data['dispositivoId'] = dispositivoId;
    data['condominioId'] = condominioId;
    data['observacao'] = observacao;

    if (checklists != null) {
      data['checklists'] = checklists!.map((v) => v.toSaveJson()).toList();
    }

    return data;
  }
}

class Checklists {
  int? id;
  int? chamadoId;
  int? valor;
  String? observacao;
  int? checklistId;
  String? descricao;
  int? ordemNumero;
  bool? flObservacao;

  Checklists(
      {this.id,
        this.chamadoId,
        this.valor,
        this.observacao,
        this.checklistId,
        this.descricao,
        this.ordemNumero,
        this.flObservacao});

  Checklists.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    chamadoId = json['chamadoId'] ?? 0;
    valor = json['valor'] ?? false;
    observacao = json['observacao'] ?? "";
    checklistId = json['checklistId'] ?? 0;
    descricao = json['descricao'] ?? "";
    ordemNumero = json['ordemNumero'] ?? 0;
    flObservacao = json['flObservacao'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['chamadoId'] = chamadoId;
    data['valor'] = valor;
    data['observacao'] = observacao;
    data['checklistId'] = checklistId;
    data['descricao'] = descricao;
    data['ordemNumero'] = ordemNumero;
    return data;
  }

  Map<String, dynamic> toSaveJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['checklistId'] = checklistId;
    data['valor'] = valor;
    data['observacao'] = observacao;
    data['ordemNumero'] = ordemNumero;
    data['flCabecalho'] = true;
    return data;
  }

}

class Interacoes {
  int? id;
  int? chamadoId;
  String? usuarioLogin;
  String? data;
  String? observacao;
  int? statusId;
  String? status;

  Interacoes(
      {this.id,
        this.chamadoId,
        this.usuarioLogin,
        this.data,
        this.observacao,
        this.statusId,
        this.status});

  Interacoes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    chamadoId = json['chamadoId'];
    usuarioLogin = json['usuarioLogin'];
    data = json['data'];
    observacao = json['observacao'];
    statusId = json['statusId'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['chamadoId'] = chamadoId;
    data['usuarioLogin'] = usuarioLogin;
    data['data'] = data;
    data['observacao'] = observacao;
    data['statusId'] = statusId;
    data['status'] = status;
    return data;
  }
}