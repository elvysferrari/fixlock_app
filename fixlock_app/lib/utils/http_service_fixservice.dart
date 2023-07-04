import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_constants.dart';

class HttpServiceFixService{
  late Dio _dio;

  HttpServiceFixService(){
    _dio = Dio(
        BaseOptions(
          baseUrl: baseUrlFixService,)
    );

    initializeInterceptors();
  }

  Future<Response> getRequest(String endPoint) async{
    Response response;
    try{
      response = await _dio.get(endPoint);
    } on DioError catch (e){
      throw Exception(e);
    }
    return response;
  }

  Future<Response> postRequest(String endPoint, data, {Options? options}) async{
    Response response;
    try{
      response = await _dio.post(endPoint, data: data, options: options);
    } on DioError catch (e){
      throw Exception(e);
    }
    return response;
  }

  Future<Response> putRequest(String endPoint, data, {Options? options}) async{
    Response response;
    try{
      response = await _dio.put(endPoint, data: data, options: options);
    } on DioError catch (e){
      throw Exception(e);
    }
    return response;
  }

  Future<void> initializeInterceptors() async {
    _dio.interceptors.add(InterceptorsWrapper(
        onRequest:(options, handler) async {
          final prefs = await SharedPreferences.getInstance();
          var accessToken = await prefs.getString("TOKEN");
          options.headers['Authorization'] = 'Bearer $accessToken';
          return handler.next(options); //continue
        },
        onResponse:(response,handler) {
          return handler.next(response); // continue
        },
        onError: (DioError e, handler) {
          if(e.response?.statusCode == 401){
            Get.snackbar("Usuário não logado", "Por favor faça login!", duration: const Duration(seconds: 5));
          }
          if(e.response?.statusCode == 500){
            Get.snackbar("Erro Interno", "O servidor encontrou uma situação com a qual não sabe lidar!", duration: const Duration(seconds: 5));
          }
          if(e.response?.statusCode == 503){
            Get.snackbar("Erro de Conexão", "Servidor em manutenção!", duration: const Duration(seconds: 5));
          }
          return  handler.next(e);//continue
        }
    ));
  }
}