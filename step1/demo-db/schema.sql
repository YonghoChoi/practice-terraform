CREATE DATABASE demo;
CREATE TABLE demo.User (
  `id` int AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `password` varchar(50) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=INNODB;

insert into demo.User(username, password) values('admin', 'admin');