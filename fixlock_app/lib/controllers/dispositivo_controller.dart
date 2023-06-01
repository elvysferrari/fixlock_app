import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:fixlock_app/constants/controllers.dart';
import 'package:fixlock_app/widgets/animated_loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:get/get.dart' hide Response;
import '../models/dispositivo_registro_model.dart';
import '../utils/http_service.dart';

class DispositivoController extends GetxController {
  static DispositivoController instance = Get.find();

  TextEditingController senhaMaster = TextEditingController();
  TextEditingController novaSenha = TextEditingController();

  BluetoothConnection? _connection;

  Rx<BluetoothConnection?> get connection => _connection.obs;

  String serv = "0000ffe0-0000-1000-8000-00805f9b34fb";
  String cara = "0000ffe1-0000-1000-8000-00805f9b34fb";

  final _http = HttpService();

  Future<void> salvaRegistro(DispositivoRegistroModel registro) async {
    Response response;
    try {
      response = await _http.postRequest('/dispositivo/adicionar-log', registro.toJson());

      if(response.statusCode == 200){

      }else
      {
        //se não tiver conexão com internet salvar no banco local
      }
    } catch (e) {
    }
  }


  Future<void> connect(String deviceId) async {
    var enable = await FlutterBluetoothSerial.instance.isEnabled;
    if(!enable!){
      await FlutterBluetoothSerial.instance.requestEnable();
    }
    try{
      if(_connection == null) {
        _connection = await BluetoothConnection.toAddress(deviceId).timeout(const Duration(seconds: 10));
        Get.snackbar("Sucesso", "Dispositivo conectado", snackPosition: SnackPosition.BOTTOM, duration: const Duration(seconds: 4));
      }else{
        Get.snackbar("Sucesso", "Dispositivo conectado", snackPosition: SnackPosition.BOTTOM, duration: const Duration(seconds: 4));
      }
    }
    catch(exception){
      //Get.snackbar("Falha", "Não foi possível conectar", snackPosition: SnackPosition.BOTTOM, duration: const Duration(seconds: 4));
      //await disconnect();
    }
  }

  Future<void> disconnect() async {
    try {
      _connection?.finish();
      _connection = null;
      await FlutterBluetoothSerial.instance.requestDisable();
      Get.snackbar("Sucesso", "Dispositivo desconectado", snackPosition: SnackPosition.BOTTOM, duration: const Duration(seconds: 4));
    } on Exception catch (e, _) {
      Get.snackbar("Falha", "Não foi possível desconectar", snackPosition: SnackPosition.BOTTOM, duration: const Duration(seconds: 4));
    } finally {
      _connection = null;
    }
  }

  Future<void> abrir(String deviceId) async {
    String? codCliente = "*${userController.userModel.value.clienteCodigo}a";

    if(_connection == null) {
      Get.snackbar("Conexão perdida", "Reconectando Dispositivo...", snackPosition: SnackPosition.BOTTOM, duration: const Duration(seconds: 4));
      await connect(deviceId);
    }else {
      if (_connection!.isConnected) {
        try {
          List<String> commands = [codCliente[0], codCliente[1], codCliente[2], codCliente[3], codCliente[4], codCliente[5]];

          //commands = ['*', 'f', 'b', 'd', 't', 'a'];
          Future.forEach<String>(commands, (command) async {
            var list = Uint8List.fromList(utf8.encode(command));
            _connection!.output.add(list);
            await _connection!.output.allSent;
            print(command);
            await Future.delayed(const Duration(milliseconds: 200));

          });


        } catch (exp) {
          _connection = null;
          await FlutterBluetoothSerial.instance.requestDisable();
          Get.snackbar("Conexão perdida", "Reconectando Dispositivo...",
              snackPosition: SnackPosition.BOTTOM,
              duration: const Duration(seconds: 4));
          await connect(deviceId);
          await abrir(deviceId);
        }
      } else {
        _connection = null;
        await FlutterBluetoothSerial.instance.requestDisable();
        Get.snackbar("Conexão perdida", "Reconectando Dispositivo...",
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 4));
        await connect(deviceId);
        await abrir(deviceId);
      }
    }
  }


  Future<void> ligarEnergia(String deviceId) async {

    String? codCliente = "*${userController.userModel.value.clienteCodigo}r";

    if(_connection == null) {
      Get.snackbar("Conexão perdida", "Reconectando Dispositivo...", snackPosition: SnackPosition.BOTTOM, duration: const Duration(seconds: 4));
      await connect(deviceId);
    }else {
      if (_connection!.isConnected) {
        try {
          List<String> commands = [codCliente[0], codCliente[1], codCliente[2], codCliente[3], codCliente[4], codCliente[5]];

          //commands = ['*', 'f', 'b', 'd', 't', 'r'];
          Future.forEach<String>(commands, (command) async {
            var list = Uint8List.fromList(utf8.encode(command));
            _connection!.output.add(list);
            await _connection!.output.allSent;
            print(command);
            await Future.delayed(const Duration(milliseconds: 200));

          });
        } catch (exp) {
          _connection = null;
          await FlutterBluetoothSerial.instance.requestDisable();
          Get.snackbar("Conexão perdida", "Reconectando Dispositivo...",
              snackPosition: SnackPosition.BOTTOM,
              duration: const Duration(seconds: 4));
          await connect(deviceId);
          await ligarEnergia(deviceId);
        }
      } else {
        _connection = null;
        await FlutterBluetoothSerial.instance.requestDisable();
        Get.snackbar("Conexão perdida", "Reconectando Dispositivo...",
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 4));
        await connect(deviceId);
        await ligarEnergia(deviceId);
      }
    }
  }

  Future<void> desligarEnergia(String deviceId) async {

    String? codCliente = "*${userController.userModel.value.clienteCodigo}d";

    if(_connection == null) {
      Get.snackbar("Conexão perdida", "Reconectando Dispositivo...", snackPosition: SnackPosition.BOTTOM, duration: const Duration(seconds: 4));
      await connect(deviceId);
    }else {
      if (_connection!.isConnected) {
        try {
          List<String> commands = [codCliente[0], codCliente[1], codCliente[2], codCliente[3], codCliente[4], codCliente[5]];

          //commands = ['*', 'f', 'b', 'd', 't', 'd'];
          Future.forEach<String>(commands, (command) async {
            var list = Uint8List.fromList(utf8.encode(command));
            _connection!.output.add(list);
            await _connection!.output.allSent;
            print(command);
            await Future.delayed(const Duration(milliseconds: 200));

          });
        } catch (exp) {
          _connection = null;
          await FlutterBluetoothSerial.instance.requestDisable();
          Get.snackbar("Conexão perdida", "Reconectando Dispositivo...",
              snackPosition: SnackPosition.BOTTOM,
              duration: const Duration(seconds: 4));
          await connect(deviceId);
          await desligarEnergia(deviceId);
        }
      } else {
        _connection = null;
        await FlutterBluetoothSerial.instance.requestDisable();
        Get.snackbar("Conexão perdida", "Reconectando Dispositivo...",
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 4));
        await connect(deviceId);
        await desligarEnergia(deviceId);
      }
    }
  }

  Future<void> alterarSenha(String deviceId) async {
    String? codCliente = "*${userController.userModel.value.clienteCodigo}n${novaSenha.text}";

    if(_connection == null) {
      Get.snackbar("Conexão perdida", "Reconectando Dispositivo...", snackPosition: SnackPosition.BOTTOM, duration: const Duration(seconds: 4));
      await connect(deviceId);
    }else {
      if (_connection!.isConnected) {
        try {
          List<String> commands = [codCliente[0], codCliente[1], codCliente[2], codCliente[3], codCliente[4], codCliente[5],
            codCliente[6], codCliente[7], codCliente[8], codCliente[9]];

          //commands = ['*', 'f', 'b', 'd', 't', 'n', '1', '2', '3', '4'];
          Future.forEach<String>(commands, (command) async {
            var list = Uint8List.fromList(utf8.encode(command));
            _connection!.output.add(list);
            await _connection!.output.allSent;
            print(command);
            await Future.delayed(const Duration(milliseconds: 200));

          });
          senhaMaster.clear();
          novaSenha.clear();
          Get.back();
        } catch (exp) {
          _connection = null;
          await FlutterBluetoothSerial.instance.requestDisable();
          Get.snackbar("Conexão perdida", "Reconectando Dispositivo...",
              snackPosition: SnackPosition.BOTTOM,
              duration: const Duration(seconds: 4));
          await connect(deviceId);
          await alterarSenha(deviceId);
        }
      } else {
        _connection = null;
        await FlutterBluetoothSerial.instance.requestDisable();
        Get.snackbar("Conexão perdida", "Reconectando Dispositivo...",
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 4));
        await connect(deviceId);
        await alterarSenha(deviceId);
      }
    }
  }
}
