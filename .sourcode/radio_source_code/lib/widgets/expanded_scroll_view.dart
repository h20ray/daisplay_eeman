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
import 'package:single_radio/helpers/hide_overscroll_indicator.dart';

class ExpandedScrollView extends StatelessWidget {
  const ExpandedScrollView({
    super.key,
    required this.child,
    this.hideOverscrollIndicator = false,
  });

  final Widget child;
  final bool hideOverscrollIndicator;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      scrollBehavior:
          hideOverscrollIndicator ? HideOverscrollIndicator() : null,
      physics: hideOverscrollIndicator ? const ClampingScrollPhysics() : null,
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: child,
        ),
      ],
    );
  }
}
