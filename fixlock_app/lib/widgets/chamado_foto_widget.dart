import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fixlock_app/constants/app_constants.dart';
import 'package:fixlock_app/constants/controllers.dart';
import 'package:flutter/material.dart';

class ChamadoFotoWidget extends StatelessWidget {
  final String celPath;
  final String urlPath;
  final int index;
  final bool flAntes;
  const ChamadoFotoWidget(this.celPath, this.urlPath, this.index, this.flAntes, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(.5),
                offset: const Offset(5, 5),
                blurRadius: 3)
          ]),
      child: Stack(
        children: [
          GestureDetector(
            onTap: () async {
              await showDialog(
                  context: context,
                  builder: (_) {
                    if (urlPath.isNotEmpty) {
                      return CachedNetworkImage(
                        imageUrl: "$baseImgUrl/$urlPath",
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      );
                    }

                    if (celPath.isNotEmpty) {
                      return SizedBox(
                          //height: 140,
                          //width: 140,
                          child: Image.file(File(celPath)));
                    }
                    return Container();
                  });
            },
            child: Column(
              children: [
                celPath.isNotEmpty
                ? SizedBox(
                    height: 160,
                    width: 160,
                    child: Image.file(File(celPath)),
                  )
                : Expanded(
                  child: Center(
                    child: CachedNetworkImage(
                        imageUrl: "$baseImgUrl/$urlPath",
                        placeholder: (context, url) =>
                            const Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                  ),
                ),
              ],
            ),
          ),
          celPath.isNotEmpty
              ? Positioned(
                  right: 0.0,
                  top: 0.0,
                  child: GestureDetector(
                      onTap: () {
                        if (flAntes) {
                          imagePickController.removerFotoAntes(index);
                        } else {
                          imagePickController.removerFotoDepois(index);
                        }
                      },
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(width: 2.0, color: Colors.transparent),
                          color: Colors.white12
                        ), child: const Icon(
                        Icons.clear_outlined,
                        color: Colors.red,
                        size: 32,
                      ))))
              : const SizedBox(),
        ],
      ),
    );
  }
}
