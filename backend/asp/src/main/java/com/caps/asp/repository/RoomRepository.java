package com.caps.asp.repository;

import com.caps.asp.model.TbRoom;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;

import java.util.List;

public interface RoomRepository extends JpaRepository<TbRoom, Integer>, JpaSpecificationExecutor<TbRoom> {

    TbRoom findByRoomId(int roomId);
    List<TbRoom> findAll();
    TbRoom findByUserIdAndRoomId(int userId, int roomId);
    List<TbRoom> findAllByDistrictId(int districtId);
    Page<TbRoom> findAllByUserId(int userId, Pageable pageable);
    Page<TbRoom> findAllByStatusIdOrderByDateDesc(int statusId, Pageable pageable);
    List<TbRoom> getAllByUserId(int userId);
    List<TbRoom> findAllByAddressLike(String address);

}
