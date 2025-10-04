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
  step4();
  step5();
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
  const dep1 = 'firebase_core: 4.1.0';
  const dep2 = 'firebase_messaging: 16.0.1';
  const dep3 = 'flutter_local_notifications: 19.4.2';

  final content = File(filename).adaptPath.readAsStringSync();
  if (content.contains('#$dep1')) {
    stdout.write('Fsm is already disabled.\n');
    exit(0);
  }

  File(filename).adaptPath.replaceContent(dep1, '#$dep1');
  File(filename).adaptPath.replaceContent(dep2, '#$dep2');
  File(filename).adaptPath.replaceContent(dep3, '#$dep3');
}

// Rename Off and Dummy files.
void step3() {
  const filename = 'lib/services/fcm_service.dart';
  const filenameOff = 'lib/services/fcm_service.off';
  const filenameDummy = 'lib/services/fcm_service.dummy';

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

// Remove Push Notifications capability from Xcode.
void step4() {
  const filename = 'ios/Runner/Runner.entitlements';
  const debugFilename = 'ios/Runner/RunnerDebug.entitlements';
  const entitlements = '''<dict>
	<key>aps-environment</key>
	<string>development</string>
</dict>''';

  File(filename).adaptPath.replaceContent(entitlements, '<dict/>');
  File(debugFilename).adaptPath.replaceContent(entitlements, '<dict/>');
}

// Remove firebase from gradle.
void step5() {
  const filename1 = 'android/settings.gradle.kts';
  const filename2 = 'android/app/build.gradle.kts';

  const line1 = 'id("com.google.gms.google-services")';
  const line2 = 'id("com.google.gms.google-services")';
  const line3 = 'implementation(platform("com.google.firebase:firebase-bom';
  const line4 = 'implementation("com.google.firebase:firebase-analytics")';
  const line5 = 'isCoreLibraryDesugaringEnabled = true';
  const line6 = 'coreLibraryDesugaring("com.android.tools:desugar_jdk_libs';

  File(filename1).adaptPath.replaceContent(line1, '//$line1');
  File(filename2).adaptPath.replaceContent(line2, '//$line2');
  File(filename2).adaptPath.replaceContent(line3, '//$line3');
  File(filename2).adaptPath.replaceContent(line4, '//$line4');
  File(filename2).adaptPath.replaceContent(line5, '//$line5');
  File(filename2).adaptPath.replaceContent(line6, '//$line6');
}
