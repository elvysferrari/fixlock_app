import 'package:fixlock_app/constants/controllers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/color_pallet.dart';
import '../../widgets/chamado_widget.dart';
import 'chamado_screen.dart';

class ListaChamadoScreen extends StatefulWidget {
  const ListaChamadoScreen({super.key});

  @override
  State<ListaChamadoScreen> createState() => _ListaChamadoScreenState();
}

class _ListaChamadoScreenState extends State<ListaChamadoScreen> with SingleTickerProviderStateMixin {

  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 1, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("MEUS CHAMADOS"),
        centerTitle: true,
        backgroundColor: AppColors.primary,
      ),
      body: TabBarView(
        controller: tabController,
        children: const <Widget>[
          ChamadoTab(),
        ],
      ),
    );
  }
}
class ChamadoTab extends StatefulWidget {
  const ChamadoTab({super.key});

  @override
  ChamadoTabState createState() => ChamadoTabState();
}

class ChamadoTabState extends State<ChamadoTab>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await chamadoController.obterChamados();
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            Get.to(() => const ChamadoScreen(id: 0));
          },
          backgroundColor: AppColors.primary,
          child: const Icon(Icons.add, color: Colors.white,),
        ),
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: SizedBox(
            height: 50.0,
            child: TabBar(
              indicatorColor: AppColors.primary,
              unselectedLabelColor: AppColors.textGrey,
              labelColor: AppColors.textBlack,
              tabs: [
                Tab(
                  text: "ABERTOS",
                ),
                Tab(
                  text: "FINALIZADOS",
                )
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: [
            Obx(() =>
                ListView.builder(
                    itemCount: chamadoController.chamadosAbertos.length,
                    itemBuilder: (context, index) {
                      return ChamadoWidget(chamado: chamadoController.chamadosAbertos[index],);
                    }),
            ),

            Obx(() =>
                ListView.builder(
                    itemCount: chamadoController.chamadosFinalizados.length,
                    itemBuilder: (context, index) {
                      return ChamadoWidget(chamado: chamadoController.chamadosFinalizados[index],);
                    }),
            ),

          ],
        ),
      ),
    );
  }
}