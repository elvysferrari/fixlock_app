import 'package:dio/dio.dart';
import 'package:fixlock_app/constants/controllers.dart';
import 'package:fixlock_app/screens/chamado/lista_chamado_screen.dart';
import 'package:get/get.dart' hide Response;

import '../models/chamado_list_model.dart';
import '../models/chamado_model.dart';
import '../models/checklist_original_model.dart';
import '../screens/home/initial_screen.dart';
import '../utils/http_service.dart';

class ChamadoController extends GetxController {

  final _http = HttpService();

  static ChamadoController instance = Get.find();

  RxList<ChamadoListModel> chamadosAbertos = <ChamadoListModel>[].obs;
  RxList<ChamadoListModel> chamadosFinalizados = <ChamadoListModel>[].obs;

  Future obterChamados() async {
    Response response;
    chamadosAbertos.value = [];
    chamadosFinalizados.value = [];

    try {
      var tecnicoId = userController.userModel.value.id;
      response = await _http.getRequest('/chamado?tecnicoId=$tecnicoId');
      if(response.statusCode == 200){
        final List<ChamadoListModel> chamados = response.data
            .map((json) => ChamadoListModel.fromJson(json))
            .toList()
            .cast<ChamadoListModel>();

        chamados.forEach((chamado) {
          if (chamado.status == "Finalizado" || chamado.status == "Cancelado"){
            chamadosFinalizados.value.add(chamado);
          }else{
            chamadosAbertos.value.add(chamado);
          }

        });

        chamadosFinalizados.refresh();
        chamadosAbertos.refresh();
      }
    } catch (e) {
      Get.snackbar("Erro ao carregar Chamados", e.toString());
    }
  }

  Future<ChamadoModel> obterChamado(int id) async {
    Response response;
    ChamadoModel chamado = ChamadoModel();

    try {
      response = await _http.getRequest('/chamado/$id');
      if(response.statusCode == 200){
        chamado =  ChamadoModel.fromJson(response.data);
      }
    } catch (e) {
      Get.snackbar("Erro ao carregar chamado", e.toString());
    }

    return chamado;
  }

  Future<List<Checklists>> obterChecklists() async {
    Response response;
    List<Checklists> checklists = [];

    try {
      response = await _http.getRequest('/chamado/checklists');
      if(response.statusCode == 200){
        List<ChecklistOriginalModel> checklistsOriginal = response.data[0]["checklists"]
            .map((json) => ChecklistOriginalModel.fromJson(json))
            .toList()
            .cast<ChecklistOriginalModel>();

        for (var check in checklistsOriginal) {
          Checklists checklist = Checklists(id: 0, chamadoId: 0, observacao: "", ordemNumero: 0, checklistId: check.id, descricao: check.descricao, valor: 0, flObservacao: check.flObservacao);
          checklists.add(checklist);
        }
      }
    } catch (e) {
      Get.snackbar("Erro ao carregar checklists", e.toString());
    }

    return checklists;
  }

  Future<ChamadoModel> salvar(ChamadoModel chamado) async {
    Response response;
    //ChamadoModel chamado = ChamadoModel();

    try {
      if(chamado.id == null || chamado.id == 0) {
        if(imagePickController.fotosTiradasAntes.isNotEmpty && imagePickController.fotosTiradasAntes.length < 3){
          Get.snackbar("Erro ao salvar Chamado", "Tire pelo menos 3 fotos antes");
          return chamado;
        }
        var chamadoJson = chamado.toSaveJson();
        response = await _http.postRequest('/chamado', chamadoJson);
        if (response.statusCode == 200) {
          var chamadoId = response.data["chamadoId"].toString();
          await imagePickController.uploadImages(
              (int.parse(chamadoId)));
          Get.snackbar("Salvar Chamado", "Chamado salvo com sucesso!");
          Get.offAll(() => const ListaChamadoScreen());
        }
      }else{
        if(!imagePickController.fotosTiradasDepois.isNotEmpty && imagePickController.fotosTiradasDepois.length < 3){
          Get.snackbar("Erro ao salvar Chamado", "Tire pelo menos 3 fotos depois");
          return chamado;
        }

        await imagePickController.uploadImages((int.parse(chamado.id.toString())));
        Get.snackbar("Salvar Fotos", "Fotos salvas com sucesso!");
        Get.offAll(() => const ListaChamadoScreen());
      }
    } catch (e) {
      Get.snackbar("Erro ao salvar chamado", e.toString());
    }

    return chamado;
  }
}