package com.caps.asp.service;

import com.caps.asp.model.TbRoomHasUtility;
import com.caps.asp.repository.RoomHasUtilityRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Transactional
public class RoomHasUtilityService {
    public final RoomHasUtilityRepository roomHasUtilityRepository;

    public RoomHasUtilityService(RoomHasUtilityRepository roomHasUtilityRepository) {
        this.roomHasUtilityRepository = roomHasUtilityRepository;
    }

    public void saveRoomHasUtility(TbRoomHasUtility roomHasUtility){
        roomHasUtilityRepository.saveAndFlush(roomHasUtility);
    }
    public void deleteAllRoomHasUtilityByRoomId(int roomId){
        roomHasUtilityRepository.deleteAllByRoomId(roomId);
    }
    public List<TbRoomHasUtility> findAllByRoomId(int roomId){return roomHasUtilityRepository.findAllByRoomId(roomId);}
}
