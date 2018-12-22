package com.caps.asp.service;

import com.caps.asp.model.TbPost;
import com.caps.asp.model.TbRoom;
import com.caps.asp.repository.PostRepository;
import com.caps.asp.service.filter.BookmarkFilter;
import com.caps.asp.service.filter.Filter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.persistence.EntityManager;
import javax.persistence.StoredProcedureQuery;
import java.util.*;

@Service
@Transactional
public class PostService {
    public final PostRepository postRepository;

    @Autowired
    EntityManager em = null;

    public PostService(PostRepository postRepository) {
        this.postRepository = postRepository;
    }

    public List<TbPost> findPostByUserIdAndTypeId(int userId, int typeId) {
        return postRepository.findByUserIdAndTypeId(userId, typeId);
    }

    public List<TbPost> getPostList(List<TbRoom> roomList, int roomId) {
        //roomId : is room of people who is suggested
        List<TbPost> list = new ArrayList<>();
        for (TbRoom room : roomList) {
            if (room.getRoomId() != roomId) {
                TbPost tbPost = new TbPost();
                tbPost = postRepository.findByRoomId(room.getRoomId());
                if (tbPost != null)
                    list.add(tbPost);
            }
        }
        return list;
    }

    public Page<TbPost> getAllPostByRoomIds(int page, int items, List<Integer> roomIds) {
        int actualPage = page - 1;
        Pageable pageable = PageRequest.of(actualPage, items);

        return postRepository.findAllByRoomIdIn(roomIds, pageable);
    }

    public List<TbPost> findAllPostByRoomIds(List<Integer> roomIds) {
        return postRepository.findAllByRoomIdIn(roomIds);
    }

    public TbPost findByRoomId(int roomId) {
        return postRepository.findByRoomId(roomId);
    }

    public TbPost findAllByUserIdAndRoomIdOrderByDatePostDesc(int userId, int roomId) {
        List<TbPost> postList = postRepository.findAllByUserIdAndRoomIdOrderByDatePostDesc(userId, roomId);
        if (postList.size() != 0) {
            return postList.get(0);
        }
        return null;
    }

    public int savePost(TbPost post) {
        return postRepository.save(post).getPostId();
    }

    public TbPost findByPostId(int postId) {
        return postRepository.findByPostId(postId);
    }

    public Page<TbPost> findAllByUserId(int page, int items, int userId) {
        int actualPage = page - 1;
        Pageable pageable = PageRequest.of(actualPage, items);
        return postRepository.findAllByUserId(userId, pageable);
    }

    public Page<TbPost> finAllByFilter(int page, int items, Filter filter) {
        int actualPage = page - 1;
        Pageable pageable = PageRequest.of(actualPage, items);
        return postRepository.findAll(filter, pageable);
    }

    public Page<TbPost> finAllBookmarkByFilter(int page, int items, BookmarkFilter filter) {
        int actualPage = page - 1;
        Pageable pageable = PageRequest.of(actualPage, items);
        return postRepository.findAll(filter, pageable);
    }

    public Page<TbPost> findAllByTypeId(int page, int items, int typeId) {
        int actualPage = page - 1;
        Pageable pageable = PageRequest.of(actualPage, items);
        return postRepository.findAllByTypeId(typeId, pageable);
    }

    public List<TbPost> findAllByTypeId(int typeId) {
        return postRepository.findAllByTypeId(typeId);

    }

    public List<TbPost> search(Filter filter) {
        return postRepository.findAll(filter);
    }

    public List<TbPost> getSuggestedList(int userId, int pageOf, int size) {
        StoredProcedureQuery sp = em.createNamedStoredProcedureQuery("getSuggestedList")
                .setParameter("userId", userId)
                .setParameter("pageOf", pageOf)
                .setParameter("size", size);
        List<TbPost> suggestedList = sp.getResultList();
        return suggestedList;
    }

    public List<TbPost> getSuggestedListForMember(float latitude, float longitude, int cityId, int pageOf, int size) {
        StoredProcedureQuery sp = em.createNamedStoredProcedureQuery("getSuggestedListForMember")
                .setParameter("latitude", latitude)
                .setParameter("longitude", longitude)
                .setParameter("cityId", cityId)
                .setParameter("pageOf", pageOf)
                .setParameter("size", size);
        List<TbPost> suggestedList = sp.getResultList();
        return suggestedList;
    }

    public void removeByRoomId(int roomId) {
        postRepository.removeByRoomId(roomId);
    }

    public List<TbPost> findPostByUserId(int userId) {
        return postRepository.findAllByUserId(userId);
    }

    public Page<TbPost> findByUserIdAndTypeId(int page, int items, int userId, int typeId) {
        int actualPage = page - 1;
        Pageable pageable = PageRequest.of(actualPage, items);
        return postRepository.findAllByUserIdAndTypeIdOrderByDatePostDesc(userId, typeId, pageable);
    }

    public List<TbPost> findAllByRoomId(int roomId) {
        return postRepository.findAllByRoomId(roomId);
    }

    public void removeAllByUserId(int userId) {
        postRepository.removeAllByUserId(userId);
    }

    public void removeByPostId(int postId) {
        postRepository.removeByPostId(postId);
    }

    public TbPost findAllByUserIdAndTypeIdOrderByDatePostDesc(int userId, int typeId) {
        List<TbPost> postList = postRepository.findAllByUserIdAndTypeIdOrderByDatePostDesc(userId, typeId);
        if (postList.size() != 0) {
            return postList.get(0);
        }
        return null;
    }
}