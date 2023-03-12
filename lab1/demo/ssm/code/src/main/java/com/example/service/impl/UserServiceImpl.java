package com.example.service.impl;

import com.example.mapper.UserMapper;
import com.example.pojo.User;
import com.example.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;


@Service
public class UserServiceImpl implements UserService {
    //注入
    @Autowired
    private UserMapper userMapper;

    /**
     * 用户登录的方法
     */
    @Override
    public User Login(String username) {
        return userMapper.Login(username);
    }
}
