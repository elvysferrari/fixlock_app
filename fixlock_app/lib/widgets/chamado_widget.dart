import 'package:fixlock_app/models/chamado_list_model.dart';
import 'package:fixlock_app/screens/chamado/chamado_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import '../constants/color_pallet.dart';

class ChamadoWidget extends StatefulWidget {

  final ChamadoListModel chamado;

  const ChamadoWidget({super.key, required this.chamado});

  @override
  State<ChamadoWidget> createState() => _ChamadoWidgetState();
}

class _ChamadoWidgetState extends State<ChamadoWidget> {

  @override
  void initState() {
    initializeDateFormatting();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(4) ,
        child: Column(
          children: <Widget>[
            GestureDetector(
              onTap: (){
                Get.to(() => ChamadoScreen(id: widget.chamado.id!));
              },
              child: Card(
                elevation: 0,
                color: Colors.grey[100],
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      minLeadingWidth: 6,
                      leading: const Icon(Icons.call_to_action, color: AppColors.primary,),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Número: ${widget.chamado.id!}"),
                          Text(DateFormat('dd/MM/yyyy HH:mm').format(DateTime.parse(widget.chamado.data ?? "")), style: const TextStyle(fontSize: 12),)
                        ],
                      ),
                      subtitle: Text("Status: ${widget.chamado.status!}"),
                    ),
                  ],
                ),
              ),
            ),
          ],
        )
    );
  }
}
