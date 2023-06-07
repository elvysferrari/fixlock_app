import 'package:fixlock_app/constants/controllers.dart';
import 'package:fixlock_app/widgets/drawer_mobile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/color_pallet.dart';

class UsuarioPerfilScreen extends StatefulWidget {
  const UsuarioPerfilScreen({Key? key}) : super(key: key);

  @override
  State<UsuarioPerfilScreen> createState() => _UsuarioPerfilScreenState();
}

class _UsuarioPerfilScreenState extends State<UsuarioPerfilScreen> {
  TextEditingController password = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("PERFIL"), backgroundColor: Colors.redAccent, elevation: 0),
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                height: 80,
                width: MediaQuery.sizeOf(context).width,
                color: Colors.redAccent,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Center(child: Text("Olá, ${userController.userModel.value.nome}", style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 24, color: Colors.white),)),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.90,
                margin: const EdgeInsets.only(top: 30),
                child: TextField(
                  controller: password,
                  decoration: InputDecoration(
                      errorText: userController
                          .validaSenha(password.text),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColors.textGrey),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColors.primary),
                      ),
                      icon: const Icon(Icons.lock, color: AppColors.primary,),
                      fillColor: Colors.white,
                      border: InputBorder.none,
                      hintText: "Nova Senha"),
                  onChanged: (_) => setState(() {}),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.sizeOf(context).width * 0.90,
                margin: const EdgeInsets.only(top: 30),
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                  ),
                  child: const Text('SALVAR', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                  onPressed: () async {
                    var senhaAlterada = await userController.alterarSenha(password.text);
                    if(senhaAlterada){
                      Get.snackbar('Sucesso!',
                        "Senha alterada com sucesso!",
                      );
                      setState(() {
                        password.clear();
                      });
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
