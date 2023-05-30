import 'package:fixlock_app/widgets/regiao_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/controllers.dart';
import '../models/regiao_model.dart';
import 'animated_loading.dart';

class ListaRegiaoWidget extends StatelessWidget {

  const ListaRegiaoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      Obx(()=>
          dbController.regioesOrdem.isEmpty ?
          const AnimatedLoadingWidget() :
          GridView.count(
        crossAxisCount: 2,
        childAspectRatio: .80,
        padding: const EdgeInsets.all(4),
        mainAxisSpacing: 6.0,
        crossAxisSpacing: 10,
        children: dbController.regioesOrdem.map((RegiaoModel regiao) {
          return RegiaoWidget(regiao: regiao,);
        }).toList()));
  }
}
