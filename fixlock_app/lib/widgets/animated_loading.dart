import 'package:fixlock_app/constants/color_pallet.dart';
import 'package:flutter/material.dart';

class AnimatedLoadingWidget extends StatelessWidget {
  const AnimatedLoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      height: 60,
      child: const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(
            Colors.blueAccent
          ),
          backgroundColor: AppColors.textGrey,
        ),
      ),
    );
  }
}
