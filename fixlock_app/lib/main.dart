import 'package:fixlock_app/controllers/chamado_controller.dart';
import 'package:fixlock_app/screens/home/initial_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

import 'constants/app_constants.dart';
import 'constants/responsive.dart';
import 'controllers/app_controller.dart';
import 'controllers/db_controller.dart';
import 'controllers/dispositivo_controller.dart';
import 'controllers/user_controller.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  Get.put(UserController());
  Get.put(AppController());
  Get.put(DBController());
  Get.put(DispositivoController());
  Get.put(ChamadoController());

  Intl.defaultLocale = 'pt_BR';
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: appName,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Responsive(
          desktop: Container(),
          mobile: const SafeArea(child: InitialScreen()),
        )
    );
  }
}
