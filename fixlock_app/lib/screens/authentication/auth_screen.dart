import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../constants/color_pallet.dart';
import '../../../controllers/app_controller.dart';
import 'widgets/login.dart';
import 'widgets/signup.dart';

class AuthenticationScreen extends StatefulWidget {

  AuthenticationScreen({Key? key}) : super(key: key);

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  final AppController _appController = Get.find();
  late String clienteLogo = "";

  @override
  void initState(){
    _carregaDadosSalvos();
    super.initState();
  }

  _carregaDadosSalvos() async {
    final prefs = await SharedPreferences.getInstance();
    String? tecnicoJson = await prefs.getString("tecnico");
    if(tecnicoJson != null) {
      var tecnicoJsonDecode = jsonDecode(tecnicoJson);
      if(tecnicoJsonDecode["clienteLogo"] != null) {
        setState(() {
          clienteLogo = tecnicoJsonDecode["clienteLogo"];
        });
      }
    }
  }

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
                child:
                clienteLogo.isNotEmpty ? Image.network(clienteLogo, fit: BoxFit.cover, height: 300,)
                    :
                Image.asset('assets/images/9w.jpg', fit: BoxFit.cover, height: 300),
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
