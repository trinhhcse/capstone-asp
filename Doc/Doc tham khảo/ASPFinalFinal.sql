-- MySQL dump 10.13  Distrib 5.7.17, for Win64 (x86_64)
--
-- Host: localhost    Database: asp
-- ------------------------------------------------------
-- Server version	5.7.18-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `tb_city`
--

DROP TABLE IF EXISTS `tb_city`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_city` (
  `city_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) COLLATE utf8_icelandic_ci DEFAULT NULL,
  PRIMARY KEY (`city_id`)
) ENGINE=InnoDB AUTO_INCREMENT=64 DEFAULT CHARSET=utf8 COLLATE=utf8_icelandic_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_city`
--

LOCK TABLES `tb_city` WRITE;
/*!40000 ALTER TABLE `tb_city` DISABLE KEYS */;
/*!40000 ALTER TABLE `tb_city` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tb_district`
--

DROP TABLE IF EXISTS `tb_district`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_district` (
  `district_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) COLLATE utf8_icelandic_ci DEFAULT NULL,
  `city_id` int(11) NOT NULL,
  PRIMARY KEY (`district_id`),
  KEY `fk_tb_district_tb_city1_idx` (`city_id`),
  CONSTRAINT `fk_tb_district_tb_city1` FOREIGN KEY (`city_id`) REFERENCES `tb_city` (`city_id`)
) ENGINE=InnoDB AUTO_INCREMENT=710 DEFAULT CHARSET=utf8 COLLATE=utf8_icelandic_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_district`
--

LOCK TABLES `tb_district` WRITE;
/*!40000 ALTER TABLE `tb_district` DISABLE KEYS */;
/*!40000 ALTER TABLE `tb_district` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tb_district_reference`
--

DROP TABLE IF EXISTS `tb_district_reference`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_district_reference` (
  `id` int(11) NOT NULL,
  `district_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_tb_district_reference_tb_district1_idx` (`district_id`),
  KEY `fk_tb_district_reference_tb_reference1_idx` (`user_id`),
  CONSTRAINT `fk_tb_district_reference_tb_district1` FOREIGN KEY (`district_id`) REFERENCES `tb_district` (`district_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_tb_district_reference_tb_reference1` FOREIGN KEY (`user_id`) REFERENCES `tb_reference` (`user_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_district_reference`
--

LOCK TABLES `tb_district_reference` WRITE;
/*!40000 ALTER TABLE `tb_district_reference` DISABLE KEYS */;
/*!40000 ALTER TABLE `tb_district_reference` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tb_favourite`
--

DROP TABLE IF EXISTS `tb_favourite`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_favourite` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `post_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_tb_user_has_tb_room_info_tb_room_info1_idx` (`post_id`),
  KEY `fk_tb_user_has_tb_room_info_tb_user1_idx` (`user_id`),
  CONSTRAINT `fk_tb_user_has_tb_room_info_tb_room_info1` FOREIGN KEY (`post_id`) REFERENCES `tb_post` (`post_id`),
  CONSTRAINT `fk_tb_user_has_tb_room_info_tb_user1` FOREIGN KEY (`user_id`) REFERENCES `tb_user` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1316 DEFAULT CHARSET=utf8 COLLATE=utf8_icelandic_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_favourite`
--

LOCK TABLES `tb_favourite` WRITE;
/*!40000 ALTER TABLE `tb_favourite` DISABLE KEYS */;
/*!40000 ALTER TABLE `tb_favourite` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tb_image`
--

DROP TABLE IF EXISTS `tb_image`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_image` (
  `image_id` int(11) NOT NULL AUTO_INCREMENT,
  `link_url` varchar(255) COLLATE utf8_icelandic_ci DEFAULT NULL,
  `room_id` int(11) NOT NULL,
  PRIMARY KEY (`image_id`),
  KEY `fk_tb_image_tb_room1_idx` (`room_id`),
  CONSTRAINT `fk_tb_image_tb_room1` FOREIGN KEY (`room_id`) REFERENCES `tb_room` (`room_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2051 DEFAULT CHARSET=utf8 COLLATE=utf8_icelandic_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_image`
--

LOCK TABLES `tb_image` WRITE;
/*!40000 ALTER TABLE `tb_image` DISABLE KEYS */;
/*!40000 ALTER TABLE `tb_image` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tb_post`
--

DROP TABLE IF EXISTS `tb_post`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_post` (
  `post_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) COLLATE utf8_icelandic_ci DEFAULT NULL,
  `phone_contact` varchar(15) COLLATE utf8_icelandic_ci DEFAULT NULL,
  `number_partner` int(11) DEFAULT NULL,
  `gender_partner` int(11) DEFAULT NULL,
  `date_post` date DEFAULT NULL,
  `type_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `room_id` int(11) DEFAULT NULL,
  `longtitude` double DEFAULT NULL,
  `lattitude` double DEFAULT NULL,
  `min_price` float DEFAULT NULL,
  `max_price` float DEFAULT NULL,
  `description` varchar(255) COLLATE utf8_icelandic_ci DEFAULT NULL,
  PRIMARY KEY (`post_id`),
  KEY `fk_tb_post_tb_type1_idx` (`type_id`),
  KEY `fk_tb_post_tb_user1_idx` (`user_id`),
  KEY `fk_tb_post_tb_room1_idx` (`room_id`),
  CONSTRAINT `fk_tb_post_tb_type1` FOREIGN KEY (`type_id`) REFERENCES `tb_type` (`type_id`),
  CONSTRAINT `fk_tb_post_tb_user1` FOREIGN KEY (`user_id`) REFERENCES `tb_user` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=336 DEFAULT CHARSET=utf8 COLLATE=utf8_icelandic_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_post`
--

LOCK TABLES `tb_post` WRITE;
/*!40000 ALTER TABLE `tb_post` DISABLE KEYS */;
/*!40000 ALTER TABLE `tb_post` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tb_reference`
--

DROP TABLE IF EXISTS `tb_reference`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_reference` (
  `user_id` int(11) NOT NULL,
  `min_price` float DEFAULT NULL,
  `max_price` float DEFAULT NULL,
  PRIMARY KEY (`user_id`),
  KEY `fk_tb_reference_tb_user1_idx` (`user_id`),
  CONSTRAINT `fk_tb_reference_tb_user1` FOREIGN KEY (`user_id`) REFERENCES `tb_user` (`user_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_reference`
--

LOCK TABLES `tb_reference` WRITE;
/*!40000 ALTER TABLE `tb_reference` DISABLE KEYS */;
/*!40000 ALTER TABLE `tb_reference` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tb_role`
--

DROP TABLE IF EXISTS `tb_role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_role` (
  `role_id` int(11) NOT NULL AUTO_INCREMENT,
  `rolename` varchar(45) COLLATE utf8_icelandic_ci DEFAULT NULL,
  PRIMARY KEY (`role_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COLLATE=utf8_icelandic_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_role`
--

LOCK TABLES `tb_role` WRITE;
/*!40000 ALTER TABLE `tb_role` DISABLE KEYS */;
/*!40000 ALTER TABLE `tb_role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tb_room`
--

DROP TABLE IF EXISTS `tb_room`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_room` (
  `room_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `price` float DEFAULT NULL,
  `area` int(11) DEFAULT NULL,
  `address` varchar(255) NOT NULL,
  `max_guest` int(11) DEFAULT NULL,
  `current_number` int(11) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `user_id` int(11) NOT NULL,
  `city_id` int(11) NOT NULL,
  `district_id` int(11) NOT NULL,
  `date` date DEFAULT NULL,
  `status_id` int(11) NOT NULL,
  `longtitude` double DEFAULT NULL,
  `lattitude` double DEFAULT NULL,
  PRIMARY KEY (`room_id`),
  KEY `fk_tb_room_tb_user1_idx` (`user_id`),
  KEY `fk_tb_room_tb_city1_idx` (`city_id`),
  KEY `fk_tb_room_tb_district1_idx` (`district_id`),
  KEY `fk_tb_room_tb_status1_idx` (`status_id`),
  CONSTRAINT `fk_tb_room_tb_city1` FOREIGN KEY (`city_id`) REFERENCES `tb_city` (`city_id`),
  CONSTRAINT `fk_tb_room_tb_district1` FOREIGN KEY (`district_id`) REFERENCES `tb_district` (`district_id`),
  CONSTRAINT `fk_tb_room_tb_status1` FOREIGN KEY (`status_id`) REFERENCES `tb_status` (`status_id`),
  CONSTRAINT `fk_tb_room_tb_user1` FOREIGN KEY (`user_id`) REFERENCES `tb_user` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=391 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_room`
--

LOCK TABLES `tb_room` WRITE;
/*!40000 ALTER TABLE `tb_room` DISABLE KEYS */;
/*!40000 ALTER TABLE `tb_room` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tb_room_has_user`
--

DROP TABLE IF EXISTS `tb_room_has_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_room_has_user` (
  `user_id` int(11) NOT NULL,
  `date_in` date DEFAULT NULL,
  `date_out` date DEFAULT NULL,
  `room_id` int(11) NOT NULL,
  PRIMARY KEY (`user_id`),
  KEY `fk_tb_room_has_user_tb_room1_idx` (`room_id`),
  CONSTRAINT `fk_tb_room_has_user_tb_room1` FOREIGN KEY (`room_id`) REFERENCES `tb_room` (`room_id`),
  CONSTRAINT `fk_tb_room_has_user_tb_user1` FOREIGN KEY (`user_id`) REFERENCES `tb_user` (`user_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_room_has_user`
--

LOCK TABLES `tb_room_has_user` WRITE;
/*!40000 ALTER TABLE `tb_room_has_user` DISABLE KEYS */;
/*!40000 ALTER TABLE `tb_room_has_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tb_room_has_utility`
--

DROP TABLE IF EXISTS `tb_room_has_utility`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_room_has_utility` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `room_id` int(11) NOT NULL,
  `utility_id` int(11) NOT NULL,
  `brand` varchar(50) COLLATE utf8_icelandic_ci DEFAULT NULL,
  `description` varchar(255) COLLATE utf8_icelandic_ci DEFAULT NULL,
  `quantity` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_tb_utilities_has_tb_room_tb_room1_idx` (`room_id`),
  KEY `fk_tb_utilities_has_tb_room_tb_utilities1_idx` (`utility_id`),
  CONSTRAINT `fk_tb_utilities_has_tb_room_tb_room1` FOREIGN KEY (`room_id`) REFERENCES `tb_room` (`room_id`),
  CONSTRAINT `fk_tb_utilities_has_tb_room_tb_utilities1` FOREIGN KEY (`utility_id`) REFERENCES `tb_utilities` (`utility_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1951 DEFAULT CHARSET=utf8 COLLATE=utf8_icelandic_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_room_has_utility`
--

LOCK TABLES `tb_room_has_utility` WRITE;
/*!40000 ALTER TABLE `tb_room_has_utility` DISABLE KEYS */;
/*!40000 ALTER TABLE `tb_room_has_utility` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tb_status`
--

DROP TABLE IF EXISTS `tb_status`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_status` (
  `status_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`status_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_status`
--

LOCK TABLES `tb_status` WRITE;
/*!40000 ALTER TABLE `tb_status` DISABLE KEYS */;
/*!40000 ALTER TABLE `tb_status` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tb_type`
--

DROP TABLE IF EXISTS `tb_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_type` (
  `type_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`type_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_type`
--

LOCK TABLES `tb_type` WRITE;
/*!40000 ALTER TABLE `tb_type` DISABLE KEYS */;
/*!40000 ALTER TABLE `tb_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tb_user`
--

DROP TABLE IF EXISTS `tb_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_user` (
  `user_id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(45) COLLATE utf8_icelandic_ci NOT NULL,
  `password` varchar(60) COLLATE utf8_icelandic_ci NOT NULL,
  `email` varchar(100) COLLATE utf8_icelandic_ci NOT NULL,
  `fullname` varchar(100) COLLATE utf8_icelandic_ci DEFAULT NULL,
  `image_profile` varchar(255) COLLATE utf8_icelandic_ci DEFAULT NULL,
  `dob` date DEFAULT NULL,
  `phone` varchar(15) COLLATE utf8_icelandic_ci DEFAULT NULL,
  `gender` int(11) DEFAULT NULL,
  `role_id` int(11) NOT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `username` (`username`),
  KEY `fk_tb_user_tb_role1_idx` (`role_id`),
  CONSTRAINT `fk_tb_user_tb_role1` FOREIGN KEY (`role_id`) REFERENCES `tb_role` (`role_id`)
) ENGINE=InnoDB AUTO_INCREMENT=537 DEFAULT CHARSET=utf8 COLLATE=utf8_icelandic_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_user`
--

LOCK TABLES `tb_user` WRITE;
/*!40000 ALTER TABLE `tb_user` DISABLE KEYS */;
/*!40000 ALTER TABLE `tb_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tb_utilities`
--

DROP TABLE IF EXISTS `tb_utilities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_utilities` (
  `utility_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) COLLATE utf8_icelandic_ci DEFAULT NULL,
  PRIMARY KEY (`utility_id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8 COLLATE=utf8_icelandic_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_utilities`
--

LOCK TABLES `tb_utilities` WRITE;
/*!40000 ALTER TABLE `tb_utilities` DISABLE KEYS */;
/*!40000 ALTER TABLE `tb_utilities` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tb_utilities_reference`
--

DROP TABLE IF EXISTS `tb_utilities_reference`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_utilities_reference` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `utility_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_tb_utilities_has_tb_user_tb_utilities1_idx` (`utility_id`),
  KEY `fk_tb_utilities_reference_tb_reference1_idx` (`user_id`),
  CONSTRAINT `fk_tb_utilities_has_tb_user_tb_utilities1` FOREIGN KEY (`utility_id`) REFERENCES `tb_utilities` (`utility_id`),
  CONSTRAINT `fk_tb_utilities_reference_tb_reference1` FOREIGN KEY (`user_id`) REFERENCES `tb_reference` (`user_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=2093 DEFAULT CHARSET=utf8 COLLATE=utf8_icelandic_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_utilities_reference`
--

LOCK TABLES `tb_utilities_reference` WRITE;
/*!40000 ALTER TABLE `tb_utilities_reference` DISABLE KEYS */;
/*!40000 ALTER TABLE `tb_utilities_reference` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'asp'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2018-10-19 18:35:26
