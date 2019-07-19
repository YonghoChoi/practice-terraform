CREATE DATABASE irene_demo;
CREATE TABLE irene_demo.User (
  `id` int AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `password` varchar(50) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=INNODB;

insert into irene_demo.User(username, password) values('admin', 'admin');