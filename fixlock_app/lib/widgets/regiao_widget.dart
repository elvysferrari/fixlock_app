import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/regiao_model.dart';
import 'lista_condominio_widget.dart';

class RegiaoWidget extends StatelessWidget {
  final RegiaoModel regiao;

  const RegiaoWidget({required this.regiao, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => ListaCondominioWidget(regiao: regiao));
      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(.5),
                  offset: const Offset(3, 2),
                  blurRadius: 7)
            ]),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
             ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
                child: Stack(
                    children: [

                      Image.asset("assets/images/abrir.jpg",
                        width: double.infinity,
                      ),
                    ]
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Center(
                  child: Text(
                    regiao.nome.toUpperCase(),
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
