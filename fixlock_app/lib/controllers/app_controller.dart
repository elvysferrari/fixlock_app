import 'package:fixlock_app/constants/controllers.dart';
import 'package:get/get.dart' hide Response;
import 'package:internet_connection_checker/internet_connection_checker.dart';

class AppController extends GetxController{

  static AppController instance = Get.find();
  RxBool isLoginWidgetDisplayed = true.obs;
  RxBool isDeviceInternetConnected = false.obs;


  final InternetConnectionChecker customInstance =
  InternetConnectionChecker.createInstance(
    checkTimeout: const Duration(seconds: 30),
    checkInterval: const Duration(seconds: 10),
  );


  @override
  Future<void> onInit() async {
    var listener = InternetConnectionChecker().onStatusChange.listen((status) {
      switch (status) {
        case InternetConnectionStatus.connected:
          isDeviceInternetConnected.value = true;
          break;
        case InternetConnectionStatus.disconnected:
          isDeviceInternetConnected.value = false;
          Get.snackbar("Sem internet", "Conexão com internet perdida");
          break;
      }
      isDeviceInternetConnected.refresh();
    });
  }

  changeDIsplayedAuthWidget(){
    isLoginWidgetDisplayed.value = !isLoginWidgetDisplayed.value;
  }

}