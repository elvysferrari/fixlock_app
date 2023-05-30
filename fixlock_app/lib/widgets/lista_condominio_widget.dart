import 'package:fixlock_app/models/regiao_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/app_constants.dart';
import '../constants/controllers.dart';
import '../models/condominio_model.dart';
import 'condominio_widget.dart';
import 'drawer_mobile.dart';

class ListaCondominioWidget extends StatelessWidget {
  final RegiaoModel regiao;
  const ListaCondominioWidget({ required this.regiao, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(()=> Scaffold(
      drawer: const DrawerMobile(),
      appBar:
      AppBar(title: const Text("CONDOMÍNIOS"), backgroundColor: Colors.redAccent),
      body: GridView.count(
          crossAxisCount: 2,
          childAspectRatio: .80,
          padding: const EdgeInsets.all(4),
          mainAxisSpacing: 6.0,
          crossAxisSpacing: 10,
          children: dbController.condominiosOrdem.where((c) => c.regiaoId == regiao.id).map((CondominioModel condominio) {
            return CondominioWidget(condominio: condominio,);
          }).toList()),
    ));
  }
}
