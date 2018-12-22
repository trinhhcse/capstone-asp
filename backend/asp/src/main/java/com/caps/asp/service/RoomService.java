package com.caps.asp.service;

import com.caps.asp.model.TbRoom;
import com.caps.asp.repository.RoomRepository;
import com.caps.asp.service.filter.Search;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Transactional
public class RoomService {
    public final RoomRepository roomRepository;

    public RoomService(RoomRepository roomRepository) {
        this.roomRepository = roomRepository;
    }

    public int saveRoom(TbRoom room) {
            return roomRepository.saveAndFlush(room).getRoomId();
    }

    public TbRoom findRoomById(int roomId) {
        return roomRepository.findByRoomId(roomId);
    }

    public void deleteRoom(int roomId) {
        roomRepository.deleteById(roomId);
    }

    public List<TbRoom> findAllRoom() {
        return roomRepository.findAll();
    }

    public Page<TbRoom> findAllRoomByUserId(int userId, Pageable pageable) {
        return roomRepository.findAllByUserId(userId, pageable);
    }

    public TbRoom findByUserIdAndRoomId(int userId, int roomId) {
        return roomRepository.findByUserIdAndRoomId(userId, roomId);
    }

    public List<TbRoom> findAllRoomByDistrictId(int districtId) {
        return roomRepository.findAllByDistrictId(districtId);
    }

    public Page<TbRoom> getAllByStatusId(int page, int items, int statusId) {
        int actualPage = page - 1;
        Pageable pageable = PageRequest.of(actualPage, items);

        return roomRepository.findAllByStatusIdOrderByDateDesc(statusId, pageable);
    }

    public List<TbRoom> getAllByUserId(int userId){
        return roomRepository.getAllByUserId(userId);
    }

    public List<TbRoom> findByLikeAddress(Search search) {
        return roomRepository.findAll(search);
    }


}
