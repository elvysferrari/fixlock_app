import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fixlock_app/controllers/chamado_controller.dart';
import 'package:fixlock_app/screens/home/initial_screen.dart';
import 'package:fixlock_app/utils/local_notification_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

import 'constants/app_constants.dart';
import 'constants/firebase.dart';
import 'constants/firebase_options.dart';
import 'constants/responsive.dart';
import 'controllers/app_controller.dart';
import 'controllers/db_controller.dart';
import 'controllers/dispositivo_controller.dart';
import 'controllers/image_pick_controller.dart';
import 'controllers/user_controller.dart';


@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await LocalNotificationService.setupFlutterNotifications();
  LocalNotificationService.showFlutterNotification(message);
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  print('Handling a background message ${message.messageId}');
}

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await initialization.then((value){});

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  await LocalNotificationService.setupFlutterNotifications();

  Get.put(UserController());
  Get.put(AppController());
  Get.put(DBController());
  Get.put(DispositivoController());
  Get.put(ChamadoController());
  Get.put(ImagePickController());

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
