class ChamadoNotificacaoPush{
  late int? id;
  late int? usuarioId;

  ChamadoNotificacaoPush({this.id, this.usuarioId});


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['usuarioId'] = usuarioId;

    return data;
  }
}