import 'package:fixlock_app/constants/controllers.dart';
import 'package:fixlock_app/models/chamado_model.dart';
import 'package:fixlock_app/models/condominio_model.dart';
import 'package:fixlock_app/models/dispositivo_model.dart';
import 'package:fixlock_app/widgets/chamado_checklist_widget.dart';
import 'package:fixlock_app/widgets/chamado_lista_foto_widget.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import '../../constants/color_pallet.dart';

class ChamadoScreen extends StatefulWidget {
  final int id;

  const ChamadoScreen({super.key, required this.id});

  @override
  State<ChamadoScreen> createState() => _ChamadoScreenState();
}

class _ChamadoScreenState extends State<ChamadoScreen> {
  ChamadoModel chamado = ChamadoModel();
  bool readonly = false;
  String title = "";
  bool loading = false;

  TextEditingController _observacaoEditingController = TextEditingController();

  late CondominioModel condominio;
  late DispositivoModel dispositivo;

  List<CondominioModel> listaCondominios = dbController.condominiosOrdem;
  List<DispositivoModel> listaDispositivos = dbController.dispositivosOrdem;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    loading = true;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (widget.id > 0) {
        title = "${widget.id} - CHAMADO";
        await chamadoController.obterChamado(widget.id).then((value) {
          setState(() {
            chamado = value;
            _observacaoEditingController.text = chamado.observacao!;
            if (chamado.id! > 0) {
              readonly = true;
            }

            condominio = dbController.condominiosOrdem
                .where((c) => c.id == chamado.condominioId)
                .first;
            dispositivo = dbController.dispositivosOrdem
                .where((c) => c.id == chamado.dispositivoId)
                .first;

            loading = false;
          });
        });
      } else {
        title = "NOVO CHAMADO";
        await chamadoController.obterChecklists().then((value) {
          setState(() {
            chamado.checklists = value;
            chamado.tecnicoId = userController.userModel.value.id;
            chamado.observacao = "";

            condominio = dbController.condominiosOrdem.first;
            chamado.condominioId = condominio.id;

            listaDispositivos = dbController.dispositivosOrdem
                .where((c) => c.condominioId == condominio.id)
                .toList();
            dispositivo = listaDispositivos.first;
            chamado.dispositivoId = dispositivo.id;

            loading = false;
          });
        });
      }

      await imagePickController.obterImagens(widget.id);

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return Future.error('Location permissions are denied');
        } else {
          userController.getCurrentLocation();
        }
      } else {
        userController.getCurrentLocation();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(title),
          centerTitle: true,
          backgroundColor: AppColors.primary,
        ),
        body: loading
            ? const Center(child: CircularProgressIndicator())
            : CustomScrollView(
                slivers: <Widget>[
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return Card(
                          elevation: 1,
                          margin: const EdgeInsets.all(2),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 2.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ChamadoChecklistWidget(
                                  checklist: chamado.checklists![index],
                                  readonly: readonly,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      childCount: chamado.checklists!.length,
                    ),
                  ),
                  SliverToBoxAdapter(
                      child: Card(
                    elevation: 1,
                    margin: const EdgeInsets.all(0),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 8.0, left: 16.0, bottom: 8.0),
                      child: Column(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 4.0, right: 26.0),
                            child: TextField(
                                enabled: !readonly,
                                controller: _observacaoEditingController,
                                decoration: const InputDecoration(
                                    labelStyle: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black),
                                    label: Text("Observação"),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: AppColors.textGrey),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: AppColors.primary),
                                    ),
                                    fillColor: Colors.white,
                                    border: InputBorder.none,
                                    suffixIcon: Icon(
                                      Icons.edit,
                                      color: AppColors.primary,
                                    )),
                                onChanged: (value) {
                                  chamado.observacao = value;
                                }),
                          ),
                        ],
                      ),
                    ),
                  )),
                  SliverToBoxAdapter(
                      child: Card(
                    elevation: 1,
                    margin: const EdgeInsets.all(4),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 8.0, left: 16.0, bottom: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Escolha o condomínio",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.black),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: DropdownButton<CondominioModel>(
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16),
                              value: condominio,
                              items:
                                  listaCondominios.map((CondominioModel cond) {
                                return DropdownMenuItem<CondominioModel>(
                                  enabled: !readonly,
                                  value: cond,
                                  child: Text(cond.nome,
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.red.withOpacity(.7))),
                                );
                              }).toList(),
                              onChanged: (CondominioModel? selectedItem) {
                                if (selectedItem != null) {
                                  setState(() {
                                    condominio = selectedItem;
                                    chamado.condominioId = selectedItem.id;
                                    listaDispositivos = dbController
                                        .dispositivosOrdem
                                        .where((c) =>
                                            c.condominioId ==
                                            chamado.condominioId)
                                        .toList();
                                    dispositivo = listaDispositivos.first;
                                  });
                                }
                              },
                              icon: const Icon(Icons.arrow_drop_down),
                              iconSize: 24,
                              elevation: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
                  SliverToBoxAdapter(
                      child: Card(
                    elevation: 1,
                    margin: const EdgeInsets.all(4),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 8.0, left: 16.0, bottom: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Escolha o dispositivo",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.black),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: DropdownButton<DispositivoModel>(
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16),
                              value: dispositivo,
                              items: listaDispositivos
                                  .map((DispositivoModel cond) {
                                return DropdownMenuItem<DispositivoModel>(
                                  enabled: !readonly,
                                  value: cond,
                                  child: Text(cond.descricao,
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.red.withOpacity(.7))),
                                );
                              }).toList(),
                              onChanged: (DispositivoModel? selectedItem) {
                                if (selectedItem != null) {
                                  setState(() {
                                    dispositivo = selectedItem;
                                    chamado.dispositivoId = selectedItem.id;
                                  });
                                }
                              },
                              icon: const Icon(Icons.arrow_drop_down),
                              iconSize: 24,
                              elevation: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
                  chamado.status != null
                      ? SliverToBoxAdapter(
                          child: Card(
                          elevation: 1,
                          margin: const EdgeInsets.all(4),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 8.0, left: 16.0, bottom: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Text("Status - ",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                        )),
                                    Text("${chamado.status}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                            color: Colors.red.withOpacity(.7))),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ))
                      : const SliverToBoxAdapter(),
                  const SliverToBoxAdapter(
                    child: SizedBox(
                      height: 16,
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return const Card(
                          elevation: 0,
                          margin: EdgeInsets.all(8),
                          child: Padding(
                            padding: EdgeInsets.only(top: 8.0),
                            child: Column(
                              children: [
                                Center(
                                  child: Text("FOTOS ANTES",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20,
                                      )),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                ChamadoListaFotoWidget(flAntes: true),
                                SizedBox(
                                  height: 8,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      childCount: 1,
                    ),
                  ),
                  chamado.id != null && chamado.id! > 0
                      ? SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return const Card(
                          elevation: 0,
                          margin: EdgeInsets.all(8),
                          child: Padding(
                            padding: EdgeInsets.only(top: 8.0),
                            child: Column(
                              children: [
                                Center(
                                  child: Text("FOTOS DEPOIS",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20,
                                      )),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                ChamadoListaFotoWidget(flAntes: false),
                                SizedBox(
                                  height: 8,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      childCount: 1,
                    ),
                  ) : const SliverToBoxAdapter(),
                  chamado.interacoes != null && chamado.interacoes!.isNotEmpty
                      ? const SliverToBoxAdapter(
                          child: Card(
                          elevation: 1,
                          margin: EdgeInsets.all(4),
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: 8.0, left: 16.0, bottom: 8.0),
                            child: Center(
                              child: Text("INTERAÇÕES",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 20,
                                  )),
                            ),
                          ),
                        ))
                      : const SliverToBoxAdapter(),
                  chamado.interacoes != null && chamado.interacoes!.isNotEmpty
                      ? SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              return Card(
                                color: Colors.red.withOpacity(.45),
                                elevation: 1,
                                margin: const EdgeInsets.only(
                                    left: 4, right: 4, top: 1),
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 1.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ListTile(
                                        title: Text(
                                            "${chamado.interacoes![index].status} - ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.parse(chamado.interacoes![index].data ?? ""))}",
                                            style: const TextStyle(
                                              color: Colors.black87,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 15,
                                            )),
                                        subtitle: Text(
                                            "${chamado.interacoes![index].observacao}",
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 12,
                                            )),
                                        minVerticalPadding: 16,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            childCount: chamado.interacoes!.length,
                          ),
                        )
                      : const SliverToBoxAdapter(),
                  SliverToBoxAdapter(
                      child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: AppColors.primary, // foreground
                        ),
                        onPressed: () async {
                          await chamadoController.salvar(chamado);
                        },
                        child: Text(!readonly ? 'ENVIAR CHAMADO' : 'ENVIAR FOTOS',
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  )),
                  const SliverToBoxAdapter(
                      child: SizedBox(
                    height: 20,
                  ))
                ],
              ));
  }
}
