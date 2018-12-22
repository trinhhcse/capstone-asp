package com.caps.asp.repository;


import com.caps.asp.model.TbRoomRate;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;


public interface RoomRateRepository extends JpaRepository<TbRoomRate, Integer> {
   TbRoomRate findByRoomIdAndUserId(int roomId, int userId);
   List<TbRoomRate> findAllByRoomId(int roomId);
   Page<TbRoomRate> findAllByRoomId(int roomId,Pageable pageable);
   void removeAllByRoomId(int roomId);
   Page<TbRoomRate> findAllByRoomIdOrderByDateDesc(int roomId, Pageable pageable);

}
