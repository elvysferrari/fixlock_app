import 'package:fixlock_app/models/dispositivo_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/color_pallet.dart';
import '../constants/controllers.dart';

class DispositivoConfiguracaoScreen extends StatefulWidget {
  final DispositivoModel dispositivo;
  const DispositivoConfiguracaoScreen({required this.dispositivo, Key? key}) : super(key: key);

  @override
  State<DispositivoConfiguracaoScreen> createState() => _DispositivoConfiguracaoScreenState();
}

class _DispositivoConfiguracaoScreenState extends State<DispositivoConfiguracaoScreen> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(title: const Text("CONFIGURAR SENHA"), backgroundColor: Colors.redAccent),
      body: Padding(
        padding: const EdgeInsets.only(top: 36.0),
        child: Wrap(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.90,
                  margin: const EdgeInsets.only(top: 30),
                  child: TextField(
                    controller: dispositivoController.senhaMaster,
                    decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.textGrey),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.primary),
                        ),
                        icon: Icon(Icons.lock_outlined, color: AppColors.primary),
                        fillColor: Colors.white,
                        border: InputBorder.none,
                        hintText: "Senha master"),
                    onChanged: (_) => setState(() {

                    }),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.90,
                  margin: const EdgeInsets.only(top: 30),
                  child: TextField(
                    controller: dispositivoController.novaSenha,
                    decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.textGrey),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.primary),
                        ),
                        icon: Icon(Icons.lock_outlined, color: AppColors.primary),
                        fillColor: Colors.white,
                        border: InputBorder.none,
                        hintText: "Nova senha"),
                    onChanged: (_) => setState(() {

                    }),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 36.0),
              child: Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.90,
                  height: 40,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                    ),
                    child: const Text('Alterar senha', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                    onPressed: () {
                      if(dispositivoController.senhaMaster.text.isNotEmpty) {
                        if(dispositivoController.senhaMaster.text == "fixlock\$2018"){
                          dispositivoController.alterarSenha(widget.dispositivo.serial);
                        }else{
                          Get.snackbar("Dados Inválidos!", "Senha master não confere");
                        }
                      } else {
                        Get.snackbar("Dados Inválidos!", "Por favor preencha a Senha");
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
