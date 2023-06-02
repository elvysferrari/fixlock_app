import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/controllers.dart';
import '../models/dispositivo_model.dart';
import 'dipositivo_configuracao_screen.dart';

class DispositivoScreen extends StatefulWidget {
  final DispositivoModel dispositivo;

  const DispositivoScreen({required this.dispositivo, Key? key}) : super(key: key);

  @override
  State<DispositivoScreen> createState() => _DispositivoScreenState();
}

class _DispositivoScreenState extends State<DispositivoScreen> {

  bool showLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() async {
    desconectar();
    super.dispose();
  }

  Future<void> desconectar() async {
    await dispositivoController.disconnect(widget.dispositivo.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.dispositivo.descricao),
          backgroundColor: Colors.redAccent),
      body: showLoading ?
          _showLoading()
          :
      GridView.count(
          crossAxisCount: 2,
          childAspectRatio: .80,
          padding: const EdgeInsets.all(4),
          mainAxisSpacing: 6.0,
          crossAxisSpacing: 10,
          children: [
            GestureDetector(
              onTap: () async {
                setState(() {
                  showLoading = true;
                });

                if(dispositivoController.connection.value == null) {
                  await dispositivoController.connect(widget.dispositivo.serial, widget.dispositivo.id);
                } else {
                  await dispositivoController.disconnect(widget.dispositivo.id);
                }

                await Future.delayed(const Duration(seconds: 5));

                setState(() {
                  showLoading = false;
                });
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
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                          ),
                          child: Stack(children: [
                            Image.asset(
                              "assets/images/conectar.jpg",
                              width: double.infinity,
                            ),
                          ]),
                        ),
                      ),
                      Text(
                        dispositivoController.connection.value != null ? "DESCONECTAR" : "CONECTAR",
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () async {

                if(dispositivoController.connection.value != null) {
                  setState(() {
                    showLoading = true;
                  });
                  await dispositivoController.abrir(widget.dispositivo.serial, widget.dispositivo.id);
                  await Future.delayed(const Duration(seconds: 5));
                }else{
                  Get.snackbar("Dispositivo desconectado", "Conecte o dispositivo primeiro");
                }

                setState(() {
                  showLoading = false;
                });
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
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                          ),
                          child: Stack(children: [
                            Image.asset(
                              "assets/images/abrir.jpg",
                              width: double.infinity,
                            ),
                          ]),
                        ),
                      ),
                      const Text(
                        "ABRIR",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () async {

                if(dispositivoController.connection.value != null) {
                  setState(() {
                    showLoading = true;
                  });
                  dispositivoController.ligarEnergia(widget.dispositivo.serial, widget.dispositivo.id);
                  await Future.delayed(const Duration(seconds: 5));
                }else{
                  Get.snackbar("Dispositivo desconectado", "Conecte o dispositivo primeiro");
                }
                setState(() {
                  showLoading = false;
                });
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
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                          ),
                          child: Stack(children: [
                            Image.asset(
                              "assets/images/ligar.jpg",
                              width: double.infinity,
                            ),
                          ]),
                        ),
                      ),
                      const Text(
                        "LIGAR ENERGIA",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                _popupDesligarEnergia();
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
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                          ),
                          child: Stack(children: [
                            Image.asset(
                              "assets/images/desligar.jpg",
                              width: double.infinity,
                            ),
                          ]),
                        ),
                      ),
                      const Text(
                        "DESLIGAR ENERGIA",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                if(dispositivoController.connection.value != null) {
                  Get.to(() => DispositivoConfiguracaoScreen(dispositivo: widget.dispositivo,));
                }else{
                  Get.snackbar("Dispositivo desconectado", "Conecte o dispositivo primeiro");
                }
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
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                          ),
                          child: Stack(children: [
                            Image.asset(
                              "assets/images/desligar.jpg",
                              width: double.infinity,
                            ),
                          ]),
                        ),
                      ),
                      const Text(
                        "CONFIGURAR",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ]),
    );
  }

  _showLoading(){
    return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Enviando comando por favor aguarde...",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, color: Colors.black),
              ),
              SizedBox(height: 24,),
              CircularProgressIndicator(),
            ],
          )
      );
  }

  _popupDesligarEnergia() {
    Get.dialog(
      Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Material(
            child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(children: [
                      //Buttons
                      const Text(
                        "Tem certeza que deseja desligar a energia?",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                foregroundColor: const Color(0xFFFFFFFF),
                                backgroundColor: Colors.redAccent,
                                minimumSize: const Size(0, 45),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () async {
                                Get.back();
                                setState(() {
                                  showLoading = true;
                                });
                                dispositivoController.desligarEnergia(widget.dispositivo.serial, widget.dispositivo.id);

                                await Future.delayed(const Duration(seconds: 5));

                                setState(() {
                                  showLoading = false;
                                });

                              },
                              child: const Text(
                                'SIM',
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                foregroundColor: const Color(0xFFFFFFFF),
                                backgroundColor: Colors.redAccent,
                                minimumSize: const Size(0, 45),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () {
                                Get.back();
                              },
                              child: const Text(
                                'NÃO',
                              ),
                            ),
                          ),
                        ],
                      )
                    ]))),
          ),
        ),
      ]),
    );
  }
}
