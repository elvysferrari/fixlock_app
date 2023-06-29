class ChecklistOriginalModel {
  int? id;
  int? checklistTipoId;
  String? checklistTipo;
  String? descricao;
  bool? ativo;
  int? ordemNumero;
  bool? flCabecalho;
  bool? flObservacao;

  ChecklistOriginalModel(
      {this.id,
        this.checklistTipoId,
        this.checklistTipo,
        this.descricao,
        this.ativo,
        this.ordemNumero,
        this.flCabecalho,
        this.flObservacao});

  ChecklistOriginalModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    checklistTipoId = json['checklistTipoId'];
    checklistTipo = json['checklistTipo'];
    descricao = json['descricao'];
    ativo = json['ativo'];
    ordemNumero = json['ordemNumero'];
    flObservacao = json['flObservacao'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['id'] =id;
    data['checklistTipoId'] =checklistTipoId;
    data['checklistTipo'] =checklistTipo;
    data['descricao'] =descricao;
    data['ativo'] =ativo;
    data['ordemNumero'] =ordemNumero;
    return data;
  }
}