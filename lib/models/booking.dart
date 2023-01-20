// To parse this JSON data, do
//
//     final booking = bookingFromJson(jsonString);

import 'dart:convert';

List<Booking?>? bookingFromJson(String str) => json.decode(str) == null
    ? []
    : List<Booking?>.from(json.decode(str)!.map((x) => Booking.fromJson(x)));

String bookingToJson(List<Booking?>? data) => json.encode(
    data == null ? [] : List<dynamic>.from(data!.map((x) => x!.toJson())));

class Booking {
  Booking({
    this.id,
    this.name,
    this.court,
    this.startAt,
    this.startAtReadable,
    this.startHour,
    this.startMinute,
    this.endAt,
    this.endAtReadable,
    this.endHour,
    this.endMinute,
  });

  int? id;
  String? name;
  int? court;
  String? startAt;
  String? startAtReadable;
  int? startHour;
  int? startMinute;
  String? endAt;
  String? endAtReadable;
  int? endHour;
  int? endMinute;

  factory Booking.fromJson(Map<String, dynamic> json) => Booking(
        id: json["id"],
        name: json["name"],
        court: json["court"],
        startAt: json["start_at"],
        startAtReadable: json["start_at_readable"],
        startHour: json["start_hour"],
        startMinute: json["start_minute"],
        endAt: json["end_at"],
        endAtReadable: json["end_at_readable"],
        endHour: json["end_hour"],
        endMinute: json["end_minute"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "court": court,
        "start_at": startAt,
        "start_at_readable": startAtReadable,
        "start_hour": startHour,
        "start_minute": startMinute,
        "end_at": endAt,
        "end_at_readable": endAtReadable,
        "end_hour": endHour,
        "end_minute": endMinute,
      };
}
