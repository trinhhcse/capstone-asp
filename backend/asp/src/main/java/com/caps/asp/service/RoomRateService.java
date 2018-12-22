package com.caps.asp.service;

import com.caps.asp.model.TbRoomRate;
import com.caps.asp.repository.RoomRateRepository;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.util.List;


@Service
public class RoomRateService {
    public RoomRateRepository roomRateRepository;

    public RoomRateService(RoomRateRepository roomRateRepository) {
        this.roomRateRepository = roomRateRepository;
    }

    public TbRoomRate findAllByRoomIdAndUserId(Integer roomId, Integer userId) {
        return roomRateRepository.findByRoomIdAndUserId(roomId,userId);
    }

    public void saveRoomRate(TbRoomRate roomRate){
        roomRateRepository.saveAndFlush(roomRate);
    }


    public List<TbRoomRate> findAllByRoomId (int roomId) {
        return roomRateRepository.findAllByRoomId(roomId);
    }
    public Page<TbRoomRate> findAllByRoomId (int roomId,Pageable pageable) {
        return roomRateRepository.findAllByRoomId(roomId,pageable);
    }

    public void removeByRoomId(int roomId){
        roomRateRepository.removeAllByRoomId(roomId);
    }

    public Page<TbRoomRate> findAllByRoomIdOrderByDateDesc(int roomId, int page, int offset) {
        int actualPage = page - 1;
        Pageable pageable = PageRequest.of(actualPage,offset);
        return roomRateRepository.findAllByRoomIdOrderByDateDesc(roomId, pageable);
    }
}
