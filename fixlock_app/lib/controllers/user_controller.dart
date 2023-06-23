import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:fixlock_app/models/condominio_model.dart';
import 'package:fixlock_app/models/dispositivo_model.dart';
import 'package:fixlock_app/models/dispositivo_registro_model.dart';
import 'package:fixlock_app/models/regiao_model.dart';
import 'package:fixlock_app/screens/authentication/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart' hide Response;
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/controllers.dart';
import '../models/geolocation_model.dart';
import '../models/user_model.dart';
import '../screens/home/initial_screen.dart';
import '../utils/http_service.dart';

class UserController extends GetxController {
  static UserController instance = Get.find();
  final _http = HttpService();
  //RxBool isLoggedIn = false.obs;

  TextEditingController id = TextEditingController();
  TextEditingController password = TextEditingController();

  Rx<UserModel> userModel = UserModel().obs;
  Rx<GeoLocationModel> geoLocationModel = GeoLocationModel().obs;

  Future<void> signIn() async {
    final prefs = await SharedPreferences.getInstance();

    await _http.postRequest('/usuario/tecnico-login', {
      'id': id.value.text,
      'password': password.value.text,
    }).then((response) async {
      if(response.statusCode == 200){
        userModel.value = UserModel.fromJson(response.data["tecnico"]);
        await prefs.remove("TOKEN");
        await prefs.remove("tecnico");

        await prefs.setString("TOKEN", "${response.data["token"]}");
        await prefs.setString("tecnico", jsonEncode(userModel.value));

        Get.snackbar('Sucesso!',
          "Login efetuado com sucesso!",
        );

        await importaDadosTecnico();

        //isLoggedIn.value = true;
        _clearControllers();
      }
    }).catchError((error) async {
      if(error.toString().contains("404")) {
        Get.snackbar('Erro!',
          "Id ou Senha Inválidos!",
        );
      }else{
        var jsonTecnico = await prefs.getString("tecnico");
        if (jsonTecnico != null && jsonTecnico != "") {
          var tecnicoDecode = UserModel.fromJson(jsonDecode(jsonTecnico));
          if(tecnicoDecode.id.toString() == id.value.text && tecnicoDecode.password == password.value.text) {
            userModel.value = tecnicoDecode;
            dbController.getRegiao();
            dbController.getCondominios();
            dbController.getDispositivos();

            appController.offLineMode = true;
          }else{
            Get.snackbar('Erro!',
              "Id ou Senha Inválidos!",
            );
          }
        }else{
          Get.snackbar('Erro!',
            "Você deve estar conectado a primeira vez na internet!",
          );
        }
      }
    });
  }

  importaDadosTecnico() async {
    int id = userModel.value.id!;
    await _http.getRequest('/tecnico/importa-dados-tecnico/$id').then((response) {if(response.statusCode == 200){
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

    }}).catchError((onError) {
      dbController.getRegiao();
      dbController.getCondominios();
      dbController.getDispositivos();
      appController.offLineMode = true;
    });

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

        importaDadosTecnico();
        appController.isLoginWidgetDisplayed.value = false;
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

  Future<bool> alterarSenha(String novaSenha) async {

    Response response;
    try {
      response = await _http.postRequest('/usuario/tecnico-alterar-senha', {
        'id': this.userModel.value.id,
        'password': novaSenha
      });

      if(response.statusCode == 200){
        if(response.data["successful"] == false) {
          Get.snackbar('Erro!',
            "${response.data["message"]}",
          );
          return Future.value(false);
        }else{
          return Future.value(true);
        }
      }else{
        return Future.value(false);
      }
    } catch (e) {
      Get.snackbar('Erro!',
        "${e.toString()}!",
      );
      return Future.value(false);
    }
  }

  Future<void> signOut() async {
    userModel.value = UserModel();

    Get.off(() => AuthenticationScreen());

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
