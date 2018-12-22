package com.caps.asp.service;

import com.caps.asp.exception.UserException;
import com.caps.asp.model.TbUser;
import com.caps.asp.repository.UserRepository;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

import static com.caps.asp.constant.Constant.MEMBER;

@Service
@Transactional
public class UserService {
    public final UserRepository userRepository;

    public UserService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    public TbUser findByUsername(String username) {
        return userRepository.findByUsername(username);
    }

    public TbUser findById(int id) {
        return userRepository.findByUserId(id);
    }

    public TbUser findByEmail(String email){
        return userRepository.findByEmail(email);
    }

    public void updateUserById(TbUser user) {
        TbUser tbUser = userRepository.findByUserId(user.getUserId());
        if (tbUser != null) {
            tbUser.setUsername(user.getUsername());
            tbUser.setPassword(user.getPassword());
            tbUser.setEmail(user.getEmail());
            tbUser.setFullname(user.getFullname());
            tbUser.setDob(user.getDob());
            tbUser.setGender(user.getGender());
            tbUser.setImageProfile(user.getImageProfile());
            tbUser.setPhone(user.getPhone());
        }
        userRepository.save(tbUser);
    }

    public Integer saveUser(TbUser user) {
        return userRepository.saveAndFlush(user).getUserId();
    }

    //For test in heroku
    public List<TbUser> getAllUsers() {
        return userRepository.findAll();
    }

    public TbUser findByUsernameAndPassword(String username, String password) {
        return userRepository.findByUsernameAndPassword(username, password);
    }
    public Page<TbUser> findAll(int page, int offset){
        int actualPage = page -1;
        Pageable pageable = PageRequest.of(actualPage,offset);
        return userRepository.findAll(pageable);
    }
    public void deleteUser(int userId){
        userRepository.deleteById(userId);
    }
}
