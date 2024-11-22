import 'package:bus_reservation/datasource/data_source.dart';
import 'package:bus_reservation/datasource/dummy_data_source.dart';
import 'package:bus_reservation/models/bus_reservation.dart';
import 'package:bus_reservation/models/bus_schedule.dart';
import 'package:bus_reservation/models/but_route.dart';
import 'package:flutter/material.dart';

class AppDataProvider extends ChangeNotifier {
  List<BusSchedule> _scheduleList = [];
  List<BusSchedule> get scheduleList => _scheduleList;
  final DataSource _dataSource = DummyDataSource();

  Future<BusRoute?> getRouteByCityFromAndCityTo(
      String cityFrom, String cityTo) {
    return _dataSource.getRouteByCityFromAndCityTo(cityFrom, cityTo);
  }

  Future<List<BusSchedule>> getSchedulesByRouteName(String routeName) {
    return _dataSource.getSchedulesByRouteName(routeName);
  }

  Future<List<BusReservation>> getReservationsByScheduleAndDepartureDate(int scheduleId, String departureDate) {
    return _dataSource.getReservationsByScheduleAndDepartureDate(scheduleId, departureDate);
  }
}
