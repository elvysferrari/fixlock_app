import 'package:fixlock_app/constants/controllers.dart';
import 'package:get/get.dart' hide Response;
import 'package:internet_connection_checker/internet_connection_checker.dart';

class AppController extends GetxController{

  static AppController instance = Get.find();
  RxBool isLoginWidgetDisplayed = true.obs;
  RxBool isDeviceInternetConnected = false.obs;
  bool offLineMode = false;


  final InternetConnectionChecker customInstance =
  InternetConnectionChecker.createInstance(
    checkTimeout: const Duration(seconds: 10),
    checkInterval: const Duration(seconds: 10),
  );


  @override
  Future<void> onInit() async {
    var listener = InternetConnectionChecker().onStatusChange.listen((status) {
      switch (status) {
        case InternetConnectionStatus.connected:
          isDeviceInternetConnected.value = true;
          appController.offLineMode = false;
          break;
        case InternetConnectionStatus.disconnected:
          isDeviceInternetConnected.value = false;
          appController.offLineMode = true;
          break;
      }
      isDeviceInternetConnected.refresh();
    });
  }

  changeDIsplayedAuthWidget(){
    isLoginWidgetDisplayed.value = !isLoginWidgetDisplayed.value;
  }

}