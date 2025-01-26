package com.example.busreservation.service.impl;

import com.example.busreservation.entity.Bus;
import com.example.busreservation.repo.BusRepository;
import com.example.busreservation.service.BusService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class BusServiceImpl implements BusService {
    @Autowired
    private BusRepository busRepository;

    @Override
    public Bus addBus(Bus bus) {
        return busRepository.save(bus);
    }

    @Override
    public List<Bus> getAllBus() {
        return busRepository.findAll();
    }
}
