package com.example.busreservation.repo;

import com.example.busreservation.entity.BusSchedule;
import com.example.busreservation.entity.Customer;
import com.example.busreservation.entity.Reservation;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface ReservationRepository extends JpaRepository<Reservation, Long> {
    Optional<List<Reservation>> findByCustomer(Customer customer);
    Optional<List<Reservation>> findByBusScheduleAndDepartureDate(BusSchedule busSchedule, String departureDate);

}
