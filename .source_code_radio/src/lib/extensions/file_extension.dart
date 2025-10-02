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

extension FileExtension on File {
  File get adaptPath => File(path.replaceAll('/', Platform.pathSeparator));

  bool? replaceContent(String from, String replace) {
    if (!existsSync()) return null;

    var content = readAsStringSync();
    if (!content.contains(from)) return false;

    content = content.replaceAll(from, replace);
    writeAsStringSync(content, flush: true);

    return true;
  }

  void deleteIfExistsSync() {
    if (existsSync()) deleteSync();
  }
}
