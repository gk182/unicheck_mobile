import 'package:flutter/material.dart';

class ScheduleModel {
  final int scheduleId;
  final String courseName;
  final String roomName;
  final DateTime date;
  final TimeOfDay startTime;
  final TimeOfDay endTime;

  ScheduleModel({
    required this.scheduleId,
    required this.courseName,
    required this.roomName,
    required this.date,
    required this.startTime,
    required this.endTime,
  });

  factory ScheduleModel.fromJson(Map<String, dynamic> json) {
    final startParts = (json['startTime'] as String? ?? '00:00:00').split(':');
    final endParts = (json['endTime'] as String? ?? '00:00:00').split(':');

    return ScheduleModel(
      scheduleId: json['scheduleId'] ?? 0,
      courseName: json['courseName'] ?? '',
      roomName: json['roomName'] ?? '',
      date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
      startTime: TimeOfDay(
        hour: int.tryParse(startParts[0]) ?? 0,
        minute: int.tryParse(startParts[1]) ?? 0,
      ),
      endTime: TimeOfDay(
        hour: int.tryParse(endParts[0]) ?? 0,
        minute: int.tryParse(endParts[1]) ?? 0,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'scheduleId': scheduleId,
      'courseName': courseName,
      'roomName': roomName,
      'date': date.toIso8601String(),
      'startTime': '${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}:00',
      'endTime': '${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}:00',
    };
  }
}
