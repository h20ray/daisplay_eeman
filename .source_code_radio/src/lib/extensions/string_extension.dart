/*
 *  Single Radio - Flutter Full App
 *  Copyright (c) 2022–2025 Ilia Chirkunov. All rights reserved.
 *
 *  This project is licensed under the Envato Market Regular/Extended License.
 *  License details: https://codecanyon.net/licenses/standard
 *
 *  For support or inquiries: support@cheebeez.com
 */

extension StringExtension on String {
  String between(String start, String end) {
    if (start.isEmpty && end.isEmpty) return '';

    final startIndex = indexOf(start);
    if (startIndex == -1) return '';

    final endIndex =
        end.isEmpty ? length : indexOf(end, startIndex + start.length);
    if (endIndex == -1) return '';

    return substring(startIndex + start.length, endIndex);
  }

  String betweenTag(String tag) {
    if (tag.isEmpty) return '';
    return between('<$tag>', '</$tag>');
  }
}
