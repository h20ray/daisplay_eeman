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

class FadedBox extends StatelessWidget {
  const FadedBox({
    super.key,
    this.width,
    this.height,
    this.gradientWidth,
    this.gradientHeight,
    required this.colors,
    this.alignment = AlignmentDirectional.topStart,
    required this.child,
  });

  final double? width;
  final double? height;
  final double? gradientWidth;
  final double? gradientHeight;
  final List<Color> colors;
  final AlignmentGeometry alignment;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        children: [
          child,
          Align(
            alignment: alignment,
            child: Container(
              width: gradientWidth,
              height: gradientHeight,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: colors,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
