package com.caps.asp.service;

import com.caps.asp.model.TbRoomHasUser;
import com.caps.asp.repository.RoomHasUserRepository;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Transactional
public class RoomHasUserService {
    public final RoomHasUserRepository roomHasUserRepository;

    public RoomHasUserService(RoomHasUserRepository roomHasUserRepository) {
        this.roomHasUserRepository = roomHasUserRepository;
    }

    public void saveRoomMember(TbRoomHasUser tbRoomHasUser) {
        roomHasUserRepository.save(tbRoomHasUser);
    }

    public List<TbRoomHasUser> getAllByRoomId(int roomId) {
        return roomHasUserRepository.findAllByRoomId(roomId);
    }

    public TbRoomHasUser findByUserIdAndRoomId(int userId, int roomId) {
        return roomHasUserRepository.findByUserIdAndRoomId(userId, roomId);
    }

    public void removeRoomMember(int userId) {
        roomHasUserRepository.removeByUserId(userId);
    }

    public TbRoomHasUser findByUserId(int userId) {
        return roomHasUserRepository.findByUserId(userId);
    }

    public List<TbRoomHasUser> findByRoomIdAndDateOutIsNull(int roomId) {
        return roomHasUserRepository.findAllByRoomIdAndDateOutIsNull(roomId);
    }

    public TbRoomHasUser findTbRoomHasUserByUserIdAnAndDateOutIsNull(int userId) {
        return roomHasUserRepository.findTbRoomHasUserByUserIdAndDateOutIsNull(userId);
    }

    public void removeAllByRoomId(int roomId) {
        roomHasUserRepository.removeAllByRoomId(roomId);
    }

    public TbRoomHasUser getCurrentRoom(int userId) {
        return roomHasUserRepository.findByUserIdAndDateOutIsNull(userId);
    }

    public Page<TbRoomHasUser> getHistoryRoom(int page, int items, int userId) {
        int actualPage = page - 1;
        Pageable pageable = PageRequest.of(actualPage, items);
        return roomHasUserRepository.findAllByUserIdOrderByDateOutDesc(userId, pageable);
    }

    public TbRoomHasUser findByUserIdAndRoomIdAndDateOutIsNull(int userId, int roomId) {
        return roomHasUserRepository.findByUserIdAndRoomIdAndDateOutIsNull(userId, roomId);
    }
}
