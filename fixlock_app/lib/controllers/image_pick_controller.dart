import 'package:fixlock_app/constants/controllers.dart';
import 'package:get/get.dart' hide Response;
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart' as dio;
import '../models/chamado_foto_model.dart';
import '../utils/http_service.dart';

class ImagePickController extends GetxController {
  final _http = HttpService();

  static ImagePickController instance = Get.find();

  RxList<ChamadoFotoModel> fotosAntes = <ChamadoFotoModel>[].obs;
  RxList<ChamadoFotoModel> fotosDepois = <ChamadoFotoModel>[].obs;
  bool fotosAntesFinalizadas = false;
  bool fotosDepoisFinalizadas = false;
  List<XFile> fotosTiradasAntes = [];
  List<XFile> fotosTiradasDepois = [];
  int _qtdFotos = 3;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

  void tirarFotoAntes(ImageSource imageSource, int index) async {
    final pickedFile = await ImagePicker().pickImage(source: imageSource, imageQuality: 50);
    if (pickedFile != null) {
      try {
        fotosTiradasAntes.removeAt(index);
        fotosAntes.removeAt(index);
      }catch(e){}

      ChamadoFotoModel ordemFoto = ChamadoFotoModel(0, 0, DateTime.now().toString(), "", true, pickedFile.path, pickedFile, index, pickedFile.name);

      fotosTiradasAntes.add(pickedFile);
      fotosAntes.add(ordemFoto);

    } else {
      print("No image selected");
    }
  }

  void tirarFotoDepois(ImageSource imageSource, int index) async {
    final pickedFile = await ImagePicker().pickImage(source: imageSource, imageQuality: 50);
    if (pickedFile != null) {
      try {
        fotosTiradasDepois.removeAt(index);
        fotosDepois.removeAt(index);
      }catch(e){}

      ChamadoFotoModel ordemFoto = ChamadoFotoModel(0, 0, DateTime.now().toString(), "", true, pickedFile.path, pickedFile, index, pickedFile.name);

      fotosTiradasDepois.add(pickedFile);
      fotosDepois.add(ordemFoto);

    } else {
      print("No image selected");
    }
  }

  void removerFotoAntes(int index) async {
      try {
        fotosTiradasAntes.removeAt(index);
        fotosAntes.removeAt(index);
      }catch(e){}
  }

  void removerFotoDepois(int index) async {
    try {
      fotosTiradasDepois.removeAt(index);
      fotosDepois.removeAt(index);
    }catch(e){}
  }

  Future uploadImages(int chamadoId) async {
    late FormData formData ;

    if(fotosTiradasAntes.length >= _qtdFotos && fotosAntesFinalizadas == false) {
      try {

        List<dio.MultipartFile> files = [];

        files.add(await dio.MultipartFile.fromFile(
          fotosTiradasAntes[0].path,
          filename: "1_${fotosTiradasAntes[0].name}",
        ));

        files.add(await dio.MultipartFile.fromFile(
          fotosTiradasAntes[1].path,
          filename: "2_${fotosTiradasAntes[0].name}",
        ));
        files.add(await dio.MultipartFile.fromFile(
          fotosTiradasAntes[2].path,
          filename: "3_${fotosTiradasAntes[0].name}",
        ));

        dio.FormData dataFotosAntes = dio.FormData.fromMap({
          "chamadoId": chamadoId,
          "flAntes": true,
          "imagens": files,
        });

        dio.Response response;
        response = await _http.postRequest('/chamado/uploadImagensPath', dataFotosAntes,
            options: dio.Options(method: "POST",
                headers: {'Content-Type': 'multipart/form-data'}));
      } catch (e) {
        print("Image picker error $e");
      }
    }

    if(fotosTiradasDepois.length >= _qtdFotos && fotosDepoisFinalizadas == false) {
      try {

        List<dio.MultipartFile> files = [];

        files.add(await dio.MultipartFile.fromFile(
          fotosTiradasDepois[0].path,
          filename: "1_${fotosTiradasDepois[0].name}",
        ));

        files.add(await dio.MultipartFile.fromFile(
          fotosTiradasDepois[1].path,
          filename: "2_${fotosTiradasDepois[0].name}",
        ));
        files.add(await dio.MultipartFile.fromFile(
          fotosTiradasDepois[2].path,
          filename: "3_${fotosTiradasDepois[0].name}",
        ));

        dio.FormData dataFotosDepois = dio.FormData.fromMap({
          "idUsuario": userController.userModel.value.id,
          "chamadoId": chamadoId,
          "flAntes": false,
          "imagens": files,
        });

        dio.Response response;
        response = await _http.postRequest('/chamado/uploadImagensPath', dataFotosDepois,
            options: dio.Options(method: "POST",
                headers: {'Content-Type': 'multipart/form-data'}));
      } catch (e) {
        print("Image picker error $e");
      }
    }
  }

  Future obterImagens(int chamadoId) async {

    dio.Response response;

    try {
      response = await _http.getRequest('/chamado/obterImagens/$chamadoId');
      if(response.statusCode == 200) {
        final List<ChamadoFotoModel> fotos = response.data
            .map((json) => ChamadoFotoModel.fromJson(json))
            .toList()
            .cast<ChamadoFotoModel>();

        fotosAntes.clear();
        fotosAntes.addAll(fotos.where((x) => x.flAntes == true).toList());
        fotosAntes.refresh();

        fotosDepois.clear();
        fotosDepois.addAll(fotos.where((x) => x.flAntes == false).toList());
        fotosDepois.refresh();

        if(fotosAntes.isNotEmpty) {
          fotosAntesFinalizadas = true;
        }

        if(fotosDepois.isNotEmpty) {
          fotosDepoisFinalizadas = true;
        }
      }
    } catch (e) {
      Get.snackbar("Erro ao carregar Imagens", e.toString());
    }
  }
}