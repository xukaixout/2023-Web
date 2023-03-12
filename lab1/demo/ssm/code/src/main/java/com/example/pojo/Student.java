package com.example.pojo;


import java.io.Serializable;


public class Student implements Serializable {

    //学生的id
    private Long id;
    //学生的姓名
    private String name;
    //学生的电话
    private String telephone;
    //学生的学号
    private String studentID;
    //学生备注
    private String nickname;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getTelephone() {
        return telephone;
    }

    public void setTelephone(String telephone) {
        this.telephone = telephone;
    }

    public String getStudentID() {
        return studentID;
    }

    public void setStudentID(String studentID) {
        this.studentID = studentID;
    }

    public String getNickname(){
        return nickname;
    }

    public void setNickname(String nickname){
        this.nickname = nickname;
    }

}

