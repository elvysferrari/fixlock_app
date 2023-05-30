import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import '../utils/http_service.dart';

class AppController extends GetxController{

  static AppController instance = Get.find();
  RxBool isLoginWidgetDisplayed = true.obs;

  changeDIsplayedAuthWidget(){
    isLoginWidgetDisplayed.value = !isLoginWidgetDisplayed.value;
  }


}