import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/app_constants.dart';
import '../constants/controllers.dart';
import '../screens/home/initial_screen.dart';
import '../screens/qr_code_screen.dart';
import '../screens/usuario/usuario_perfil_screen.dart';

class DrawerMobile extends StatelessWidget {
  const DrawerMobile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 2,
      width: 250,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            color: Colors.redAccent,
            height: 80,
            child: Column(
              children: [
                const SizedBox(height: 16,),
                const Center(child: Text(appName, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),)),
                const SizedBox(height: 16,),
                Center(child: Text(userController.userModel!.value.nome ?? "", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),)),
              ],
            ),
          ),
          ListTile(
            minLeadingWidth: 6,
            title: const Text('Início'),
            iconColor: Colors.redAccent,
            leading: const Icon(Icons.home),
            onTap: () {
              Get.back();
              Get.to(() => const InitialScreen());
            },
          ),          ListTile(
            minLeadingWidth: 6,
            title: const Text('Perfil'),
            iconColor: Colors.redAccent,
            leading: const Icon(Icons.person),
            onTap: () {
              Get.back();
              Get.to(() => const UsuarioPerfilScreen());
            },
          ),ListTile(
            minLeadingWidth: 6,
            title: const Text('Sincronizar Dados'),
            iconColor: Colors.redAccent,
            leading: const Icon(Icons.cloud_download),
            onTap: () async {
              await dbController.resetDB();
              Get.snackbar('Sincronização de dados',
                "Dados sincronizados com sucesso!",
              );
            },
          ),ListTile(
            minLeadingWidth: 6,
            title: const Text('Ler QRCode'),
            iconColor: Colors.redAccent,
            leading: const Icon(Icons.qr_code),
            onTap: () async {
              Get.back();
              Get.to(() => const QRCodeScreen());
            },
          ),
          ListTile(
            minLeadingWidth: 6,
            title: const Text('Sair'),
            iconColor: Colors.redAccent,
            leading: const Icon(Icons.logout_outlined),
            onTap: () {
              userController.signOut();
            },
          )
        ],
      ),
    );
  }
}
