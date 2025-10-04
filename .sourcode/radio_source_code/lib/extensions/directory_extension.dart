/*
 *  Single Radio - Flutter Full App
 *  Copyright (c) 2022–2025 Ilia Chirkunov. All rights reserved.
 *
 *  This project is licensed under the Envato Market Regular/Extended License.
 *  License details: https://codecanyon.net/licenses/standard
 *
 *  For support or inquiries: support@cheebeez.com
 */

import 'dart:io';

extension DirectoryExtension on Directory {
  Directory get adaptPath =>
      Directory(path.replaceAll('/', Platform.pathSeparator));

  void deleteIfExistsSync({bool recursive = false}) {
    if (existsSync()) deleteSync(recursive: recursive);
  }
}
