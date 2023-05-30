import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../constants/color_pallet.dart';
import '../../../../constants/controllers.dart';

class LoginWidget extends StatefulWidget {
  LoginWidget({Key? key}) : super(key: key);

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return  Container(
      margin: const EdgeInsets.all(10),
      child: Wrap(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.90,
                margin: const EdgeInsets.only(top: 30),
                child: TextField(
                    controller: userController.id,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColors.textGrey),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColors.primary),
                      ),
                      icon: Icon(Icons.person, color: AppColors.primary),
                      fillColor: Colors.white,
                      border: InputBorder.none,
                      hintText: "ID"),
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
                    obscureText: _obscureText,
                    controller: userController.password,
                    decoration: InputDecoration(
                      errorText: userController.validaSenha(userController.password.text),
                      suffixIcon: GestureDetector(
                        onTap: (){
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                          child: const Icon(Icons.remove_red_eye_sharp, color: AppColors.primary)
                      ),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColors.textGrey),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColors.primary),
                      ),
                      icon: const Icon(Icons.lock, color: AppColors.primary),
                      fillColor: Colors.white,
                      border: InputBorder.none,
                      hintText: "Senha"),
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
                    primary: AppColors.primary,
                  ),
                  child: const Text('ENTRAR', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                  onPressed: () {
                    if(userController.botaoEntrar()) {
                      userController.signIn();
                    } else {
                      Get.snackbar("Dados Inválidos!", "Por favor preencha os campos Id e Senha");
                    }
                  },
                ),
              ),
            ),
         ),
        ],
      ),
    );
  }
}