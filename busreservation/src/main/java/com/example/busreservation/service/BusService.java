package com.example.busreservation.service;

import com.example.busreservation.entity.Bus;

import java.util.List;

public interface BusService {
    Bus addBus(Bus bus);
    List<Bus> getAllBus();
}
