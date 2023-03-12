package com.example.service.impl;

import com.github.pagehelper.Page;
import com.github.pagehelper.PageHelper;
import com.example.mapper.StudentMapper;
import com.example.pojo.PageBean;
import com.example.pojo.Student;
import com.example.service.StudentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class StudentServiceImpl implements StudentService {

    @Autowired
    private StudentMapper studentMapper;

    @Override
    public List<Student> findAll() {
        return null;
    }

    @Override
    public Student findById(Long id) {
        return studentMapper.findById(id);
    }

    @Override
    public void create(Student student) {
        studentMapper.create(student);
    }

    @Override
    public void delete(Long id) {
        studentMapper.delete(id);
    }

    @Override
    public void update(Student student) {
        studentMapper.update(student);
    }

    @Override
    public PageBean findByPage(Student student, int pageCode, int pageSize) {
        PageHelper.startPage(pageCode, pageSize);

        //调用分页查询方法，其实就是查询所有数据，mybatis自动帮我们进行分页计算
        Page<Student> page = studentMapper.findByPage(student);

        int totalPage = (int) Math.ceil((double) (page.getTotal() / (double) pageSize));
        return new PageBean(pageCode, totalPage, (int) page.getTotal(), pageSize, page.getResult());
    }
}
