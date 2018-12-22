package com.caps.asp.service;

import com.caps.asp.model.TbFavourite;
import com.caps.asp.repository.FavouriteRepository;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional
public class FavouriteService {

    public final FavouriteRepository favouriteRepository;

    public FavouriteService(FavouriteRepository favouriteRepository) {
        this.favouriteRepository = favouriteRepository;
    }

    public Page<TbFavourite> findAllByUserId(int userId, int page, int items) {
        int actualPage = page - 1;
        Pageable pageable = PageRequest.of(actualPage, items);
        return favouriteRepository.findAllByUserId(userId, pageable);
    }

    public TbFavourite addFavourite(TbFavourite tbFavourite) {
        return favouriteRepository.save(tbFavourite);
    }

    public void remove(int id) {
        favouriteRepository.deleteById(id);
    }
    public boolean remove(int userId, int postId){
        return favouriteRepository.removeByUserIdAndAndPostId(userId,postId);
    }

    public TbFavourite findByUserIdAndPostId(int userId, int postId){
        return favouriteRepository.findByUserIdAndPostId(userId, postId);
    }

    public void removeAllByPostId(int postId){
        favouriteRepository.removeAllByPostId(postId);
    }
}
