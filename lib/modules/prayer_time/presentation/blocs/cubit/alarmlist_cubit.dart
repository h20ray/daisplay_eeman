import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:quran_app/common/local_data/alarm_list_local_data.dart';
import 'package:quran_app/common/services/notification_permission_service.dart';
import 'package:quran_app/common/services/services.dart';

/// Cubit to manage the list of alarms
class AlarmListCubit extends Cubit<List<DateTime>> {
  /// Constructor initializes the cubit with the [alarmStorage] instance
  AlarmListCubit(this.alarmStorage) : super([]);

  /// Local storage instance for alarms
  final AlarmListLocalData alarmStorage;

  /// Previous state of the cubit
  List<DateTime>? previousState = [];

  /// Initializes the cubit by retrieving the alarms from local storage
  Future<void> init() async {
    final initial = await alarmStorage.getListValue();

    if (initial != null) {
      final result = initial;
      final alarms =
          result.map((encoded) => DateTime.parse(encoded as String)).toList();
      emit(alarms);
    } else {
      emit([]);
    }
  }

  /// Saves the previous state of the cubit
  @override
  void onChange(Change<List<DateTime>> change) {
    super.onChange(change);
    previousState = change.currentState;
  }

  /// Updates the reminder state and local data
  Future<void> updateReminder(List<DateTime> updatedList) async {
    final reminders =
        updatedList.map((dateTime) => dateTime.toIso8601String()).toList();
    await alarmStorage.setListValue(reminders);
    emit([...updatedList]);
  }

  /// Adds a new reminder and updates local storage
  Future<void> onAddReminder(DateTime hour) async {
    final updatedList = <DateTime>[...state, hour];
    final reminders =
        updatedList.map((dateTime) => dateTime.toIso8601String()).toList();
    await alarmStorage.setListValue(reminders);
    emit(updatedList);
  }

  /// Removes a reminder from the list and updates local storage
  Future<void> onRemoveReminder(DateTime hour) async {
    final updatedList = <DateTime>[...state]..remove(hour);
    final reminders =
        updatedList.map((dateTime) => dateTime.toIso8601String()).toList();
    await alarmStorage.setListValue(reminders);
    emit(updatedList);
  }

  /// Clears all reminders and updates local storage
  Future<void> clearReminder() async {
    state.clear();
    final reminders =
        state.map((dateTime) => dateTime.toIso8601String()).toList();
    await alarmStorage.setListValue(reminders);
    emit([...state]);
  }

  Future<void> scheduleNotification({
    required bool isPassed,
    required DateTime selectedDate,
    required String title,
    BuildContext? context,
  }) async {
    final permissionService = NotificationPermissionService();

    // Check basic notification permission
    final isNotificationGranted =
        await permissionService.isNotificationPermissionGranted();
    if (!isNotificationGranted) {
      if (context != null) {
        final dialogResult =
            await permissionService.showPermissionRationaleDialog(context);
        if (!dialogResult) return;
      } else {
        await permissionService.requestNotificationPermission();
      }
    }

    // Check exact alarm permission for Android 12+
    final isExactAlarmGranted =
        await permissionService.isExactAlarmPermissionGranted();
    if (!isExactAlarmGranted && context != null) {
      final dialogResult =
          await permissionService.showExactAlarmPermissionDialog(context);
      if (!dialogResult) {
        // Continue with inexact scheduling if user denies exact alarm permission
        // Note: In production, consider using a proper logging service
      }
    }

    if (isPassed) {
      if (state.contains(selectedDate)) {
        await onRemoveReminder(selectedDate);
      } else {
        await onAddReminder(selectedDate);
      }
    }

    try {
      await NotificationHelper().scheduledNotification(
        hour: selectedDate.hour,
        minutes: selectedDate.minute,
        id: selectedDate.millisecond,
        title: title,
        sound: 'adzan',
      );
    } catch (e) {
      // The notification service will handle fallback to inexact scheduling
      // Note: In production, consider using a proper logging service
      rethrow;
    }
  }
}
