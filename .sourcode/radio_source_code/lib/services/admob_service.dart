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

class AdmobService {
  static const isEnabled = false;

  static Widget banner(int width, int height) {
    return const SizedBox.shrink();
  }
}

class ConsentDialog extends StatelessWidget {
  const ConsentDialog({
    super.key,
    required this.loading,
    required this.builder,
  });

  final Widget loading;
  final Function builder;

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
