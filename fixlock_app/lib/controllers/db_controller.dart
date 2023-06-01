import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import 'package:sqflite/sqflite.dart';

import '../constants/controllers.dart';
import '../models/condominio_model.dart';
import '../models/database/db.dart';
import '../models/database/db_table.dart';
import '../models/dispositivo_model.dart';
import '../models/dispositivo_registro_model.dart';
import '../models/regiao_model.dart';
import '../utils/http_service.dart';

class DBController extends GetxController{
  static DBController instance = Get.find();
  late Database db;

  final RxList<RegiaoModel> _regioes = RxList<RegiaoModel>([]);
  List<RegiaoModel> get regioes => _regioes.value;
  List<RegiaoModel> get regioesOrdem => _regioes.value..sort((a, b) => a.nome.compareTo(b.nome));

  final RxList<CondominioModel> _condominios = RxList<CondominioModel>([]);
  List<CondominioModel> get condominios => _condominios.value;
  List<CondominioModel> get condominiosOrdem => _condominios.value..sort((a, b) => a.nome.compareTo(b.nome));

  final RxList<DispositivoModel> _dispositivos = RxList<DispositivoModel>([]);
  List<DispositivoModel> get dispositivos => _dispositivos.value;
  List<DispositivoModel> get dispositivosOrdem => _dispositivos.value..sort((a, b) => a.descricao.compareTo(b.descricao));

  final _http = HttpService();

  DBController(){
    _initDB();
  }

  _initDB() async {
    db = await DB.instance.database;
  }

  Future<void> getDispositivos() async {
    List dispositivos = await db.query('dispositivo');
    dispositivos.forEach((dispositivo) {
      _dispositivos.value.add(DispositivoModel(
        id: dispositivo["id_dis"],
        descricao: dispositivo["dsc_dis"],
        serial: dispositivo["ser_dis"],
        condominioId: dispositivo["id_con"]
      ));
    });
    _dispositivos.refresh();
  }

  addRegiao(List<RegiaoModel> regioes){
    _regioes.value.addAll(regioes);
    regioes.forEach((regiao) async {
      await addDBRegioes(regiao);
    });
    _regioes.refresh();
  }

  addCondominio(List<CondominioModel> condominios){
    _condominios.value.addAll(condominios);
    condominios.forEach((condominio) async {
      await addDBCondominios(condominio);
    });
    _condominios.refresh();
  }

  addDispositivos(List<DispositivoModel> dispositivos){
    _dispositivos.value.addAll(dispositivos);
    dispositivos.forEach((dispositivo) async {
      await addDBDispositivos(dispositivo);
    });
    _dispositivos.refresh();
  }

  Future<void> getRegiao() async {
    List regioes = await db.query('regiao');
    regioes.forEach((data) {
      _regioes.value.add(RegiaoModel(
          id: data["id_reg"],
          nome: data["nom_reg"],
      ));
    });
    _regioes.refresh();
  }

  Future<void> getCondominios() async {
    List condominios = await db.query('condominio');
    condominios.forEach((data) {
      _condominios.value.add(CondominioModel(
          id: data["id_con"],
          nome: data["nom_con"],
          regiaoId: data["id_reg"]
      ));
    });
    _condominios.refresh();
  }

  Future<void> addDBDispositivos(DispositivoModel model) async {
    await db.insert('dispositivo', {
      "id_dis": model.id,
      "dsc_dis": model.descricao,
      "ser_dis": model.serial,
      "id_con": model.condominioId
    });
  }

  Future<void> addDBDispositivoRegistros(DispositivoRegistroModel model) async {
    await db.insert('dispositivo_registro', {
      "dta_reg": model.data,
      "dsc_reg": model.descricao,
      "id_dis": model.dispositivoId,
      "id_tec": model.tecnicoId
    });
    if(appController.isDeviceInternetConnected.value) {
      await enviarApiDispositivoRegistros();
    }
  }
  Future<void> getDispositivoRegistros() async {
    List condominios = await db.query('dispositivo_registro');
    condominios.forEach((data) {
      _condominios.value.add(CondominioModel(
          id: data["id_con"],
          nome: data["nom_con"],
          regiaoId: data["id_reg"]
      ));
    });
    _condominios.refresh();
  }

  Future<void> enviarApiDispositivoRegistros() async {
    try{
      if(db.isOpen) {
        List _registros = await db.query('dispositivo_registro');
        List<DispositivoRegistroModel> _listaRegistros = [];
        _registros.forEach((data) {
          _listaRegistros.add(DispositivoRegistroModel(
              descricao: data["dsc_reg"],
              tecnicoId: data["id_tec"],
              dispositivoId: data["id_dis"],
              data: data["dta_reg"]
          ));
        });

        if (_listaRegistros.isNotEmpty) {
          Response response;
          try {
            response = await _http.postRequest(
                '/dispositivo/salvar-registros', jsonEncode(_listaRegistros));
            if (response.statusCode == 200) {
              //removo dos dados locais
              var dbTable = DBTable();
              await db.execute(dbTable.deletaDispositivoRegistro);
            }
          } catch (exception) {
            print("erro ao enviar");
          }
        }
      }
    }catch(exception){
      print(exception.toString());
    }
  }

  Future<void> addDBRegioes(RegiaoModel model) async {
    await db.insert('regiao', {
      "id_reg": model.id,
      "nom_reg": model.nome
    });
  }

  Future<void> addDBCondominios(CondominioModel model) async {
    await db.insert('condominio', {
      "id_con": model.id,
      "nom_con": model.nome,
      "id_reg": model.regiaoId
    });
  }

  resetDB() async {
    var dbTable = DBTable();

    await db.execute(dbTable.dropTables);
    await db.execute(dbTable.dipositivo);
    await db.execute(dbTable.dispositivoRegistro);
    await db.execute(dbTable.regiao);
    await db.execute(dbTable.condominio);

    _regioes.clear();
    _regioes.refresh();

    _condominios.clear();
    _condominios.refresh();

    _dispositivos.clear();
    _dispositivos.refresh();

    userController.importaDadosTecnico();
  }

}