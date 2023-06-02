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
import 'package:permission_handler/permission_handler.dart';
import '../models/dispositivo_registro_model.dart';
import '../utils/http_service.dart';

class DispositivoController extends GetxController {
  static DispositivoController instance = Get.find();

  TextEditingController senhaMaster = TextEditingController();
  TextEditingController novaSenha = TextEditingController();

  BluetoothConnection? _connection;

  List<PermissionStatus> permissions = [];

  Rx<BluetoothConnection?> get connection => _connection.obs;

  int tentativasConexao = 1;

  String serv = "0000ffe0-0000-1000-8000-00805f9b34fb";
  String cara = "0000ffe1-0000-1000-8000-00805f9b34fb";

  final _http = HttpService();

  Future<bool> verificaPermissao() async {
    PermissionStatus bluetooth = await Permission.bluetooth.request();

    if(!bluetooth.isGranted){
      Get.snackbar("Autorização Bluetooth negada", "Você tem que autorizar pra continuar");
      return false;
    }

    PermissionStatus bluetoothConnect = await Permission.bluetoothConnect.request();
    if(!bluetoothConnect.isGranted){
      Get.snackbar("Autorização Bluetooth negada", "Você tem que autorizar pra continuar");
      return false;
    }

    PermissionStatus localizacao = await Permission.location.request();
    if(!localizacao.isGranted){
      Get.snackbar("Autorização Localização negada", "Você tem que autorizar pra continuar");
      return false;
    }

    PermissionStatus bluetoothScan = await Permission.bluetoothScan.request();
    if(!bluetoothScan.isGranted){
      Get.snackbar("Autorização Bluetooth Scan negada", "Você tem que autorizar pra continuar");
      return false;
    }

    PermissionStatus bluetoothAdvertise = await Permission.bluetoothAdvertise.request();
    if(!bluetoothAdvertise.isGranted){
      Get.snackbar("Autorização Bluetooth Advertise negada", "Você tem que autorizar pra continuar");
      return false;
    }
    return true;

  }

  Future<void> connect(String deviceId, int dispositivoId) async {

    bool permissoesValidas = await verificaPermissao();

    if(permissoesValidas) {
      var enable = await FlutterBluetoothSerial.instance.isEnabled;
      if (!enable!) {
        await FlutterBluetoothSerial.instance.requestEnable();
        salvarLogDispositivo(
            "Requisitou habilitar bluetooth - MAC: $deviceId - Id: $dispositivoId",
            dispositivoId);
      }
      try {
        if (_connection == null) {
          salvarLogDispositivo(
              "Tentando conectar bluetooth - MAC: $deviceId - Id: $dispositivoId",
              dispositivoId);
          print("Tentando conectar: MAC: $deviceId - Id: $dispositivoId");
          _connection = await BluetoothConnection.toAddress(deviceId).timeout(
              const Duration(seconds: 10));
          salvarLogDispositivo(
              "Conectou bluetooth - MAC: $deviceId - Id: $dispositivoId",
              dispositivoId);
          print("Conectou: MAC: $deviceId - Id: $dispositivoId");
          salvarLogDispositivo("Conectou", dispositivoId);
          Get.snackbar("Sucesso", "Dispositivo conectado",
              snackPosition: SnackPosition.BOTTOM,
              duration: const Duration(seconds: 4));
          tentativasConexao = 0;
        } else {
          print("Já conectado: MAC: $deviceId - Id: $dispositivoId");
          salvarLogDispositivo("Conectou MAC: $deviceId", dispositivoId);
          Get.snackbar("Sucesso", "Dispositivo conectado",
              snackPosition: SnackPosition.BOTTOM,
              duration: const Duration(seconds: 4));
          tentativasConexao = 0;
        }
      }
      catch (exception) {
        salvarLogDispositivo(
            "Erro conectar bluetooth - MAC: $deviceId - Id: $dispositivoId - Erro: ${exception
                .toString()}", dispositivoId);
        print("Falha ao conectar: MAC: $deviceId - Id: $dispositivoId");
        salvarLogDispositivo("Falha ao conectar", dispositivoId);
        if (tentativasConexao <= 3) {
          tentativasConexao++;
          Get.snackbar("Não foi possível Conectar",
              "Reconectando, tentativa: ${tentativasConexao - 1} de 3",
              snackPosition: SnackPosition.BOTTOM,
              duration: const Duration(seconds: 4));
          await connect(deviceId, dispositivoId);
        } else {
          print("Falhou 3x: MAC: $deviceId - Id: $dispositivoId");
          falhouConexao();
        }
      }
    }
  }

  void falhouConexao(){
    Get.snackbar("Falha ao conectar", "Certifique-se que o dispositivo esta correto", snackPosition: SnackPosition.BOTTOM, duration: const Duration(seconds: 4));
    tentativasConexao = 0;
  }

  Future<void> disconnect(int dispositivoId) async {
    try {
      _connection?.finish();
      _connection = null;
      await FlutterBluetoothSerial.instance.requestDisable();
      salvarLogDispositivo("Desconectou", dispositivoId);
      Get.snackbar("Sucesso", "Dispositivo desconectado", snackPosition: SnackPosition.BOTTOM, duration: const Duration(seconds: 4));
    } on Exception catch (e, _) {
      Get.snackbar("Falha", "Não foi possível desconectar", snackPosition: SnackPosition.BOTTOM, duration: const Duration(seconds: 4));
    } finally {
      _connection = null;
    }
  }

  Future<void> abrir(String deviceId, int dispositivoId) async {
    String? codCliente = "*${userController.userModel.value.clienteCodigo}a";

    if(_connection == null) {
      Get.snackbar("Não foi possível Abrir", "Conecte o dispositivo primeiro", snackPosition: SnackPosition.BOTTOM, duration: const Duration(seconds: 4));
    }else {
      if (_connection!.isConnected) {
        print("ABRIR Conectado: MAC: $deviceId - Id: $dispositivoId");
        try {
          List<String> commands = [codCliente[0], codCliente[1], codCliente[2], codCliente[3], codCliente[4], codCliente[5]];

          //commands = ['*', 'f', 'b', 'd', 't', 'a'];
          int delay = 200;
          Future.forEach<String>(commands, (command) async {
            var list = Uint8List.fromList(utf8.encode(command));
            _connection!.output.add(list);
            await _connection!.output.allSent;
            print(command);
            await Future.delayed(Duration(milliseconds: delay));
            delay = delay + 200;
            print("delay: ${delay}");
          });

          salvarLogDispositivo("Abriu", dispositivoId);
        } catch (exp) {
          _connection = null;
          await FlutterBluetoothSerial.instance.requestDisable();
          Get.snackbar("Não foi possível Abrir", "Conecte o dispositivo primeiro", snackPosition: SnackPosition.BOTTOM, duration: const Duration(seconds: 4));
        }
      } else {
        print("Falha ao ABRIR: MAC: $deviceId - Id: $dispositivoId");
        _connection = null;
        await FlutterBluetoothSerial.instance.requestDisable();
      }
    }
  }


  Future<void> ligarEnergia(String deviceId, int dispositivoId) async {

    String? codCliente = "*${userController.userModel.value.clienteCodigo}r";

    if(_connection == null) {
      Get.snackbar("Não foi possível Ligar Energia", "Conecte o dispositivo primeiro", snackPosition: SnackPosition.BOTTOM, duration: const Duration(seconds: 4));
    }else {
      if (_connection!.isConnected) {
        try {
          List<String> commands = [codCliente[0], codCliente[1], codCliente[2], codCliente[3], codCliente[4], codCliente[5]];

          //commands = ['*', 'f', 'b', 'd', 't', 'r'];
          int delay = 200;
          Future.forEach<String>(commands, (command) async {
            var list = Uint8List.fromList(utf8.encode(command));
            _connection!.output.add(list);
            await _connection!.output.allSent;
            print(command);
            await Future.delayed(Duration(milliseconds: delay));
            delay = delay + 200;
            print("delay: ${delay}");
          });

          salvarLogDispositivo("Ligou energia", dispositivoId);

        } catch (exp) {
          _connection = null;
          Get.snackbar("Não foi possível Ligar Energia", "Conecte o dispositivo primeiro", snackPosition: SnackPosition.BOTTOM, duration: const Duration(seconds: 4));
        }
      } else {
        _connection = null;
        Get.snackbar("Não foi possível Ligar Energia", "Conecte o dispositivo primeiro", snackPosition: SnackPosition.BOTTOM, duration: const Duration(seconds: 4));
      }
    }
  }

  Future<void> desligarEnergia(String deviceId, int dispositivoId) async {

    String? codCliente = "*${userController.userModel.value.clienteCodigo}d";

    if(_connection == null) {
        Get.snackbar("Não foi possível Desligar a Energia", "Conecte o dispositivo primeiro", snackPosition: SnackPosition.BOTTOM, duration: const Duration(seconds: 4));
    }else {
      if (_connection!.isConnected) {
        try {
          List<String> commands = [codCliente[0], codCliente[1], codCliente[2], codCliente[3], codCliente[4], codCliente[5]];

          //commands = ['*', 'f', 'b', 'd', 't', 'd'];
          int delay = 200;
          Future.forEach<String>(commands, (command) async {
            var list = Uint8List.fromList(utf8.encode(command));
            _connection!.output.add(list);
            await _connection!.output.allSent;
            print(command);
            await Future.delayed(Duration(milliseconds: delay));
            delay = delay + 200;
            print("delay: ${delay}");
          });

          salvarLogDispositivo("Desligou energia", dispositivoId);
        } catch (exp) {
          _connection = null;
          Get.snackbar("Não foi possível Desligar a Energia", "Conecte o dispositivo primeiro", snackPosition: SnackPosition.BOTTOM, duration: const Duration(seconds: 4));
        }
      } else {
        _connection = null;
        Get.snackbar("Não foi possível Desligar a Energia", "Conecte o dispositivo primeiro", snackPosition: SnackPosition.BOTTOM, duration: const Duration(seconds: 4));
      }
    }
  }

  Future<void> alterarSenha(String deviceId, int dispositivoId) async {
    String? codCliente = "*${userController.userModel.value.clienteCodigo}n${novaSenha.text}";

    if(_connection == null) {
      Get.snackbar("Não foi possível Alterar a Senha", "Conecte o dispositivo primeiro", snackPosition: SnackPosition.BOTTOM, duration: const Duration(seconds: 4));
    }else {
      if (_connection!.isConnected) {
        try {
          List<String> commands = [codCliente[0], codCliente[1], codCliente[2], codCliente[3], codCliente[4], codCliente[5],
            codCliente[6], codCliente[7], codCliente[8], codCliente[9]];
          print("Alterar senha: MAC: $deviceId - Id: $dispositivoId");
          //commands = ['*', 'f', 'b', 'd', 't', 'n', '1', '2', '3', '4'];
          int delay = 200;
          Future.forEach<String>(commands, (command) async {
            var list = Uint8List.fromList(utf8.encode(command));
            _connection!.output.add(list);
            await _connection!.output.allSent;
            print(command);
            await Future.delayed(Duration(milliseconds: delay));
            delay = delay + 200;
            print("delay: ${delay}");
          });

          salvarLogDispositivo("Senha alterada: ${novaSenha.text}", dispositivoId);

          senhaMaster.clear();
          novaSenha.clear();

          Get.back();
        } catch (exp) {
          _connection = null;
          Get.snackbar("Não foi possível Alterar a Senha", "Conecte o dispositivo primeiro", snackPosition: SnackPosition.BOTTOM, duration: const Duration(seconds: 4));
        }
      } else {
        _connection = null;
        Get.snackbar("Não foi possível Alterar a Senha", "Conecte o dispositivo primeiro", snackPosition: SnackPosition.BOTTOM, duration: const Duration(seconds: 4));
      }
    }
  }

  Future<void> salvarLogDispositivo(String descricao, int dispositivoId) async{
    DispositivoRegistroModel registro = DispositivoRegistroModel(descricao: descricao, dispositivoId: dispositivoId, tecnicoId: userController.userModel.value.id, data: DateTime.now().toString());
    await dbController.addDBDispositivoRegistros(registro);
  }
}
