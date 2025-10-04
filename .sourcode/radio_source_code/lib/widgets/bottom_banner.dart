/*
 *  Single Radio - Flutter Full App
 *  Copyright (c) 2022–2025 Ilia Chirkunov. All rights reserved.
 *
 *  This project is licensed under the Envato Market Regular/Extended License.
 *  License details: https://codecanyon.net/licenses/standard
 *
 *  For support or inquiries: support@cheebeez.com
 */

import 'package:flutter/material.dart';
import 'package:single_radio/services/admob_service.dart';
import 'package:single_radio/controllers/scaffold_controller.dart';

class BottomBanner extends StatelessWidget {
  const BottomBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.only(
        bottom: MediaQuery.of(context).padding.bottom,
      ),
      child: ScaffoldController.isDrawerOpened
          ? const _Placeholder(width: 320, height: 50)
          : const _Banner(width: 320, height: 50),
    );
  }
}

class _Banner extends StatelessWidget {
  const _Banner({
    required this.width,
    required this.height,
  });

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return ConsentDialog(
      loading: _Placeholder(
        width: width,
        height: height,
      ),
      builder: () {
        return Container(
          alignment: Alignment.center,
          width: width,
          height: height,
          child: AdmobService.banner(
            width.toInt(),
            height.toInt(),
          ),
        );
      },
    );
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder({
    required this.width,
    required this.height,
  });

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
    );
  }
}
