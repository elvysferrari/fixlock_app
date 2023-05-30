import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants/color_pallet.dart';
import '../../../controllers/app_controller.dart';
import 'widgets/login.dart';
import 'widgets/signup.dart';

class AuthenticationScreen extends StatelessWidget {
  final AppController _appController = Get.find();

  AuthenticationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Obx(() => SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset('assets/images/9w.jpg', fit: BoxFit.cover),
              ),
              //Image.asset("", width: 200,height: 150,),
              const SizedBox(height: 12),
              Visibility(
                  visible: _appController.isLoginWidgetDisplayed.value,
                  child: LoginWidget()),
              Visibility(
                  visible: !_appController.isLoginWidgetDisplayed.value,
                  child: SignupWidget()),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),)
    );
  }
}
