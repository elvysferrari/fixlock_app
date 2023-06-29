import 'package:flutter/material.dart';

import '../constants/color_pallet.dart';
import '../constants/controllers.dart';
import '../models/chamado_model.dart';

class ChamadoChecklistWidget extends StatefulWidget {
  final Checklists checklist;
  final bool readonly;

  const ChamadoChecklistWidget(
      {super.key, required this.checklist, required this.readonly});

  @override
  State<ChamadoChecklistWidget> createState() => _ChamadoChecklistWidgetState();
}

class _ChamadoChecklistWidgetState extends State<ChamadoChecklistWidget> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    _textEditingController.text = widget.checklist.observacao ?? "";
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        widget.checklist.flObservacao == false
            ? CheckboxListTile(
                activeColor: AppColors.primary,
                dense: true,
                //font change
                title: Text(
                  widget.checklist.descricao!,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.1),
                ),
                value: widget.checklist.valor != null
                    ? widget.checklist.valor == 1
                        ? true
                        : false
                    : false,
                onChanged: (bool? value) {
                  if (widget.readonly == true) return;
                  setState(() {
                    if (value == true) {
                      widget.checklist.valor = 1;
                    } else {
                      widget.checklist.valor = 0;
                    }
                  });
                })
            : Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 26.0),
                child: TextField(
                  enabled: !widget.readonly,
                  controller: _textEditingController,
                  decoration: InputDecoration(
                    hintText: "Decreva aqui",
                    labelStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                    label: Text(widget.checklist.descricao!),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.textGrey),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.primary),
                    ),
                    fillColor: Colors.white,
                    border: InputBorder.none, suffixIcon: const Icon(Icons.edit, color: AppColors.primary,)
                  ),
                  onChanged: (value) {
                    setState(() {
                      widget.checklist.observacao = value;
                    });
                  },
                ),
              ),
      ],
    );
  }
}
