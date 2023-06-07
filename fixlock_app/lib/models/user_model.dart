class UserModel {

  late int? id;
  late String? nome;
  late int? clienteId;
  late String? clienteNome;
  late String? clienteCodigo;
  late String? clienteLogo;
  late String? clientePassword;
  late String? password;
  late int? smartphoneId;
  late bool? ativo;

  UserModel({this.id, this.nome});

  Map<String, dynamic> toJson() => {
    "id": id,
    "nome": nome,
    "password": password,
    "clienteLogo": clienteLogo,
    "clienteNome": clienteNome
  };

  UserModel.fromJson(Map<String, dynamic> json){
    id = json["id"] ?? 0;
    nome = json["nome"] ?? "";
    clienteId = json["clienteId"] ?? 0;
    clienteNome = json["clienteNome"] ?? "";
    clienteCodigo = json["clienteCodigo"] ?? "";
    clienteLogo = json["clienteLogo"] ?? "";
    clientePassword = json["clientePassword"] ?? "";
    password = json["password"] ?? "";
    smartphoneId = json["smartphoneId"] ?? 0;
    ativo = json["ativo"] ?? false;
  }
}
