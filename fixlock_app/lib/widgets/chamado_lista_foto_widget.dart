import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../constants/controllers.dart';
import 'chamado_foto_widget.dart';

class ChamadoListaFotoWidget extends StatelessWidget {
  final flAntes;

  const ChamadoListaFotoWidget({super.key, required this.flAntes});

  _chooseSource(bool flAntes, int index) {
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
                        "Escolha de onde buscar a foto",
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
                              onPressed: () {
                                Get.back();
                                if (flAntes) {
                                  imagePickController.tirarFotoAntes(
                                      ImageSource.gallery, index);
                                } else {
                                  imagePickController.tirarFotoDepois(
                                      ImageSource.gallery, index);
                                }
                              },
                              child: const Text(
                                'Galeria',
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
                                if (flAntes) {
                                  imagePickController.tirarFotoAntes(
                                      ImageSource.camera, index);
                                } else {
                                  imagePickController.tirarFotoDepois(
                                      ImageSource.camera, index);
                                }
                              },
                              child: const Text(
                                'Câmera',
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

  @override
  Widget build(BuildContext context) {
    if (flAntes) {
      return Obx(() => Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            alignment: WrapAlignment.center,
            children: [
              Container(
                  color: Colors.transparent,
                  width: 160,
                  height: 160,
                  child: imagePickController.fotosAntes.value.isNotEmpty
                      ? ChamadoFotoWidget(
                          imagePickController.fotosAntes.value[0].celPath,
                          imagePickController.fotosAntes.value[0].nome ?? "",
                          0,
                          true)
                      : GestureDetector(
                          onTap: () {
                            _chooseSource(true, 0);
                          },
                          child: Image.asset(
                            'assets/icons/add-photo.png',
                            height: 48,
                            width: 48,
                          ),
                        )),
              Container(
                color: Colors.transparent,
                width: 160,
                height: 160,
                child: imagePickController.fotosAntes.value.length >= 2
                    ? ChamadoFotoWidget(
                        imagePickController.fotosAntes.value[1].celPath,
                        imagePickController.fotosAntes.value[1].nome ?? "",
                        1,
                        true)
                    : GestureDetector(
                        onTap: () {
                          _chooseSource(true, 1);
                        },
                        child: Image.asset(
                          'assets/icons/add-photo.png',
                          height: 48,
                          width: 48,
                        ),
                      ),
              ),
              Container(
                color: Colors.transparent,
                width: 160,
                height: 160,
                child: imagePickController.fotosAntes.value.length >= 3
                    ? ChamadoFotoWidget(
                        imagePickController.fotosAntes.value[2].celPath,
                        imagePickController.fotosAntes.value[2].nome ?? "",
                        2,
                        true)
                    : GestureDetector(
                        onTap: () {
                          _chooseSource(true, 2);
                        },
                        child: Image.asset(
                          'assets/icons/add-photo.png',
                          height: 48,
                          width: 48,
                        ),
                      ),
              ),
            ],
          ));
    } else {
      return Obx(() => Wrap(
            spacing: 12.0,
            runSpacing: 12.0,
            alignment: WrapAlignment.center,
            children: [
              Container(
                  color: Colors.transparent,
                  width: 160,
                  height: 160,
                  child: imagePickController.fotosDepois.value.isNotEmpty
                      ? ChamadoFotoWidget(
                          imagePickController.fotosDepois.value[0].celPath,
                          imagePickController.fotosDepois.value[0].nome ?? "",
                          0,
                          false)
                      : GestureDetector(
                          onTap: () {
                            _chooseSource(false, 0);
                          },
                          child: Image.asset(
                            'assets/icons/add-photo.png',
                            height: 48,
                            width: 48,
                          ),
                        )),
              Container(
                color: Colors.transparent,
                width: 160,
                height: 160,
                child: imagePickController.fotosDepois.value.length >= 2
                    ? ChamadoFotoWidget(
                        imagePickController.fotosDepois.value[1].celPath,
                        imagePickController.fotosDepois.value[1].nome ?? "",
                        1,
                        false)
                    : GestureDetector(
                        onTap: () {
                          _chooseSource(false, 1);
                        },
                        child: Image.asset(
                          'assets/icons/add-photo.png',
                          height: 48,
                          width: 48,
                        ),
                      ),
              ),
              Container(
                color: Colors.transparent,
                width: 160,
                height: 160,
                child: imagePickController.fotosDepois.value.length >= 3
                    ? ChamadoFotoWidget(
                        imagePickController.fotosDepois.value[2].celPath,
                        imagePickController.fotosDepois.value[2].nome ?? "",
                        2,
                        false)
                    : GestureDetector(
                        onTap: () {
                          _chooseSource(false, 2);
                        },
                        child: Image.asset(
                          'assets/icons/add-photo.png',
                          height: 48,
                          width: 48,
                        ),
                      ),
              ),
            ],
          ));
    }
  }
}
