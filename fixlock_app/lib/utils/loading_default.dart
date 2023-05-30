import 'package:flutter/material.dart';
import 'package:get/get.dart';

showLoadingLogin(){
  Get.defaultDialog(
      title: "Entrando...",
      content: CircularProgressIndicator(),
      barrierDismissible: false
  );
}

showLoading(){
  Get.defaultDialog(
      title: "Carregando...",
      content: CircularProgressIndicator(),
      barrierDismissible: false
  );
}

showLoadingPost(){
  Get.defaultDialog(
      title: "Postando...",
      content: CircularProgressIndicator(),
      barrierDismissible: false
  );
}

dismissLoadingWidget(){
  Get.back();
}