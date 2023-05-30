import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants/app_constants.dart';
import '../../widgets/drawer_mobile.dart';
import '../../widgets/lista_regiao_widget.dart';
import '../authentication/auth_screen.dart';
import '/../constants/controllers.dart';
import 'home_screen.dart';

class InitialScreen extends StatefulWidget {
  const InitialScreen({Key? key}) : super(key: key);

  @override
  State<InitialScreen> createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {

  bool flCarregando = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loginUsuario();
    });

    initialization();
  }

  void initialization() async {
    await Future.delayed(const Duration(seconds: 2));
    FlutterNativeSplash.remove();
  }

  loginUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    String? usuario = prefs.getString("tecnico");

    if (usuario != null) {
      if (usuario.isNotEmpty) {
        Map<String, dynamic> userMap =
            jsonDecode(usuario) as Map<String, dynamic>;
        await userController.automaticSignIn(userMap["id"], userMap["password"]);
        setState(() =>flCarregando = false
        );
      }else{
        setState(() =>flCarregando = false
        );
      }
    }else{
      setState(() =>flCarregando = false
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return
      flCarregando == true ?
      const Center(
        child: CircularProgressIndicator(

        ),
      )
      :
      Obx(() => userController.userModel.value.id == null
        ? AuthenticationScreen()
        : Scaffold(
            drawer: const DrawerMobile(),
            appBar:
                AppBar(title: Text(appName), backgroundColor: Colors.redAccent),
            body: const ListaRegiaoWidget(),
        ));
  }
}