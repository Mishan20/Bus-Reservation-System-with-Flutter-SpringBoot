package com.example.busreservation.repo;

import com.example.busreservation.entity.Bus;
import org.springframework.data.jpa.repository.JpaRepository;

public interface BusRepository extends JpaRepository<Bus, Long> {

}
