
import '../models/bus_model.dart';
import '../models/bus_reservation.dart';
import '../models/bus_schedule.dart';
import '../models/but_route.dart';
import '../utils/constants.dart';

class TempDB {
  static List<Bus> tableBus = [
    Bus(busId: 1, busName: 'Pasindu Travels', busNumber: 'Test-0001', busType: busTypeACBusiness, totalSeat: 18, ticketPrice: 1000),
    Bus(busId: 2, busName: 'Ashoka Travels', busNumber: 'Test-0002', busType: busTypeACEconomy, totalSeat: 32, ticketPrice: 1500),
    Bus(busId: 3, busName: 'Damith Travels', busNumber: 'Test-0003', busType: busTypeNonAc, totalSeat: 40, ticketPrice: 2000),
  ];

  static List<BusRoute> tableRoute = [
    BusRoute(routeId: 1, routeName: 'Kandy-Colombo', cityFrom: 'Kandy', cityTo: 'Colombo', distanceInKm: 70),
    BusRoute(routeId: 2, routeName: 'Kandy-Panadura', cityFrom: 'Kandy', cityTo: 'Panadura', distanceInKm: 80),
  ];
  static List<BusSchedule> tableSchedule = [
    BusSchedule(scheduleId: 1, bus: tableBus[0], busRoute: tableRoute[0], departureTime: '18:00', ticketPrice: 1000,),
    BusSchedule(scheduleId: 2, bus: tableBus[1], busRoute: tableRoute[0], departureTime: '20:00', ticketPrice: 1000,),
    BusSchedule(scheduleId: 3, bus: tableBus[2], busRoute: tableRoute[0], departureTime: '22:00', ticketPrice: 2000,),
    BusSchedule(scheduleId: 4, bus: tableBus[0], busRoute: tableRoute[1], departureTime: '18:00', ticketPrice: 3000,),
  ];
  static List<BusReservation> tableReservation = [];
}