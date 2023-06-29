import 'dart:convert';

import 'package:fixlock_app/constants/controllers.dart';
import 'package:fixlock_app/models/dispositivo_model.dart';
import 'package:fixlock_app/screens/dispositivo/dispositivo_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRCodeScreen extends StatefulWidget {
  const QRCodeScreen({Key? key}) : super(key: key);

  @override
  State<QRCodeScreen> createState() => _QRCodeScreenState();
}

class _QRCodeScreenState extends State<QRCodeScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  DispositivoModel dispositivoLido = DispositivoModel(id: 0, descricao: "Não Encontrado", serial: "", condominioId: 0);
  QRViewController? controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: (result != null)
                  ? Text(
                  'Dispositivo não autorizado: ${dispositivoLido.descricao}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),)
                  : const Text('Por favor escaneie o QRCode'),
            ),
          )
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        if(result != null){
          try {
            var jsonStr = result!.code ?? "";
            var jsonResult = jsonDecode(jsonStr);
            dispositivoLido = DispositivoModel.fromJsonQRCode(jsonResult);
            if(dispositivoLido.id > 0){
              //verificar se ele tem acesso
              var dispositivoEncontrado = dbController.dispositivos.any((d) => d.id == dispositivoLido.id);
              if(dispositivoEncontrado) {
                Get.off(() => DispositivoScreen(dispositivo: dispositivoLido));
              }else{
                Get.snackbar("Acesso negado", "Você não tem permissão pra acessar esse dispositivo");
              }
            }
          }catch(exp){
            Get.snackbar("Erro ao ler QRCode", "Não foi possível ler o QRCode");
          }
        }
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
