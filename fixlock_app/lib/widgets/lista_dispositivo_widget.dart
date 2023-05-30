import 'package:fixlock_app/models/dispositivo_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/app_constants.dart';
import '../constants/controllers.dart';
import '../models/condominio_model.dart';
import 'dispositivo_widget.dart';
import 'drawer_mobile.dart';

class ListaDispositivoWidget extends StatelessWidget {
  final CondominioModel condominio;
  const ListaDispositivoWidget({ required this.condominio, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(()=> Scaffold(
      drawer: const DrawerMobile(),
      appBar:
      AppBar(title: const Text("DISPOSITIVOS"), backgroundColor: Colors.redAccent),
      body: GridView.count(
          crossAxisCount: 2,
          childAspectRatio: .80,
          padding: const EdgeInsets.all(4),
          mainAxisSpacing: 6.0,
          crossAxisSpacing: 10,
          children: dbController.dispositivosOrdem.where((c) => c.condominioId == condominio.id).map((DispositivoModel dispositivo) {
            return DispositivoWidget(dispositivo: dispositivo);
          }).toList()),
    ));
  }
}
