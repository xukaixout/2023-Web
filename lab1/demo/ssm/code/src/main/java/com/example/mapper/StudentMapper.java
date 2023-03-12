package com.example.mapper;

import com.github.pagehelper.Page;
import com.example.pojo.Student;

public interface StudentMapper {
    void create(Student student);

    void delete(Long id);

    Student findById(Long id);

    void update(Student student);

    Page<Student> findByPage(Student student);
}
