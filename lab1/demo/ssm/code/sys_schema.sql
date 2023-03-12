-- create database ssm_demo character set utf8;

drop table if exists tb_user;
drop table if exists tb_student;

create table tb_user
(
    id       int primary key auto_increment,
    username varchar(100),
    password varchar(100)
) default charset = utf8;

create table tb_student
(
    id        int primary key auto_increment,
    name      varchar(100),
    telephone varchar(100),
    studentID varchar(100),
    nickname  varchar(100)
) default charset = utf8;

insert into tb_user
values (1, 'admin', 'admin');

insert into tb_student
values (1, '涂陌', '123456789', '17001020010', '不想写昵称');
insert into tb_student
values (2, '逗瓜', '123456789', '17001020011', '不想写昵称');
insert into tb_student
values (3, '愤青', '123456789', '17001020012', '不想写昵称');
insert into tb_student
values (4, '咸鱼', '123456789', '17001020013', '不想写昵称');
insert into tb_student
values (5, '小白', '123456789', '17001020014', '不想写昵称');
insert into tb_student
values (6, '菜鸡', '123456789', '17001020015', '不想写昵称');

