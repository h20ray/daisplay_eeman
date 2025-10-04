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
import 'package:single_radio/extensions/directory_extension.dart';
import 'package:single_radio/extensions/file_extension.dart';

void main() {
  step1();
  step2();
  step3();
  //step4();
}

// Clean project.
void step1() {
  File('ios/Podfile.lock').adaptPath.deleteIfExistsSync();
  Directory('ios/Pods').adaptPath.deleteIfExistsSync(recursive: true);
  Directory('ios/.symlinks').adaptPath.deleteIfExistsSync(recursive: true);
}

// Remove dependencies from 'pubspec.yaml' file.
void step2() {
  const filename = 'pubspec.yaml';
  const line = 'google_mobile_ads: 6.0.0';

  final content = File(filename).adaptPath.readAsStringSync();
  if (content.contains('#$line')) {
    stdout.write('Admob is already disabled.\n');
    exit(0);
  }

  File(filename).adaptPath.replaceContent(line, '#$line');
}

// Rename Off and Dummy files.
void step3() {
  const filename = 'lib/services/admob_service.dart';
  const filenameOff = 'lib/services/admob_service.off';
  const filenameDummy = 'lib/services/admob_service.dummy';

  if (!File(filename).adaptPath.existsSync()) {
    stdout.write('File "$filename" not found.\n');
    exit(0);
  }

  if (!File(filenameDummy).adaptPath.existsSync()) {
    stdout.write('File "$filenameDummy" not found.\n');
    exit(0);
  }

  File(filename).adaptPath.renameSync(File(filenameOff).adaptPath.path);
  File(filenameDummy).adaptPath.renameSync(File(filename).adaptPath.path);
}

// Remove the NSUserTrackingUsageDescription key from Info.plist.
void step4() {
  const filename = 'ios/Runner/Info.plist';
  const line1 = "<key>NSUserTrackingUsageDescription</key>";
  const line1tmp = "<key>AdmobKey1</key>";
  const line2 =
      "<string>This identifier will be used to deliver personalized ads to you.</string>";
  const line2tmp = "<string>AdmobString1</string>";

  File(filename).adaptPath.replaceContent(line1, line1tmp);
  File(filename).adaptPath.replaceContent(line2, line2tmp);
}
