// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'bus_schedule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_BusSchedule _$$_BusScheduleFromJson(Map<String, dynamic> json) =>
    _$_BusSchedule(
      scheduleId: json['scheduleId'] as int?,
      bus: Bus.fromJson(json['bus'] as Map<String, dynamic>),
      busRoute: BusRoute.fromJson(json['busRoute'] as Map<String, dynamic>),
      departureTime: json['departureTime'] as String,
      ticketPrice: json['ticketPrice'] as int,
      discount: json['discount'] as int? ?? 0,
      processingFee: json['processingFee'] as int? ?? 100,
    );

Map<String, dynamic> _$$_BusScheduleToJson(_$_BusSchedule instance) =>
    <String, dynamic>{
      'scheduleId': instance.scheduleId,
      'bus': instance.bus,
      'busRoute': instance.busRoute,
      'departureTime': instance.departureTime,
      'ticketPrice': instance.ticketPrice,
      'discount': instance.discount,
      'processingFee': instance.processingFee,
    };
