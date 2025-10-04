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
import 'package:android_minimizer/android_minimizer.dart';
import 'package:single_radio/services/admob_service.dart';
import 'package:single_radio/theme.dart';
import 'package:single_radio/widgets/sidebar.dart';
import 'package:single_radio/widgets/expanded_scroll_view.dart';
import 'package:single_radio/widgets/bottom_banner.dart';
import 'package:single_radio/widgets/background_image.dart';
import 'package:single_radio/controllers/scaffold_controller.dart';

class Screen extends StatefulWidget {
  const Screen({
    super.key,
    required this.title,
    this.home = false,
    required this.child,
    this.padding,
    this.hideOverscrollIndicator = false,
    this.backgroundImage = false,
  });

  final String title;
  final bool home;
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final bool hideOverscrollIndicator;
  final bool backgroundImage;

  @override
  State<Screen> createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {
  @override
  Widget build(BuildContext context) {
    final defaultPadding = EdgeInsets.symmetric(
      horizontal: MediaQuery.of(context).size.width * 0.08,
    );

    return AndroidMinimizer(
      minimize: widget.home ? true : false,
      child: BackgroundImage(
        enable: widget.backgroundImage,
        child: Scaffold(
          key: widget.home ? ScaffoldController.scaffoldKey : null,
          appBar: AppBar(
            title: Text(widget.title),
            backgroundColor: widget.backgroundImage ? Colors.transparent : null,
            elevation: widget.backgroundImage ? 0 : null,
          ),
          onDrawerChanged: (value) {
            ScaffoldController.isDrawerOpened = value;
            setState(() {});
          },
          drawer: widget.home ? Sidebar() : null,
          backgroundColor: widget.backgroundImage
              ? Colors.transparent
              : AppTheme.backgroundColor,
          body: ExpandedScrollView(
            hideOverscrollIndicator: widget.hideOverscrollIndicator,
            child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: widget.padding ?? defaultPadding,
                    child: widget.child,
                  ),
                ),
                if (AdmobService.isEnabled && widget.home) BottomBanner(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
