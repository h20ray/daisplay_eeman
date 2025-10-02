/*
 *  Single Radio - Flutter Full App
 *  Copyright (c) 2022–2025 Ilia Chirkunov. All rights reserved.
 *
 *  This project is licensed under the Envato Market Regular/Extended License.
 *  License details: https://codecanyon.net/licenses/standard
 *
 *  For support or inquiries: support@cheebeez.com
 */

extension DurationExtension on Duration {
  String format() {
    final hours = inHours;
    final minutes = inMinutes % 60;
    final seconds = inSeconds % 60;

    return '${hours.toString().padLeft(2, "0")}:'
        '${minutes.toString().padLeft(2, "0")}:'
        '${seconds.toString().padLeft(2, "0")}';
  }
}
