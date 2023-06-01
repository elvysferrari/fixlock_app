import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:fixlock_app/models/condominio_model.dart';
import 'package:fixlock_app/models/dispositivo_model.dart';
import 'package:fixlock_app/models/dispositivo_registro_model.dart';
import 'package:fixlock_app/models/regiao_model.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart' hide Response;
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/controllers.dart';
import '../models/geolocation_model.dart';
import '../models/user_model.dart';
import '../utils/http_service.dart';

class UserController extends GetxController {
  static UserController instance = Get.find();
  final _http = HttpService();
  RxBool isLoggedIn = false.obs;

  TextEditingController id = TextEditingController();
  TextEditingController password = TextEditingController();

  Rx<UserModel> userModel = UserModel().obs;
  Rx<GeoLocationModel> geoLocationModel = GeoLocationModel().obs;

  Future<void> signIn() async {
    final prefs = await SharedPreferences.getInstance();

    Response response;
    try {
      response = await _http.postRequest('/usuario/tecnico-login', {
        'id': id.value.text,
        'password': password.value.text,
      });

      if(response.statusCode == 200){
        userModel.value = UserModel.fromJson(response.data["tecnico"]);
        await prefs.setString("TOKEN", "${response.data["token"]}");
        await prefs.setString("usuario", jsonEncode(userModel.value));

        Get.snackbar('Sucesso!',
          "Login efetuado com sucesso!",
        );

        var primeiroLogin = prefs.getBool("primeiroLogin") ?? true;
        if(primeiroLogin == true) {
          await importaDadosTecnico();
          await prefs.setBool("primeiroLogin", false);
        }else{
          dbController.getRegiao();
          dbController.getCondominios();
          dbController.getDispositivos();
        }

        isLoggedIn.value = true;
        _clearControllers();
      }
    } catch (e) {
      Get.snackbar('Erro!',
        "Id ou Senha Inválidos!",
      );
    }
  }

  importaDadosTecnico() async {
    Response response;

    int id = userModel.value.id!;

    try {

      Get.snackbar('Importação de dados!',
        "Seus dados estão sendo importados.",
      );

      response = await _http.getRequest('/tecnico/importa-dados-tecnico/$id');

      if(response.statusCode == 200){
        var regioes = (response.data["regioes"] as List)
            .map((data) => RegiaoModel.fromJson(data))
            .toList();

        var condominios = (response.data["condominios"] as List)
            .map((data) => CondominioModel.fromJson(data))
            .toList();

        var dipositivos = (response.data["dispositivos"] as List)
            .map((data) => DispositivoModel.fromJson(data))
            .toList();

        dbController.addRegiao(regioes);
        dbController.addCondominio(condominios);
        dbController.addDispositivos(dipositivos);

      }
    } catch (e) {
    }
  }

  Future<void> automaticSignIn(int id, String password) async {
    final prefs = await SharedPreferences.getInstance();

    Response response;
    try {
      response = await _http.postRequest('/usuario/tecnico-login', {
        'id': id,
        'password': password
      });

      if(response.statusCode == 200){
        userModel.value = UserModel.fromJson(response.data["tecnico"]);
        await prefs.setString("TOKEN", "${response.data["token"]}");
        await prefs.setString("usuario", jsonEncode(userModel.value));

        dbController.getRegiao();
        dbController.getCondominios();
        dbController.getDispositivos();
      }
    } catch (e) {
    }
  }

  Future<void> signUp() async {
    final prefs = await SharedPreferences.getInstance();

    Response response;
    try {
      response = await _http.postRequest('/usuario/criar-usuario', {
        'login': id.value.text,
        'password': password.value.text
      });

      if(response.statusCode == 200){
        if(response.data["successful"] == false) {
          Get.snackbar('Erro!',
            "${response.data["message"]}",
          );
        }else {
          userModel.value = UserModel.fromJson(response.data["usuario"]);
          await prefs.setString("TOKEN", "${response.data["token"]}");
          Map<String, dynamic> usuario = {'login':id.value.text,'password':password.value.text};
          await prefs.setString("usuario", jsonEncode(usuario));
          Get.snackbar('Sucesso!',
            "Usuário cadastrado com sucesso!",
          );
          _clearControllers();
        }
      }
    } catch (e) {
      Get.snackbar('Erro!',
        "${e.toString()}!",
      );
    }
  }

  Future<void> signOut() async {
    userModel.value = UserModel();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("TOKEN", "");
    await prefs.setString("usuario", "");

    appController.isLoginWidgetDisplayed.value = true;
  }

  _clearControllers() {
    id.clear();
    password.clear();
  }

  String? validaSenha(String text) {
    if (text.isNotEmpty) {
      if(text.length < 1)
        return 'Senha muito curta!';
    }
    return null;
  }

  bool botaoEntrar() {

    if(userController.id.text.isEmpty)
      return false;

    if(userController.password.text.isEmpty)
      return false;

    if(validaSenha(userController.password.text) != null)
      return false;

    return true;
  }

  bool botaoCadastrar() {
    if(userController.id.text.isEmpty)
      return false;

    if(userController.password.text.isEmpty)
      return false;

    if(validaSenha(userController.password.text) != null)
      return false;

    return true;
  }

  getCurrentLocation() async {
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {
          geoLocationModel.value.latitude =position.latitude;
          geoLocationModel.value.longitude =position.longitude;
    });
  }
}
