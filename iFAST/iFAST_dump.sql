-- MySQL dump 10.13  Distrib 8.0.19, for Linux (x86_64)
--
-- Host: localhost    Database: iFAST
-- ------------------------------------------------------
-- Server version	8.0.19

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Temporary view structure for view `ENDC_issue_category_known`
--

DROP TABLE IF EXISTS `ENDC_issue_category_known`;
/*!50001 DROP VIEW IF EXISTS `ENDC_issue_category_known`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `ENDC_issue_category_known` AS SELECT 
 1 AS `issue`,
 1 AS `SW`,
 1 AS `Status`,
 1 AS `Area`,
 1 AS `Technology`,
 1 AS `Visibility`,
 1 AS `Major_KPI_Degradation`,
 1 AS `Issue_Category`,
 1 AS `Description`,
 1 AS `Root_Cause`,
 1 AS `Impact`,
 1 AS `Detection_Methodology_OMs`,
 1 AS `Detection_Methodology_Log_Script`,
 1 AS `Interim_Solution_Workaround`,
 1 AS `Permanent_Fix`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `User_sane_details`
--

DROP TABLE IF EXISTS `User_sane_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `User_sane_details` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `user_id` varchar(50) NOT NULL,
  `sane_id` varchar(45) NOT NULL,
  `sane_password` varchar(100) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `User_sane_details`
--

LOCK TABLES `User_sane_details` WRITE;
/*!40000 ALTER TABLE `User_sane_details` DISABLE KEYS */;
/*!40000 ALTER TABLE `User_sane_details` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `action_schedule`
--

DROP TABLE IF EXISTS `action_schedule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `action_schedule` (
  `schedule_id` int NOT NULL,
  `action_id` int NOT NULL,
  PRIMARY KEY (`schedule_id`,`action_id`),
  KEY `action_id` (`action_id`),
  KEY `schedule_id` (`schedule_id`),
  CONSTRAINT `action_schedule_ibfk_1` FOREIGN KEY (`action_id`) REFERENCES `actions` (`action_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `action_schedule`
--

LOCK TABLES `action_schedule` WRITE;
/*!40000 ALTER TABLE `action_schedule` DISABLE KEYS */;
/*!40000 ALTER TABLE `action_schedule` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `action_type_grep`
--

DROP TABLE IF EXISTS `action_type_grep`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `action_type_grep` (
  `action_id` int NOT NULL,
  `grep_target` varchar(50) NOT NULL,
  `grep_string` varchar(50) NOT NULL,
  `expected_output_regex` varchar(50) NOT NULL,
  `type_grep_arguments` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`action_id`),
  KEY `action_type_grep_ibfk_1_idx` (`action_id`),
  CONSTRAINT `action_type_grep_ibfk_1` FOREIGN KEY (`action_id`) REFERENCES `actions` (`action_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `action_type_grep`
--

LOCK TABLES `action_type_grep` WRITE;
/*!40000 ALTER TABLE `action_type_grep` DISABLE KEYS */;
/*!40000 ALTER TABLE `action_type_grep` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `action_type_local_script`
--

DROP TABLE IF EXISTS `action_type_local_script`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `action_type_local_script` (
  `action_id` int NOT NULL,
  `name` varchar(50) NOT NULL,
  `owner` varchar(50) NOT NULL,
  `location` varchar(50) NOT NULL,
  `host_server` varchar(10) NOT NULL,
  `path` varchar(50) NOT NULL,
  `expected_response` varchar(50) NOT NULL,
  `login` varchar(50) NOT NULL,
  `password` varchar(50) NOT NULL,
  PRIMARY KEY (`action_id`),
  CONSTRAINT `action_type_local_script_ibfk_1` FOREIGN KEY (`action_id`) REFERENCES `actions` (`action_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `action_type_local_script`
--

LOCK TABLES `action_type_local_script` WRITE;
/*!40000 ALTER TABLE `action_type_local_script` DISABLE KEYS */;
/*!40000 ALTER TABLE `action_type_local_script` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `action_type_remote_script`
--

DROP TABLE IF EXISTS `action_type_remote_script`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `action_type_remote_script` (
  `name` varchar(50) NOT NULL,
  `owner` varchar(50) NOT NULL,
  `action_id` int NOT NULL,
  `location` varchar(50) NOT NULL,
  `host_server` varchar(10) NOT NULL,
  `login` varchar(50) NOT NULL,
  `password` varchar(50) NOT NULL,
  `type_remote_arguments` varchar(50) NOT NULL,
  PRIMARY KEY (`action_id`),
  CONSTRAINT `action_type_remote_script_ibfk_1` FOREIGN KEY (`action_id`) REFERENCES `actions` (`action_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `action_type_remote_script`
--

LOCK TABLES `action_type_remote_script` WRITE;
/*!40000 ALTER TABLE `action_type_remote_script` DISABLE KEYS */;
/*!40000 ALTER TABLE `action_type_remote_script` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `action_type_script_ref`
--

DROP TABLE IF EXISTS `action_type_script_ref`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `action_type_script_ref` (
  `action_id` int NOT NULL,
  `action_type` varchar(50) NOT NULL,
  `action_type_ref` varchar(50) NOT NULL,
  `type_script_arguments` varchar(50) NOT NULL,
  PRIMARY KEY (`action_id`),
  KEY `action_type_script_ref_ibfk_1_idx` (`action_id`),
  CONSTRAINT `action_type_script_ref_ibfk_1` FOREIGN KEY (`action_id`) REFERENCES `actions` (`action_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `action_type_script_ref`
--

LOCK TABLES `action_type_script_ref` WRITE;
/*!40000 ALTER TABLE `action_type_script_ref` DISABLE KEYS */;
/*!40000 ALTER TABLE `action_type_script_ref` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `actions`
--

DROP TABLE IF EXISTS `actions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `actions` (
  `action_id` int NOT NULL,
  `action_type` varchar(500) NOT NULL,
  `action_table_ref` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`action_id`,`action_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `actions`
--

LOCK TABLES `actions` WRITE;
/*!40000 ALTER TABLE `actions` DISABLE KEYS */;
INSERT INTO `actions` VALUES (1,'RUN SCRIPT','scripts'),(2,'GET FILE','get_file'),(3,'GREP','grep');
/*!40000 ALTER TABLE `actions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `actions_list`
--

DROP TABLE IF EXISTS `actions_list`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `actions_list` (
  `sequenceref_id` int DEFAULT NULL,
  `actionlist_id` int NOT NULL,
  `action_id` int NOT NULL,
  `pos_in_sequence` varchar(50) NOT NULL,
  `total_in_sequence` varchar(50) NOT NULL,
  `next_continue_action` varchar(50) NOT NULL,
  `next_terminate_action` varchar(50) NOT NULL,
  PRIMARY KEY (`actionlist_id`,`action_id`),
  KEY `sequenceref_id` (`sequenceref_id`),
  KEY `actions_ibfk_1_idx` (`action_id`),
  CONSTRAINT `actionlist_id_ibfk_2` FOREIGN KEY (`actionlist_id`) REFERENCES `issue_action_sequence` (`actionlist_id`),
  CONSTRAINT `actions_ibfk_1` FOREIGN KEY (`action_id`) REFERENCES `actions` (`action_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `actions_list`
--

LOCK TABLES `actions_list` WRITE;
/*!40000 ALTER TABLE `actions_list` DISABLE KEYS */;
/*!40000 ALTER TABLE `actions_list` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `get_file`
--

DROP TABLE IF EXISTS `get_file`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `get_file` (
  `issue_id` int NOT NULL,
  `SW` varchar(20) DEFAULT NULL,
  `Technology` varchar(50) DEFAULT NULL,
  `Status` varchar(20) NOT NULL,
  `action_type` varchar(50) DEFAULT NULL,
  `file_name` varchar(500) NOT NULL,
  `Script_owner` varchar(20) DEFAULT NULL,
  `Script_location` varchar(50) DEFAULT NULL,
  `server_Login` varchar(50) DEFAULT NULL,
  `server_password` varchar(100) DEFAULT NULL,
  `Server_IP` varchar(20) DEFAULT NULL,
  `Sequence_num` int NOT NULL,
  `Task_id` int NOT NULL,
  `script_path` varchar(500) DEFAULT NULL,
  `args` varchar(500) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `get_file`
--

LOCK TABLES `get_file` WRITE;
/*!40000 ALTER TABLE `get_file` DISABLE KEYS */;
INSERT INTO `get_file` VALUES (33,'NA',NULL,'Open','GET FILE','CmdExecuter_100523_053628_25854.log','praseeda','REMOTE','toolsuser','58BBE35153948ECB4EE2DE0339E1CA61','10.100.1.241',2,33,'/opt/vz_raw_data/Scripts/TEST_iFAST/CmdExecuter/Logs/',NULL),(34,'21B',NULL,'Open','GET FILE','pci_reuse_within_gNB_01092023.xlsx','Shivani','REMOTE','toolsuser','58BBE35153948ECB4EE2DE0339E1CA61','10.100.1.241',2,34,'/opt/vz_raw_data/Scripts/TEST_iFAST/CBAND_DSS',NULL);
/*!40000 ALTER TABLE `get_file` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `grep`
--

DROP TABLE IF EXISTS `grep`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `grep` (
  `issue_id` int NOT NULL,
  `Sequence_num` int NOT NULL,
  `grep_target` varchar(200) NOT NULL,
  `grep_string` varchar(50) NOT NULL,
  `expected_output_regex` varchar(200) NOT NULL,
  `type_grep_arguments` varchar(50) DEFAULT NULL,
  `Task_id` int NOT NULL,
  `action_type` varchar(50) DEFAULT NULL,
  `script_path` varchar(500) DEFAULT NULL,
  `file_name` varchar(500) DEFAULT NULL,
  `Script_owner` varchar(50) NOT NULL,
  `Script_location` varchar(50) NOT NULL,
  `server_Login` varchar(50) NOT NULL,
  `server_password` varchar(100) NOT NULL,
  `Server_IP` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `grep`
--

LOCK TABLES `grep` WRITE;
/*!40000 ALTER TABLE `grep` DISABLE KEYS */;
INSERT INTO `grep` VALUES (33,3,'CmdExecuter_100523_053628_25854.log','curl','/opt/tomcat/apache-tomcat-9.0.31/webapps/iFAST_Action/src/Logs/33_3','',33,'GREP','/opt/vz_raw_data/Scripts/TEST_iFAST/COPYFILE',NULL,'praseeda','REMOTE','toolsuser','58BBE35153948ECB4EE2DE0339E1CA61','10.100.1.241');
/*!40000 ALTER TABLE `grep` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `grep_09272023`
--

DROP TABLE IF EXISTS `grep_09272023`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `grep_09272023` (
  `issue_id` int NOT NULL,
  `Sequence_num` int NOT NULL,
  `grep_target` varchar(200) NOT NULL,
  `grep_string` varchar(50) NOT NULL,
  `expected_output_regex` varchar(200) NOT NULL,
  `type_grep_arguments` varchar(50) DEFAULT NULL,
  `Task_id` int NOT NULL,
  `action_type` varchar(50) DEFAULT NULL,
  `script_path` varchar(500) DEFAULT NULL,
  `file_name` varchar(500) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `grep_09272023`
--

LOCK TABLES `grep_09272023` WRITE;
/*!40000 ALTER TABLE `grep_09272023` DISABLE KEYS */;
INSERT INTO `grep_09272023` VALUES (33,3,'CmdExecuter_091823_043842_29237.log','curl','/opt/tomcat/apache-tomcat-9.0.31/webapps/iFAST_Action/src/Logs/33_3','',33,'GREP','/opt/vz_raw_data/Scripts/TEST_iFAST/CmdExecuter/Logs',NULL);
/*!40000 ALTER TABLE `grep_09272023` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `issue`
--

DROP TABLE IF EXISTS `issue`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `issue` (
  `issue_id` int NOT NULL,
  `defaultactionseqref` varchar(50) NOT NULL,
  PRIMARY KEY (`issue_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `issue`
--

LOCK TABLES `issue` WRITE;
/*!40000 ALTER TABLE `issue` DISABLE KEYS */;
/*!40000 ALTER TABLE `issue` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `issue_action_sequence`
--

DROP TABLE IF EXISTS `issue_action_sequence`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `issue_action_sequence` (
  `issue_id` int NOT NULL,
  `sequenceref_id` int DEFAULT NULL,
  `actionlist_id` int NOT NULL,
  PRIMARY KEY (`actionlist_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `issue_action_sequence`
--

LOCK TABLES `issue_action_sequence` WRITE;
/*!40000 ALTER TABLE `issue_action_sequence` DISABLE KEYS */;
/*!40000 ALTER TABLE `issue_action_sequence` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `issue_action_sequence1`
--

DROP TABLE IF EXISTS `issue_action_sequence1`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `issue_action_sequence1` (
  `issue_id` int NOT NULL,
  `sequenceref_id` int DEFAULT NULL,
  `actionlist_id` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `issue_action_sequence1`
--

LOCK TABLES `issue_action_sequence1` WRITE;
/*!40000 ALTER TABLE `issue_action_sequence1` DISABLE KEYS */;
INSERT INTO `issue_action_sequence1` VALUES (33,1,5),(33,1,5),(34,1,1),(34,1,2);
/*!40000 ALTER TABLE `issue_action_sequence1` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `issue_action_sequence_bkup`
--

DROP TABLE IF EXISTS `issue_action_sequence_bkup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `issue_action_sequence_bkup` (
  `issue_id` int NOT NULL,
  `sequenceref_id` int DEFAULT NULL,
  `actionlist_id` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `issue_action_sequence_bkup`
--

LOCK TABLES `issue_action_sequence_bkup` WRITE;
/*!40000 ALTER TABLE `issue_action_sequence_bkup` DISABLE KEYS */;
/*!40000 ALTER TABLE `issue_action_sequence_bkup` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `issue_category_known_knowledge`
--

DROP TABLE IF EXISTS `issue_category_known_knowledge`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `issue_category_known_knowledge` (
  `issue_id` int NOT NULL,
  `Issue Category` varchar(200) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `issue_category_known_knowledge`
--

LOCK TABLES `issue_category_known_knowledge` WRITE;
/*!40000 ALTER TABLE `issue_category_known_knowledge` DISABLE KEYS */;
INSERT INTO `issue_category_known_knowledge` VALUES (1,'C-Band/DSS'),(2,'C-Band'),(3,'C-Band/DSS/FR2'),(4,'C-Band/DSS'),(5,'C-Band'),(6,'C-Band/DSS'),(7,'C-Band/DSS'),(8,'C-Band/DSS'),(9,'C-Band'),(10,'C-Band/DSS/mmW'),(11,'C-Band'),(12,'C-Band'),(13,'C-Band'),(14,'DSS'),(15,'DSS'),(16,'C-Band/DSS/mmW'),(17,'4G'),(18,'4G'),(19,'4G'),(20,'C-Band/DSS'),(21,'C-Band'),(22,'mmWave'),(23,'C-Band/DSS'),(24,'C-Band(64T64R)'),(25,'C-Band(64T64R)'),(26,'C-Band/DSS'),(27,'C-Band/DSS'),(28,'C-Band(64T64R)'),(29,'C-Band(64T64R)'),(30,'C-Band(8T8R)'),(31,'DSS/Cband'),(32,'mmWave');
/*!40000 ALTER TABLE `issue_category_known_knowledge` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `known_knowledge_base`
--

DROP TABLE IF EXISTS `known_knowledge_base`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `known_knowledge_base` (
  `issue` int NOT NULL,
  `SW` varchar(20) DEFAULT NULL,
  `Status` varchar(20) NOT NULL,
  `Area` varchar(20) NOT NULL,
  `Technology` varchar(50) DEFAULT NULL,
  `Visibility` varchar(50) DEFAULT NULL,
  `Major_KPI_Degradation` varchar(50) DEFAULT NULL,
  `Issue_Category` varchar(200) NOT NULL,
  `Description` varchar(500) DEFAULT NULL,
  `Root_Cause` varchar(1000) DEFAULT NULL,
  `Impact` varchar(150) DEFAULT NULL,
  `Detection_Methodology_OMs` varchar(500) DEFAULT NULL,
  `Detection_Methodology_Log_Script` varchar(5000) DEFAULT NULL,
  `Interim_Solution_Workaround` varchar(200) DEFAULT NULL,
  `Permanent_Fix` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`issue`,`Area`,`Status`,`Issue_Category`),
  KEY `idx_issue_known` (`issue`),
  KEY `idx1_issue_known` (`Status`,`Area`,`Technology`) /*!80000 INVISIBLE */,
  KEY `idx2_issue_known` (`Technology`,`Visibility`) /*!80000 INVISIBLE */,
  KEY `idx3_issue_known` (`Issue_Category`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `known_knowledge_base`
--

LOCK TABLES `known_knowledge_base` WRITE;
/*!40000 ALTER TABLE `known_knowledge_base` DISABLE KEYS */;
INSERT INTO `known_knowledge_base` VALUES (1,NULL,'Closed','SNAP/BAU','C-Band/DSS','Internal','OOS','UL Waveform Adaptation','Continuous UL DATA Arrival RACH and spike in SgNB Modification attempts resulting in almost zero traffic on the impacted cell','Issue occurs when the vDU MAC assigns invalid MCS (MCS 28) instead of Max MCS (MCC 27) for a DFT-S OFDM UE.\nUL grants are not sent to this specific UE and also no grants are allocated to any UE on the impacted cell.','Almost zero traffic on the impacted cell\n2 out of ~6500 cells on the audit day\n60 cells over a period of 3 months','huge delta in SgNB Modifications counters',NULL,'Cell lock/unlock','vDU 22AP2'),(2,'21B','Open','SNAP/BAU','C-Band','Internal','Accessibility & Retainability','CAC','Almost Zero traffic for 3 to 4 hours after vDU CAC limit = 1200 is reached','No specific cause was identified from OM analysis by HQ.\nHQ requested to capture live logs while the issue is ongoing to further debug and root cause.','Almost zero traffic on the impacted cell\n100% Reconfiguration failures\n3 occurrences in the last 4 months (2 in May and 1 in July)','DU CSL:[0xB006]CauseInternalCacCallCountOver > 0',NULL,'vDU reset','Open Issue'),(3,'NA','Open','SNAP/BAU','C-Band/DSS/FR2','External','Accessibility & Retainability','CA Req Band and ENDC Band Config','Additional/missing NR Band configuration in CA Req Freq Band and mismatch between CA Req Freq Band and ENDC Band config','Due to additonal NR Band in CA Req Band config - eNB MRDC table getting filled and eNB not sending correct band combo to vDU. \nDue to mstmatch between CA Req Band config and ENDC Band config - eNB does not include the ex. n77 band combos whiile sending CBand sgNB Addition Req.','high access Fails due to DU Prep fail cause','High EndcAddPrepFail_DuFail',NULL,'Add missing NR band or remove additional NR band in CA Req Band config and match the band config between CA Req Band config and ENDC band config','LTE 22C for missing/addiitional NR band.\nOpen issue for mismatch between CA Req Band and ENDC Band config'),(4,NULL,'Closed','SNAP/BAU','C-Band/DSS','External','Accessibility & Retainability','RLC IP','100% Reconfiguration failures & ENDC Drop Rate due to RLC IP conflict.','During any SW initialization, if correct sequence is not followed then mismatch of IP between vDU OS and YANG happens which results in call processing failures.\nThis issue may/may not occur during vDU reset, depending on the SW initialization sequence. If the VNP block initializes before NCM block initialization, the issue would not happen. Only when VNP block initializes after NCM block, ifindex does not get updated in YANG model and the issue can occur.','100% Reconfiguration failures & 100% ENDC Drop Rate\n6 occurrences in the last month','DU CSL: [ 0xB10F] CauseInternalRlcNoRoutableBeaerIp > 0',NULL,'Restart ncm.xcg SW block (run killall ncm.xcg ” in DPP POD)','vDU 22AP1'),(5,NULL,'Closed','SNAP/BAU','C-Band','External','Retainability','MMU Low I/Q','High ENDC Drop Rate due to NR RACH failures in specific sectors. Almost zero Msg1 attempts, i.e PRACH cannot be detected.','In FPGA processing, reference signal for the timing is 10ms frame. When internal block “RAFE/CIC” lost this 10 ms reference signal (sync error) signal processing to the next blocks is stopped which leads to low I/Q level in MMU.','100% ENDC Drop Rate\n 7 sites in latest audit, will be doing periodic audit to capture the site count','RACH MSG1 = 0, ENDC Drop Rate = 90-100% Then confirmation from MMU log',NULL,'MMU reset','vDU 22A'),(6,NULL,'Closed','SNAP/BAU','C-Band/DSS','Internal','Packet Loss','F1U DL Packet Loss','High packet loss observed on DL F1U interface from KPIs after DU/AU SW to 21D from 21B','Packet LOSS/Out of Sequence Cnt abnormally increases when processing gtp packets that do not include GTP SN The actual packet does not have LOSS, and only statistics collection is abnormal.','Shows high packet loss count after 21D upgrades','Spike in S5NR_F1UPacketLossRate_DL_%',NULL,'NA','vDU 22AP3 or 22C'),(7,NULL,'Closed','SNAP/BAU','C-Band/DSS','External','HO','Intra gNB HO Fail Rate','High fail rate in HO from SS n5/n2 to n77 in preparation phase','Issue is seen when n77 DL only device HO from n5/n2 to n77 \nSS vCU checks only target band but misses band combination check due to SW bug','Huge spike in Intra gNB HO fail rate','EndcIntraChgPrepSucc = 0 for n77 DL only devices\nHigh S5NR_IntragNBHOFailRate_% - SS n5/n2 --> n77',NULL,'NA','vCU 22AP1'),(8,'NA','Open','SNAP/BAU','C-Band/DSS','External','HO','Inter gNB HO Fail Rate','High fail rate in HO from SS FR1 to SS FR1','Issue is seen when N// anchor is missing relation to target NR and NR to NR HO triggers\nN// ANR will only add relation if X2 is manually defined, here X2 is missing (N// LTE to Target SS gNB)','Huge spike in Inter gNB HO fail rate','EndcInterChgSrcPrepFail_MenbFail > 0 (Src SS gNB)\nRx_X2apSgNBChangeRefuse > 0 (N// MeNB - Target SS gNB)',NULL,'Define missing X2 from N// LTE to Target SS gNB','Enhance N// ANR to define auto X2'),(9,NULL,'Closed','SNAP','C-Band','External','Retainability','High ENDC Drop Rate due to Sync Reconfig Fails','Observed spike in drop rate due to x1032 CRR after vDU 21DP2 upgrades','During N// n5/n2 to n77 HO, particularly in 21DP2 RACH Config Common IE is removed which causes HO exec failure and results in x1032 CRR Drop','High 0x1032 CRR during N// n5/n2 to n77 HO','Spike in [0x1032]CauseInternalSynchReconfigFailureScg CRR after 21DP2 upgrade from 21B',NULL,'Remove N// n5/n2 to n77 HO relations with VZ approval Also push for 21DP2.01 upgrades','vDU 21DP2.01'),(10,NULL,'Closed','SNAP','C-Band/DSS/mmW','External','Retainability','High ENDC Drop Rate due to Sync Reconfig Fails','Observed spike in drop rate due to x1032 CRR','During n77 to n5 IFHO, UE is directed to HO to weaker n77 cell\nWhen UE sends A5 MR it contains Intra Freq MR & Inter Freq MR, and ideally IFHO must trigger but due to SW bug HO is triggered to Intra Freq cell which is weaker than Source cell and resulting in Drop\nThis occurs only when target Inter Freq cell is not defined as neighbor','High 0x1032 CRR during any IFHO (n77<-->n5/n2, n77<-->FR2, n5/n2<-->FR2)','Spike in [0x1032]CauseInternalSynchReconfigFailureScg CRR during IFHO scenarios',NULL,'Define the missing relation to target inter freq cell','vCU 22AP2'),(11,NULL,'Closed','SNAP/BAU','C-Band','External','BLER','High UL Initial & Residual BLER','High BLER I-BLER > 10% and R-BLER > 1% \nPUCCH SR detected during DRX sleep period which is false SR','False SR mechanism was not well optimized.DCI for UL grant is sent but it is ignored as UE is in sleep mode (DRX) which results in no PUSCH and high BLER','Intial & Residual BLER spikes up by 40%','I & R BLER%',NULL,'Turn OFF DRX (until vDU 21DP2.01 deploys)','vDU 21DP2.01'),(12,NULL,'Closed','SNAP','C-Band','External','Retainability','High ENDC Drop Rate due to DU RLC Max Retx','Observed spike in drop rate due to x1022 CRR after C-Band launch','During N// n5/n2 to n77 HO, due to n77 missing max mimo layer IE it results in data stall followed by NR release due to x1022 CRR','High 0x1022 CRR during N// n5/n2 to n77 HO','Spike in [0x1022]CauseInternalDuRlcMaxNumRetx during N// n5/n2 to n77 HO',NULL,'Remove N// n5/n2 to n77 HO relations with VZ approval Also push for 21DP2.01 upgrades','vDU 21DP2.01'),(13,NULL,'Closed','SNAP/BAU','C-Band','External','Retainability','High ENDC Drop Rate due to DU RLC Max Retx','Observed spike in drop rate due to x1022 CRR after C-Band launch','In poor RF conditions large number of PRB allocation to UL power limited UEs lead to high UL BLER and unacknowledged DL RLC data, leading to DL RLC retx and finally drop call.','High 0x1022 CRR','Spike in [0x1022]CauseInternalDuRlcMaxNumRetx',NULL,'NA','vDU 21DP2.01'),(14,NULL,'Closed','SNAP/BAU','DSS','External','NR CA','High NR CA addition failure rate','Very high CA add fails during n5/n2 to n77 NR CA','Issue is seen when n77 PSCell only device is added in NR CA\nSS vCU checks only  band but misses band combination check due to SW bug','No impact to end user, counters/KPI show high failures','Very high CA_ACTION_DU:CaAddFail on n5/n2',NULL,'NA','vCU 22AP2'),(15,NULL,'Closed','SNAP/BAU','DSS','External','Retainability','Very high ENDC Drop Rate on n5/n2 cells','RACH failure and high ENDC Drop Rate increase on impacted cell due to x101A CRR','RACH issue is due to invalid PRACH data packets received on vDU.\nWhen upgrading eNB vDU , if there is unstable clock during CPRI link initialization','> 85% ENDC Drop rate on impacted cell','[0x101A]CauseInternalRandomAccessProblem; very high ENDC Drop Rate on DSS cell (>85%)',NULL,'Hard reset FSU\n“reset mode” = hard.\nAlso push to upgrade to FSU 21BP1.02 or later','FSU 21BP1.02'),(16,NULL,'Closed','SNAP','C-Band/DSS/mmW','External','Accessibility','High Reconfiguration Fail Rate','Spike in ENDC setup failures in SNAP markets','Signature shows failures are from N// eNBs cancelling the setup by sending release request instead of reconfiguration complete','High Access Fails due to MeNB cause','OMs: EndcAddFail_MenbFail > 0\n[0x402B] CauseX2apRadioNetworkLayerRadioConnectionWithUeLost>0',NULL,'Identify N// anchors and discuss with VZ for root cause','NA'),(17,NULL,'Closed','SNAP/BAU','4G','External','Accessibility','High ERAB SF Rate (90%) due to high Buffer usage in LTE 21D','Observed spike in ERAB SF Rate on 6 eNBs','Due to multi core operation, multiple threads are operated at the same time. Due to memory access timing issue, another core can try to access the same queue already in use, resulting in data corruption in the buffer. . Over time, buffer leak accumulates, resulting in reduced buffer availability. Some sites were observed to have reached buffer availability of 10% or less in ~30 days. Once the buffer is fully occupied, ERAB setup failures start to occur.','Users cannot access the site once the high buffer utilization is reached.','high CRR330 peg on sites',NULL,'Reset sites based on buffer utilization>70% from the daily audit','LTE 22A'),(18,NULL,'Closed','SNAP/BAU','4G','External','OOS','CBRS TX Path shutdown issue in LTE 21D','CBRS KPIs degraded post Preferred EARFCN changes and manual grant request procedure','As per LTE 21D design eNB doesn’t check the Tx status. The Tx status check is to be performed by RU prior to measuring the RSSI.Due to software bug when eNB requests the RSSI measurement, RU fails to check if all the cells are locked or Tx path is disabled.\nSince the RU did not check the Tx path status, the Tx path is shutdown resulting in RX only mode and RSSI is measured.\nThe Tx path remained shut down even after the CBRS grant procedure is completed and the cells were unlocked. This impacted the overall CBRS service','User experience is impacted since performance are degraded on CBRS cells.\nAll TX Paths are disabled on the CBRS RRH','Zero DL MAC Vol/THP, degradation on DL I BLER/R BLER, DL RLC ReTx for CBRS cells',NULL,'Reset CBRS RRH for sites where current-amp-state is shutdown from the daily audit','LTE 22AP2'),(19,NULL,'Closed','SNAP/BAU','4G','External','OOS','High UMP memory Alarms and Reboots for high capacity sites in LTE 21D','Observed reboots on sites with high traffic after critical UMP memory alarms observed','ENDC users are taking up 2.2X more memory than LTE users. Due to this the ECCB memory is getting depleted quicker for high capacity sites leading to critical UMP memory alarms and reboots','Site is OOS for 5 minutes','Alarm: Check critical UMP memory alarm',NULL,'Implement HQ recommended 21D settings for high capacity sites','LTE 22A'),(20,'NA','Open','SNAP/BAU','C-Band/DSS','External','Retainability','High ENDC Drop when SgNB addtions are attempted from Nokia anchor >6miles','High % ENDC Drops due to the pegging of the cause code [0x101A]CauseInternalRandomAccessProblem','Due to PCI confusion(far anchor) Nokia anchor forwards the SgNB addition to wrong SgNB','High % ENDC DROP on the offender vDU','RACH MSG1=(RachPreambleAPerBeam+RachPreambleACFRAPerBeam)\nRACH MSG3=(NumMSG3PerBeam+NumMSG3CFRAPerBeam)\n(RACH MSG1/[0x101A]CauseInternalRandomAccessProblem)<10','Check there are more RandomAccess problems reported than the actual MSG1 detected\ncheck the anchor-vDU relation causing this drop and calculate the distance\nif distance is greater than 6miles, it falls under far anchor and this NBR relation need to be black listed','Reach out to VZW and black list the far anchor neighour relation','Operational Issue'),(21,'NA','Open','SNAP/BAU','C-Band','External','Retainability','100% ENDC Drop due to missing PTP clock sync','100 % ENDC Drops due to the pegging of the cause code [0x101A]CauseInternalRandomAccessProblem','Both vDU and MMU should be receiving the clock and should be in sync','100% ENDC DROP on the offender vDU','RACH MSG1=(RachPreambleAPerBeam+RachPreambleACFRAPerBeam)\nRACH MSG3=(NumMSG3PerBeam+NumMSG3CFRAPerBeam)\nRACH MSG1 =0  and RACH MSG3=0 along with CU-CSL 0x101A, CauseInternalRandomAccessProblem being pegged, on all the 3 sectors','check the PTP clock sync at both vDU and MMU\nChecking Method:\nvsmuser@adpf13291523020-dmp0-76c595d464-f2f58 21:33:19>show managed-element hardware-management o-ran-radio-unit o-ran-radio-unit-info sync o-ran-sync sync\nmanaged-element hardware-management o-ran-radio-unit o-ran-radio-unit-info 0\nsync o-ran-sync sync sync-capability sync-t-tsc -\nsync o-ran-sync sync sync-status sync-state LOCKED\nITEM \nAbove sync state should be in locked state.','Create external ticket and reach out to VZW NA team to recover the clock sync','Operational Issue'),(22,NULL,'Closed','SNAP/BAU','mmWave','External','Data Stall','Data stalls seen at the UE when UE tries to move from CP to DFTs OFDM (Lower MCS)','Due to SW issue, the gNB does not provide UL grants under certain conditions','The gNB does not provide UL grant for short packets meeting the criteria:\n(RB= min 8RB, Waveform = DFT OFDM , MCS ~= Transition','Data Stalls seen at UE','User experience',NULL,'Disable UL Waveform Adaptation','AU 21D'),(23,'vDU 22A','Open','SNAP/BAU','C-Band/DSS','External','Retainability & Accessibility','100% ENDC Access Failure and ENDC drop','100% ENDC Access Failure rate and ENDC drop is observed after vDU initialization/SW Upgrade','During vDU initialization, F1 IP Address is not configured due to missing synchronization between Configuration Management(CM) block and DFCB block','100% Access Failures and ENDC Drop','[0xB005]CauseInternalMDSSendFail >0','Automatic Recovery script is in progress Check [0xB005]CauseInternalMDSSendFail >0','Cell lock/unlock to be performed on the offender vDU','vDU 22CP3'),(24,'vDU 22A','Open','SNAP/BAU','C-Band(64T64R)','External','Retainability','100% ENDC Drop due to wrong eAxc_ID configuration in MMU on 22A P3 LS6 vDU','100 % ENDC Drops due to the pegging of the cause code [0x101A]CauseInternalRandomAccessProblem','During vDU initialization/cell setup procedure, M-plane configuration message processed by Radio Configuration Module(RCM) is lost and invalid configuration was made to eAxC_ID leading to Rach Messages(MSG3) not getting decoded by vDU.','100% ENDC DROP on the offender vDU','RACH MSG1=(RachPreambleAPerBeam+RachPreambleACFRAPerBeam)\nRACH MSG3=(NumMSG3PerBeam+NumMSG3CFRAPerBeam)\nRACH MSG1 is high and RACH MSG3=0 along with CU-CSL 0x101A, CauseInternalRandomAccessProblem being pegged','Automatic Recovery script is in progress\nLogin in to MMU Ushell and check Abnormal register config\nNormal Config:\nNormal FPGA EAXCID register value:\nUShell >md 0xa980e2c0 NOTE: \n0xa980e2c0: 0000 0000 0001 0000 0002 0000 0003 0000  0xa980e2d0: 0004 0000 0005 0000 0006 0000 0007 0000  0xa980e2e0: 0008 0000 0009 0000 000a 0000 000b 0000  0xa980e2f0: 000c 0000 000d 0000 000e 0000 000f 0000 \nAbnormal Config Example:\nAbnormal FPGA EAXCID register value:\nUShell >md 0xa980e2c0 \n0xa980e2c0: 0000 0000 0001 0000 0002 0000 0003 0000 0xa980e2d0: 0004 0000 0005 0000 0006 0000 0007 0000 0xa980e2e0: 0008 0000 0009 0000 000a 0000 008b 0000 0xa980e2f0: 008c 0000 008d 0000 008e 0000 008f 0000','MMU reset to recover the wrong configuration','vDU 22CP3'),(25,'vDU 22A','Open','SNAP/BAU','C-Band(64T64R)','Internal','Retainability','100% ENDC Drop due to invalid packet length in MMU on 22A P3 LS6 vDU','100 % ENDC Drops due to the pegging of the cause code [0x101A]CauseInternalRandomAccessProblem','In rare cases, the UL control plane message is received out of synchronization window in MMU\nIt causes reading invalid length of packet from MMU buffer, MMU sends MSG3 packet to vDU with invalid packet length\nvDU fails to process the UL (MSG3)','100% ENDC DROP on the offender vDU','RACH MSG1=(RachPreambleAPerBeam+RachPreambleACFRAPerBeam)\nRACH MSG3=(NumMSG3PerBeam+NumMSG3CFRAPerBeam)\nRACH MSG1 is high and RACH MSG3=0 along with CU-CSL 0x101A, CauseInternalRandomAccessProblem being pegged','go to dpp pod -> pkg/bin/ -> .nphycli -> put “oran show errcnt” -> wait 10 seconds (During Rach fail happens)  -> put “oran show errcnt”\nCheck increase in 53, packet parsing error count to confirm this issue\nDevice ] ErrCnt\n[ id: stats name:thread] cnt : first time - last time: last value\n[ 11: 11_ota_source_main:+80us:0] 5197 : 1357366971.380778904 - 1357486735.946576494 : 85423 719\n[ 12: 12_ota_source_main:+60us:0] 12 : 1357366971.384577913 - 1357486735.946581738 : 63881 1725\n[ 13: 13_ota_source_main:+40us:0] 14 : 1357366971.384581268 - 1357486735.946586154 : 41511 2676\n[ 14: 14_ota_source_main:+20us:0] 67590 : 1357366971.384582911 - 1357615338.193112409 : 23123 31581\n[ 15: 15_ota_source_main:+10us:0] 195427 : 1357366971.384584748 - 1357615338.193113955 : 15741 1546\n[ 53: 53_parse_upul:x_payl:0] 53518659 : 1357366992.727101940 - 1357615338.997612246 : 4552 14 4556 4566 <-------------\n[ 53: 53_parse_upul:x_payl:1] 1703874 : 1357366992.727111977 - 1357615338.997605827 : 4552 14 4556 4566 <-------------\n[ 53: 53_parse_upul:x_payl:2] 14022 : 1357366992.727111977 - 1357615332.687607588 : 4552 14 4560 4566\n[ 53: 53_parse_upul:x_payl:3] 3 : 1357374781.937607376 - 1357482776.187102322 : 4560 14 4548 4574','MMU reset to recover the wrong configuration','vDU 22CP3'),(26,'vDU 22A','Open','SNAP/BAU','C-Band/DSS','Internal','Retainability','100% ENDC Drop due to nPHY thread hang','100 % ENDC Drops due to the pegging of the cause code [0x101A]CauseInternalRandomAccessProblem','At L1 nphy S/W modules for parallel processing, CPU core was not assigned properly. \nThere was a problem in task management module of 22A L1 nphy.\nIf the number of task and cores generated simultaneously does not match, the task management module could be blocked.','100% ENDC DROP on the offender vDU','RACH MSG1=(RachPreambleAPerBeam+RachPreambleACFRAPerBeam)\nRACH MSG3=(NumMSG3PerBeam+NumMSG3CFRAPerBeam)\nRACH MSG1 =0 and RACH MSG3=0 along with CU-CSL 0x101A, CauseInternalRandomAccessProblem being pegged','1.go to dpp pod -> /var/log/subsystem/phy -> and check nphy_error_log.txt.* files\nBelow log is continously printed in the error logs\nCorePoolRunner~:0202 I/CONTROL_COREPOOLRUNNER: Not enough memory for allocation of schedules. Already created 255 (CorePool1). This is highly liked caused by cpu issue\n2. go to dpp pod\n ps -ef | grep nphy\nroot 30828 1 99 Feb03 pts/0 17-14:03:10 /usr/local/bin/nphy.xcg ...\npstack 30828 >> pstack_dump.txt\n Check  Nr::TaskPipelineExecutor::waitTask()','Restart nPHY block to recover the site','vDU 22C'),(27,'NA','Open','SNAP/BAU','C-Band/DSS','Internal','Retainability','100% ENDC Drop due to thermal issue at the vDU','100 % ENDC Drops due to the pegging of the cause code [0x101A]CauseInternalRandomAccessProblem','Due to improper maintenance of cooling system at the vDU,the CPU went to high temperature and CPU clock is slowed down because of this high temeperature.This slower clock speed leads to delayed processing of MSG#1,2,3 at th L1 and L2 blocks of the DPP pod, which in turn leads to 100% msg1 and msg3 failures.','100% ENDC DROP on the offender vDU','RACH MSG1=(RachPreambleAPerBeam+RachPreambleACFRAPerBeam)\nRACH MSG3=(NumMSG3PerBeam+NumMSG3CFRAPerBeam)\nRACH MSG1 =0 and RACH MSG3=0 along with CU-CSL 0x101A, CauseInternalRandomAccessProblem being pegged','Check the CPU clock for the abnormal vDU and compare with normal case\nAbnormal case clock < Normal case,\nExample:\nNormal Case: 2499.938 Mhz\nAbnormal Case:799.987 Mhz','Restart the vDU to recover the CPU.But environment need to be changed by talking to VZW.otherwise same issue re-occurs periodically','Operational Issue'),(28,'vDU 22A','Open','SNAP/BAU','C-Band(64T64R)','External','Retainability','100% ENDC Drop due to Cable Swap between different sectors of vDU and MMU.','100 % ENDC Drops due to the pegging of the cause code [0x101A]CauseInternalRandomAccessProblem','DPP PORT==> ORU PORT\nAlpha DPP Port (0,3)=> ORU Port(0)\nAlpha DPP Port (1,4)=> ORU Port(1)\nAlpha DPP Port (2,5)=> ORU Port(2)\nVDU POD & NIC Interface mapping for  C-Band MMU\nRMP fh0, DPP fh0 : ens1f1 ↔ Alpha MMU L0\n DPP fh3 : ens2f1 ↔ Alpha MMU L1  \nRMP fh1, DPP fh1 : ens1f2 ↔ Beta MMU L0 \nDPP fh4 : ens2f2 ↔ Beta MMU L1  \nRMP fh2, DPP fh2 : ens1f3 ↔ Gamma MMU L0 \nDPP fh5 : ens2f3 ↔ Gamma MMU L1\nWhen these cables are connected wrongly, this leads to MSG3 decoding fails in the sectors where the cables are connected wrongly.','100% ENDC DROP on the offender vDU','RACH MSG1=(RachPreambleAPerBeam+RachPreambleACFRAPerBeam)\nRACH MSG3=(NumMSG3PerBeam+NumMSG3CFRAPerBeam)\nRACH MSG1 high  and RACH MSG3=0 along with CU-CSL 0x101A, CauseInternalRandomAccessProblem being pegged','Login to dmp pod and check loop back result\n[root@adpf13191033330-dmp0-66dd5484cf-vgd4z /]# nrconfd_cli -u vsmuser\nWelcome to the ConfD CLI\nvsmuser@adpf13191033330-dmp0-66dd5484cf-vgd4z 20:04:46>show table managed-element hardware-management o-ran-radio-unit o-ran-radio-unit-info cuplane-info  \nO                                                                                                 NR                                     \nRAN   CUPLANE                        CONNECTED  CONNECTED  CONNECTED                              SUPPORT                                \nRU    CONNECT  CONNECTED  CONNECTED  POD PORT   RU PORT    FSU PORT   VLAN  PROCESSING  LOOPBACK  CELL                   LOOPBACK  FPGA  \nID    TYPE     POD TYPE   POD ID     ID         ID         ID         ID    ELEMENT     RESULT    NUMBER   NAME          RESULT    ID    \n-----------------------------------------------------------------------------------------------------------------------------------------\n0     -        dpp        0          0          0          -          950   -           -         [ 0 ]    re_0_0_0_950  pass      -     \n               dpp        0          3          1          -          950   -           -         [ 0 ]    re_0_3_1_950  pass      -     \n1     -        dpp        0          1          0          -          950   -           -         [ 1 ]    re_0_1_0_950  pass      -     \n               dpp        0          4          1          -          950   -           -         [ 1 ]    re_0_4_1_950  fail     -     \n2     -        dpp        0          2          0          -          950   -           -         [ 2 ]    re_0_2_0_950  pass      -     \n               dpp        0          5          1          -          950   -           -         [ 2 ]    re_0_5_1_950  fail      -     ','Create external ticket and reach out to VZW NA team to correct the cable swap','Operational Issue'),(29,'vDU 22A','Open','SNAP/BAU','C-Band(64T64R)','External','Retainability','100% ENDC Drop due to various vDU-MMU interface alarms','100 % ENDC Drops due to the pegging of the cause code [0x101A]CauseInternalRandomAccessProblem','Due to the following reasons various vDU-MMU interface alarms are generated:\n1. SFPs connected to vDU and MMU become faulty\n2. CPRI cables are connected to wrong ports at MMU side\n3. Ethernet interfaces that connect MMU and vDU are down','100% ENDC DROP on the offender vDU','RACH MSG1=(RachPreambleAPerBeam+RachPreambleACFRAPerBeam)\nRACH MSG3=(NumMSG3PerBeam+NumMSG3CFRAPerBeam)\nRACH MSG1 high  and RACH MSG3=0 along with CU-CSL 0x101A, CauseInternalRandomAccessProblem being pegged','Check the vDU and MMU-Interface alarms\nSome of the alarms include:\n1. dpp port-down \n2. Digital Input low (DIL)\n3. Oran-interface fault','Create external ticket and reach out to VZW NA team to recover from the alarms','Operational Issue'),(30,'vDU 22A','Open','SNAP/BAU','C-Band(8T8R)','External','Retainability','100% ENDC Drop due to wrong firmware subtype','100 % ENDC Drops due to the pegging of the cause code [0x101A]CauseInternalRandomAccessProblem','Post 22A all vDU should be on the following firmware versions:\n8T8R: Subtype1\n4T4R: Subtype2\nIn some cases, during upgrade the RRH firmware is not correctly updated leading to wrong signal calibration and MSG3 decoding failure','100% ENDC DROP on the offender vDU','RACH MSG1=(RachPreambleAPerBeam+RachPreambleACFRAPerBeam)\nRACH MSG3=(NumMSG3PerBeam+NumMSG3CFRAPerBeam)\nRACH MSG1 high  and RACH MSG3=0 along with CU-CSL 0x101A, CauseInternalRandomAccessProblem being pegged','[HNRTNYCRLSM-MS03:/home/lsm] mmu_fw.sh 13693533746 \n----------------------------------------------------------------------------------------------------------------------------------------\nvDU ID: 13693533746\n----------------------------------------------------------------------------------------------------------------------------------------\nRU                                              PRODUCT     VENDOR  BUILD  BUILD  BUILD\nID    NAME  STATUS  ACTIVE  RUNNING  ACCESS     CODE        CODE    ID     NAME   VERSION      NAME   VERSION    PATH     INTEGRITY\n----------------------------------------------------------------------------------------------------------------------------------------\n0     ss_0  VALID   false   false    READ_ONLY  RT8808-77A  SS      1      subtype_1  1.0.1715645  .inits 22.A.0.01  pkg/bin     OK\n      ss_1  VALID   false   false    READ_WRITE RT8808-77A  SS      1      subtype_0  1.0.5172534  .inits 22.A.0.01  pkg/bin     OK\n      ss_2  VALID   true    true     READ_WRITE RT8808-77A  SS      1      subtype_1  1.0.5172515  .inits 22.A.0.01  pkg/bin     OK\n1     ss_0  VALID   false   false    READ_ONLY  RT8808-77A  SS      1      subtype_1  1.0.1715645  .inits 22.A.0.01  pkg/bin     OK\n      ss_1  VALID   false   false    READ_WRITE RT8808-77A  SS      1      subtype_0  1.0.5172534  .inits 22.A.0.01  pkg/bin     OK\n      ss_2  VALID   true    true     READ_WRITE RT8808-77A  SS      1      subtype_1  1.0.5172515  .inits 22.A.0.01  pkg/bin     OK\n2     ss_0  VALID   false   false    READ_ONLY  RT8808-77A  SS      1      subtype_1  1.0.1715645  .inits 22.A.0.01  pkg/bin     OK\n      ss_1  VALID   false   false    READ_WRITE RT8808-77A  SS      1      subtype_0  1.0.5172534  .inits 22.A.0.01  pkg/bin     OK\n      ss_2  VALID   true    true     READ_WRITE RT8808-77A  SS      1      subtype_1  1.0.5172515  .inits 22.A.0.01  pkg/bin     OK\n---------------------------------------------------------------------------------------------------------------------------------------','Create external ticket and reach out to VZW NA team to recover from the alarms','Operational Issue'),(31,'vDU 22A','Open','SNAP/BAU','DSS/Cband','External','Retainability','High ENDC Drop due to Intra-SgNB handover failures','100 % ENDC Drops due to the pegging of the cause code CauseF1ApMiscUnspecifiedFailure','After SCG Faiure when Intra-SgNB handover is triggerred immediately, MAC Scheduler rejects the UE Context Setup as it cannot allocate dedicated preamble','HIGH ENDC DROP on the offender vDU','CU CSL [0x2304]CauseF1apMiscUnspecifiedFailure, is pegged high','Check for  CU CSL [0x2304]CauseF1apMiscUnspecifiedFailure pegging high','Work-Around not available, fix is part of vDU 22C','vDU 22C'),(32,'AU/IAU 22A','Open','SNAP/BAU','mmWave','External','Accessibility','High FR2 Accessibility failure rate to S23 issue on AU/IAU with 4 contiguous carriers','FR2 accessibility degrades when S23 tries to access the AU/IAU with EndcAddfailCpfail and from enb side the fail is ENDC_AddFail_RRE','Due to UL permutation IAU/AU send band combinations to the UE which are not supported and UE responds back with RRE','High FR2 Access failures on AU/IAU','EndcAddfailCpfail on AU side and ENDC_AddFail_RRE on enb side.','Check for AU/IAU with 4 contiguous carriers.','Blacklist band combinations that cause the issue on AU/IAU','AU-22CP2, IAU-23A'),(33,'NA','Open','SNAP/BAU','C-Band/DSS/FR2','External','Accessibility & Retainability','TEST_CA Req Band and ENDC Band Config','Additional/missing NR Band configuration in CA Req Freq Band and mismatch between CA Req Freq Band and ENDC Band config','Due to additonal NR Band in CA Req Band config - eNB MRDC table getting filled and eNB \r\nnot \r\nsending correct band combo to vDU. \r\nDue to mstmatch between CA Req Band config and ENDC Band config - eNB does not \r\ninclude the \r\nex. n77 band combos whiile sending CBand sgNB Addition Req.','high access Fails due to DU Prep fail cause','High EndcAddPrepFail_DuFail','Testing_in progress','Add missing NR band or remove additional NR band in CA Req Band config and match the \r\nband \r\nconfig between CA Req Band config and ENDC band config','LTE 22C for missing/addiitional NR band.\r\nOpen issue for mismatch between CA Req Band and ENDC Band config'),(34,'21B','Open','SNAP/BAU','C-Band','Internal','Accessibility & Retainability','CAC_usecase','Almost Zero traffic for 3 to 4 hours after vDU CAC limit = 1200 is reached','No specific cause was identified from OM analysis by HQ.\nHQ requested to capture live logs while the issue is ongoing to further debug and root cause.','Almost zero traffic on the impacted cell\n100% Reconfiguration failures\n3 occurrences in the last 4 months (2 in May and 1 in July)','DU CSL:[0xB006]CauseInternalCacCallCountOver > 0',NULL,'vDU reset','Open Issue');
/*!40000 ALTER TABLE `known_knowledge_base` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `known_knowledge_base_07262023`
--

DROP TABLE IF EXISTS `known_knowledge_base_07262023`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `known_knowledge_base_07262023` (
  `issue` int NOT NULL,
  `SW` varchar(20) DEFAULT NULL,
  `Status` varchar(20) NOT NULL,
  `Area` varchar(20) NOT NULL,
  `Technology` varchar(50) DEFAULT NULL,
  `Visibility` varchar(50) DEFAULT NULL,
  `Major_KPI_Degradation` varchar(50) DEFAULT NULL,
  `Issue_Category` varchar(200) NOT NULL,
  `Description` varchar(500) DEFAULT NULL,
  `Root_Cause` varchar(1000) DEFAULT NULL,
  `Impact` varchar(150) DEFAULT NULL,
  `Detection_Methodology_OMs` varchar(500) DEFAULT NULL,
  `Detection_Methodology_Log_Script` varchar(5000) DEFAULT NULL,
  `Interim_Solution_Workaround` varchar(200) DEFAULT NULL,
  `Permanent_Fix` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`issue`,`Area`,`Status`,`Issue_Category`),
  KEY `idx_issue_known` (`issue`),
  KEY `idx1_issue_known` (`Status`,`Area`,`Technology`) /*!80000 INVISIBLE */,
  KEY `idx2_issue_known` (`Technology`,`Visibility`) /*!80000 INVISIBLE */,
  KEY `idx3_issue_known` (`Issue_Category`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `known_knowledge_base_07262023`
--

LOCK TABLES `known_knowledge_base_07262023` WRITE;
/*!40000 ALTER TABLE `known_knowledge_base_07262023` DISABLE KEYS */;
INSERT INTO `known_knowledge_base_07262023` VALUES (1,NULL,'Closed','SNAP/BAU','C-Band/DSS','Internal','OOS','UL Waveform Adaptation','Continuous UL DATA Arrival RACH and spike in SgNB Modification attempts resulting in almost zero traffic on the impacted cell','Issue occurs when the vDU MAC assigns invalid MCS (MCS 28) instead of Max MCS (MCC 27) for a DFT-S OFDM UE.\nUL grants are not sent to this specific UE and also no grants are allocated to any UE on the impacted cell.','Almost zero traffic on the impacted cell\n2 out of ~6500 cells on the audit day\n60 cells over a period of 3 months','huge delta in SgNB Modifications counters',NULL,'Cell lock/unlock','vDU 22AP2'),(2,'21B','Open','SNAP/BAU','C-Band','Internal','Accessibility & Retainability','CAC','Almost Zero traffic for 3 to 4 hours after vDU CAC limit = 1200 is reached','No specific cause was identified from OM analysis by HQ.\nHQ requested to capture live logs while the issue is ongoing to further debug and root cause.','Almost zero traffic on the impacted cell\n100% Reconfiguration failures\n3 occurrences in the last 4 months (2 in May and 1 in July)','DU CSL:[0xB006]CauseInternalCacCallCountOver > 0',NULL,'vDU reset','Open Issue'),(3,'NA','Open','SNAP/BAU','C-Band/DSS/FR2','External','Accessibility & Retainability','CA Req Band and ENDC Band Config','Additional/missing NR Band configuration in CA Req Freq Band and mismatch between CA Req Freq Band and ENDC Band config','Due to additonal NR Band in CA Req Band config - eNB MRDC table getting filled and eNB not sending correct band combo to vDU. \nDue to mstmatch between CA Req Band config and ENDC Band config - eNB does not include the ex. n77 band combos whiile sending CBand sgNB Addition Req.','high access Fails due to DU Prep fail cause','High EndcAddPrepFail_DuFail',NULL,'Add missing NR band or remove additional NR band in CA Req Band config and match the band config between CA Req Band config and ENDC band config','LTE 22C for missing/addiitional NR band.\nOpen issue for mismatch between CA Req Band and ENDC Band config'),(4,NULL,'Closed','SNAP/BAU','C-Band/DSS','External','Accessibility & Retainability','RLC IP','100% Reconfiguration failures & ENDC Drop Rate due to RLC IP conflict.','During any SW initialization, if correct sequence is not followed then mismatch of IP between vDU OS and YANG happens which results in call processing failures.\nThis issue may/may not occur during vDU reset, depending on the SW initialization sequence. If the VNP block initializes before NCM block initialization, the issue would not happen. Only when VNP block initializes after NCM block, ifindex does not get updated in YANG model and the issue can occur.','100% Reconfiguration failures & 100% ENDC Drop Rate\n6 occurrences in the last month','DU CSL: [ 0xB10F] CauseInternalRlcNoRoutableBeaerIp > 0',NULL,'Restart ncm.xcg SW block (run killall ncm.xcg ” in DPP POD)','vDU 22AP1'),(5,NULL,'Closed','SNAP/BAU','C-Band','External','Retainability','MMU Low I/Q','High ENDC Drop Rate due to NR RACH failures in specific sectors. Almost zero Msg1 attempts, i.e PRACH cannot be detected.','In FPGA processing, reference signal for the timing is 10ms frame. When internal block “RAFE/CIC” lost this 10 ms reference signal (sync error) signal processing to the next blocks is stopped which leads to low I/Q level in MMU.','100% ENDC Drop Rate\n 7 sites in latest audit, will be doing periodic audit to capture the site count','RACH MSG1 = 0, ENDC Drop Rate = 90-100% Then confirmation from MMU log',NULL,'MMU reset','vDU 22A'),(6,NULL,'Closed','SNAP/BAU','C-Band/DSS','Internal','Packet Loss','F1U DL Packet Loss','High packet loss observed on DL F1U interface from KPIs after DU/AU SW to 21D from 21B','Packet LOSS/Out of Sequence Cnt abnormally increases when processing gtp packets that do not include GTP SN The actual packet does not have LOSS, and only statistics collection is abnormal.','Shows high packet loss count after 21D upgrades','Spike in S5NR_F1UPacketLossRate_DL_%',NULL,'NA','vDU 22AP3 or 22C'),(7,NULL,'Closed','SNAP/BAU','C-Band/DSS','External','HO','Intra gNB HO Fail Rate','High fail rate in HO from SS n5/n2 to n77 in preparation phase','Issue is seen when n77 DL only device HO from n5/n2 to n77 \nSS vCU checks only target band but misses band combination check due to SW bug','Huge spike in Intra gNB HO fail rate','EndcIntraChgPrepSucc = 0 for n77 DL only devices\nHigh S5NR_IntragNBHOFailRate_% - SS n5/n2 --> n77',NULL,'NA','vCU 22AP1'),(8,'NA','Open','SNAP/BAU','C-Band/DSS','External','HO','Inter gNB HO Fail Rate','High fail rate in HO from SS FR1 to SS FR1','Issue is seen when N// anchor is missing relation to target NR and NR to NR HO triggers\nN// ANR will only add relation if X2 is manually defined, here X2 is missing (N// LTE to Target SS gNB)','Huge spike in Inter gNB HO fail rate','EndcInterChgSrcPrepFail_MenbFail > 0 (Src SS gNB)\nRx_X2apSgNBChangeRefuse > 0 (N// MeNB - Target SS gNB)',NULL,'Define missing X2 from N// LTE to Target SS gNB','Enhance N// ANR to define auto X2'),(9,NULL,'Closed','SNAP','C-Band','External','Retainability','High ENDC Drop Rate due to Sync Reconfig Fails','Observed spike in drop rate due to x1032 CRR after vDU 21DP2 upgrades','During N// n5/n2 to n77 HO, particularly in 21DP2 RACH Config Common IE is removed which causes HO exec failure and results in x1032 CRR Drop','High 0x1032 CRR during N// n5/n2 to n77 HO','Spike in [0x1032]CauseInternalSynchReconfigFailureScg CRR after 21DP2 upgrade from 21B',NULL,'Remove N// n5/n2 to n77 HO relations with VZ approval Also push for 21DP2.01 upgrades','vDU 21DP2.01'),(10,NULL,'Closed','SNAP','C-Band/DSS/mmW','External','Retainability','High ENDC Drop Rate due to Sync Reconfig Fails','Observed spike in drop rate due to x1032 CRR','During n77 to n5 IFHO, UE is directed to HO to weaker n77 cell\nWhen UE sends A5 MR it contains Intra Freq MR & Inter Freq MR, and ideally IFHO must trigger but due to SW bug HO is triggered to Intra Freq cell which is weaker than Source cell and resulting in Drop\nThis occurs only when target Inter Freq cell is not defined as neighbor','High 0x1032 CRR during any IFHO (n77<-->n5/n2, n77<-->FR2, n5/n2<-->FR2)','Spike in [0x1032]CauseInternalSynchReconfigFailureScg CRR during IFHO scenarios',NULL,'Define the missing relation to target inter freq cell','vCU 22AP2'),(11,NULL,'Closed','SNAP/BAU','C-Band','External','BLER','High UL Initial & Residual BLER','High BLER I-BLER > 10% and R-BLER > 1% \nPUCCH SR detected during DRX sleep period which is false SR','False SR mechanism was not well optimized.DCI for UL grant is sent but it is ignored as UE is in sleep mode (DRX) which results in no PUSCH and high BLER','Intial & Residual BLER spikes up by 40%','I & R BLER%',NULL,'Turn OFF DRX (until vDU 21DP2.01 deploys)','vDU 21DP2.01'),(12,NULL,'Closed','SNAP','C-Band','External','Retainability','High ENDC Drop Rate due to DU RLC Max Retx','Observed spike in drop rate due to x1022 CRR after C-Band launch','During N// n5/n2 to n77 HO, due to n77 missing max mimo layer IE it results in data stall followed by NR release due to x1022 CRR','High 0x1022 CRR during N// n5/n2 to n77 HO','Spike in [0x1022]CauseInternalDuRlcMaxNumRetx during N// n5/n2 to n77 HO',NULL,'Remove N// n5/n2 to n77 HO relations with VZ approval Also push for 21DP2.01 upgrades','vDU 21DP2.01'),(13,NULL,'Closed','SNAP/BAU','C-Band','External','Retainability','High ENDC Drop Rate due to DU RLC Max Retx','Observed spike in drop rate due to x1022 CRR after C-Band launch','In poor RF conditions large number of PRB allocation to UL power limited UEs lead to high UL BLER and unacknowledged DL RLC data, leading to DL RLC retx and finally drop call.','High 0x1022 CRR','Spike in [0x1022]CauseInternalDuRlcMaxNumRetx',NULL,'NA','vDU 21DP2.01'),(14,NULL,'Closed','SNAP/BAU','DSS','External','NR CA','High NR CA addition failure rate','Very high CA add fails during n5/n2 to n77 NR CA','Issue is seen when n77 PSCell only device is added in NR CA\nSS vCU checks only  band but misses band combination check due to SW bug','No impact to end user, counters/KPI show high failures','Very high CA_ACTION_DU:CaAddFail on n5/n2',NULL,'NA','vCU 22AP2'),(15,NULL,'Closed','SNAP/BAU','DSS','External','Retainability','Very high ENDC Drop Rate on n5/n2 cells','RACH failure and high ENDC Drop Rate increase on impacted cell due to x101A CRR','RACH issue is due to invalid PRACH data packets received on vDU.\nWhen upgrading eNB vDU , if there is unstable clock during CPRI link initialization','> 85% ENDC Drop rate on impacted cell','[0x101A]CauseInternalRandomAccessProblem; very high ENDC Drop Rate on DSS cell (>85%)',NULL,'Hard reset FSU\n“reset mode” = hard.\nAlso push to upgrade to FSU 21BP1.02 or later','FSU 21BP1.02'),(16,NULL,'Closed','SNAP','C-Band/DSS/mmW','External','Accessibility','High Reconfiguration Fail Rate','Spike in ENDC setup failures in SNAP markets','Signature shows failures are from N// eNBs cancelling the setup by sending release request instead of reconfiguration complete','High Access Fails due to MeNB cause','OMs: EndcAddFail_MenbFail > 0\n[0x402B] CauseX2apRadioNetworkLayerRadioConnectionWithUeLost>0',NULL,'Identify N// anchors and discuss with VZ for root cause','NA'),(17,NULL,'Closed','SNAP/BAU','4G','External','Accessibility','High ERAB SF Rate (90%) due to high Buffer usage in LTE 21D','Observed spike in ERAB SF Rate on 6 eNBs','Due to multi core operation, multiple threads are operated at the same time. Due to memory access timing issue, another core can try to access the same queue already in use, resulting in data corruption in the buffer. . Over time, buffer leak accumulates, resulting in reduced buffer availability. Some sites were observed to have reached buffer availability of 10% or less in ~30 days. Once the buffer is fully occupied, ERAB setup failures start to occur.','Users cannot access the site once the high buffer utilization is reached.','high CRR330 peg on sites',NULL,'Reset sites based on buffer utilization>70% from the daily audit','LTE 22A'),(18,NULL,'Closed','SNAP/BAU','4G','External','OOS','CBRS TX Path shutdown issue in LTE 21D','CBRS KPIs degraded post Preferred EARFCN changes and manual grant request procedure','As per LTE 21D design eNB doesn’t check the Tx status. The Tx status check is to be performed by RU prior to measuring the RSSI.Due to software bug when eNB requests the RSSI measurement, RU fails to check if all the cells are locked or Tx path is disabled.\nSince the RU did not check the Tx path status, the Tx path is shutdown resulting in RX only mode and RSSI is measured.\nThe Tx path remained shut down even after the CBRS grant procedure is completed and the cells were unlocked. This impacted the overall CBRS service','User experience is impacted since performance are degraded on CBRS cells.\nAll TX Paths are disabled on the CBRS RRH','Zero DL MAC Vol/THP, degradation on DL I BLER/R BLER, DL RLC ReTx for CBRS cells',NULL,'Reset CBRS RRH for sites where current-amp-state is shutdown from the daily audit','LTE 22AP2'),(19,NULL,'Closed','SNAP/BAU','4G','External','OOS','High UMP memory Alarms and Reboots for high capacity sites in LTE 21D','Observed reboots on sites with high traffic after critical UMP memory alarms observed','ENDC users are taking up 2.2X more memory than LTE users. Due to this the ECCB memory is getting depleted quicker for high capacity sites leading to critical UMP memory alarms and reboots','Site is OOS for 5 minutes','Alarm: Check critical UMP memory alarm',NULL,'Implement HQ recommended 21D settings for high capacity sites','LTE 22A'),(20,'NA','Open','SNAP/BAU','C-Band/DSS','External','Retainability','High ENDC Drop when SgNB addtions are attempted from Nokia anchor >6miles','High % ENDC Drops due to the pegging of the cause code [0x101A]CauseInternalRandomAccessProblem','Due to PCI confusion(far anchor) Nokia anchor forwards the SgNB addition to wrong SgNB','High % ENDC DROP on the offender vDU','RACH MSG1=(RachPreambleAPerBeam+RachPreambleACFRAPerBeam)\nRACH MSG3=(NumMSG3PerBeam+NumMSG3CFRAPerBeam)\n(RACH MSG1/[0x101A]CauseInternalRandomAccessProblem)<10','Check there are more RandomAccess problems reported than the actual MSG1 detected\ncheck the anchor-vDU relation causing this drop and calculate the distance\nif distance is greater than 6miles, it falls under far anchor and this NBR relation need to be black listed','Reach out to VZW and black list the far anchor neighour relation','Operational Issue'),(21,'NA','Open','SNAP/BAU','C-Band','External','Retainability','100% ENDC Drop due to missing PTP clock sync','100 % ENDC Drops due to the pegging of the cause code [0x101A]CauseInternalRandomAccessProblem','Both vDU and MMU should be receiving the clock and should be in sync','100% ENDC DROP on the offender vDU','RACH MSG1=(RachPreambleAPerBeam+RachPreambleACFRAPerBeam)\nRACH MSG3=(NumMSG3PerBeam+NumMSG3CFRAPerBeam)\nRACH MSG1 =0  and RACH MSG3=0 along with CU-CSL 0x101A, CauseInternalRandomAccessProblem being pegged, on all the 3 sectors','check the PTP clock sync at both vDU and MMU\nChecking Method:\nvsmuser@adpf13291523020-dmp0-76c595d464-f2f58 21:33:19>show managed-element hardware-management o-ran-radio-unit o-ran-radio-unit-info sync o-ran-sync sync\nmanaged-element hardware-management o-ran-radio-unit o-ran-radio-unit-info 0\nsync o-ran-sync sync sync-capability sync-t-tsc -\nsync o-ran-sync sync sync-status sync-state LOCKED\nITEM \nAbove sync state should be in locked state.','Create external ticket and reach out to VZW NA team to recover the clock sync','Operational Issue'),(22,NULL,'Closed','SNAP/BAU','mmWave','External','Data Stall','Data stalls seen at the UE when UE tries to move from CP to DFTs OFDM (Lower MCS)','Due to SW issue, the gNB does not provide UL grants under certain conditions','The gNB does not provide UL grant for short packets meeting the criteria:\n(RB= min 8RB, Waveform = DFT OFDM , MCS ~= Transition','Data Stalls seen at UE','User experience',NULL,'Disable UL Waveform Adaptation','AU 21D'),(23,'vDU 22A','Open','SNAP/BAU','C-Band/DSS','External','Retainability & Accessibility','100% ENDC Access Failure and ENDC drop','100% ENDC Access Failure rate and ENDC drop is observed after vDU initialization/SW Upgrade','During vDU initialization, F1 IP Address is not configured due to missing synchronization between Configuration Management(CM) block and DFCB block','100% Access Failures and ENDC Drop','[0xB005]CauseInternalMDSSendFail >0','Automatic Recovery script is in progress Check [0xB005]CauseInternalMDSSendFail >0','Cell lock/unlock to be performed on the offender vDU','vDU 22CP3'),(24,'vDU 22A','Open','SNAP/BAU','C-Band(64T64R)','External','Retainability','100% ENDC Drop due to wrong eAxc_ID configuration in MMU on 22A P3 LS6 vDU','100 % ENDC Drops due to the pegging of the cause code [0x101A]CauseInternalRandomAccessProblem','During vDU initialization/cell setup procedure, M-plane configuration message processed by Radio Configuration Module(RCM) is lost and invalid configuration was made to eAxC_ID leading to Rach Messages(MSG3) not getting decoded by vDU.','100% ENDC DROP on the offender vDU','RACH MSG1=(RachPreambleAPerBeam+RachPreambleACFRAPerBeam)\nRACH MSG3=(NumMSG3PerBeam+NumMSG3CFRAPerBeam)\nRACH MSG1 is high and RACH MSG3=0 along with CU-CSL 0x101A, CauseInternalRandomAccessProblem being pegged','Automatic Recovery script is in progress\nLogin in to MMU Ushell and check Abnormal register config\nNormal Config:\nNormal FPGA EAXCID register value:\nUShell >md 0xa980e2c0 NOTE: \n0xa980e2c0: 0000 0000 0001 0000 0002 0000 0003 0000  0xa980e2d0: 0004 0000 0005 0000 0006 0000 0007 0000  0xa980e2e0: 0008 0000 0009 0000 000a 0000 000b 0000  0xa980e2f0: 000c 0000 000d 0000 000e 0000 000f 0000 \nAbnormal Config Example:\nAbnormal FPGA EAXCID register value:\nUShell >md 0xa980e2c0 \n0xa980e2c0: 0000 0000 0001 0000 0002 0000 0003 0000 0xa980e2d0: 0004 0000 0005 0000 0006 0000 0007 0000 0xa980e2e0: 0008 0000 0009 0000 000a 0000 008b 0000 0xa980e2f0: 008c 0000 008d 0000 008e 0000 008f 0000','MMU reset to recover the wrong configuration','vDU 22CP3'),(25,'vDU 22A','Open','SNAP/BAU','C-Band(64T64R)','Internal','Retainability','100% ENDC Drop due to invalid packet length in MMU on 22A P3 LS6 vDU','100 % ENDC Drops due to the pegging of the cause code [0x101A]CauseInternalRandomAccessProblem','In rare cases, the UL control plane message is received out of synchronization window in MMU\nIt causes reading invalid length of packet from MMU buffer, MMU sends MSG3 packet to vDU with invalid packet length\nvDU fails to process the UL (MSG3)','100% ENDC DROP on the offender vDU','RACH MSG1=(RachPreambleAPerBeam+RachPreambleACFRAPerBeam)\nRACH MSG3=(NumMSG3PerBeam+NumMSG3CFRAPerBeam)\nRACH MSG1 is high and RACH MSG3=0 along with CU-CSL 0x101A, CauseInternalRandomAccessProblem being pegged','go to dpp pod -> pkg/bin/ -> .nphycli -> put “oran show errcnt” -> wait 10 seconds (During Rach fail happens)  -> put “oran show errcnt”\nCheck increase in 53, packet parsing error count to confirm this issue\nDevice ] ErrCnt\n[ id: stats name:thread] cnt : first time - last time: last value\n[ 11: 11_ota_source_main:+80us:0] 5197 : 1357366971.380778904 - 1357486735.946576494 : 85423 719\n[ 12: 12_ota_source_main:+60us:0] 12 : 1357366971.384577913 - 1357486735.946581738 : 63881 1725\n[ 13: 13_ota_source_main:+40us:0] 14 : 1357366971.384581268 - 1357486735.946586154 : 41511 2676\n[ 14: 14_ota_source_main:+20us:0] 67590 : 1357366971.384582911 - 1357615338.193112409 : 23123 31581\n[ 15: 15_ota_source_main:+10us:0] 195427 : 1357366971.384584748 - 1357615338.193113955 : 15741 1546\n[ 53: 53_parse_upul:x_payl:0] 53518659 : 1357366992.727101940 - 1357615338.997612246 : 4552 14 4556 4566 <-------------\n[ 53: 53_parse_upul:x_payl:1] 1703874 : 1357366992.727111977 - 1357615338.997605827 : 4552 14 4556 4566 <-------------\n[ 53: 53_parse_upul:x_payl:2] 14022 : 1357366992.727111977 - 1357615332.687607588 : 4552 14 4560 4566\n[ 53: 53_parse_upul:x_payl:3] 3 : 1357374781.937607376 - 1357482776.187102322 : 4560 14 4548 4574','MMU reset to recover the wrong configuration','vDU 22CP3'),(26,'vDU 22A','Open','SNAP/BAU','C-Band/DSS','Internal','Retainability','100% ENDC Drop due to nPHY thread hang','100 % ENDC Drops due to the pegging of the cause code [0x101A]CauseInternalRandomAccessProblem','At L1 nphy S/W modules for parallel processing, CPU core was not assigned properly. \nThere was a problem in task management module of 22A L1 nphy.\nIf the number of task and cores generated simultaneously does not match, the task management module could be blocked.','100% ENDC DROP on the offender vDU','RACH MSG1=(RachPreambleAPerBeam+RachPreambleACFRAPerBeam)\nRACH MSG3=(NumMSG3PerBeam+NumMSG3CFRAPerBeam)\nRACH MSG1 =0 and RACH MSG3=0 along with CU-CSL 0x101A, CauseInternalRandomAccessProblem being pegged','1.go to dpp pod -> /var/log/subsystem/phy -> and check nphy_error_log.txt.* files\nBelow log is continously printed in the error logs\nCorePoolRunner~:0202 I/CONTROL_COREPOOLRUNNER: Not enough memory for allocation of schedules. Already created 255 (CorePool1). This is highly liked caused by cpu issue\n2. go to dpp pod\n ps -ef | grep nphy\nroot 30828 1 99 Feb03 pts/0 17-14:03:10 /usr/local/bin/nphy.xcg ...\npstack 30828 >> pstack_dump.txt\n Check  Nr::TaskPipelineExecutor::waitTask()','Restart nPHY block to recover the site','vDU 22C'),(27,'NA','Open','SNAP/BAU','C-Band/DSS','Internal','Retainability','100% ENDC Drop due to thermal issue at the vDU','100 % ENDC Drops due to the pegging of the cause code [0x101A]CauseInternalRandomAccessProblem','Due to improper maintenance of cooling system at the vDU,the CPU went to high temperature and CPU clock is slowed down because of this high temeperature.This slower clock speed leads to delayed processing of MSG#1,2,3 at th L1 and L2 blocks of the DPP pod, which in turn leads to 100% msg1 and msg3 failures.','100% ENDC DROP on the offender vDU','RACH MSG1=(RachPreambleAPerBeam+RachPreambleACFRAPerBeam)\nRACH MSG3=(NumMSG3PerBeam+NumMSG3CFRAPerBeam)\nRACH MSG1 =0 and RACH MSG3=0 along with CU-CSL 0x101A, CauseInternalRandomAccessProblem being pegged','Check the CPU clock for the abnormal vDU and compare with normal case\nAbnormal case clock < Normal case,\nExample:\nNormal Case: 2499.938 Mhz\nAbnormal Case:799.987 Mhz','Restart the vDU to recover the CPU.But environment need to be changed by talking to VZW.otherwise same issue re-occurs periodically','Operational Issue'),(28,'vDU 22A','Open','SNAP/BAU','C-Band(64T64R)','External','Retainability','100% ENDC Drop due to Cable Swap between different sectors of vDU and MMU.','100 % ENDC Drops due to the pegging of the cause code [0x101A]CauseInternalRandomAccessProblem','DPP PORT==> ORU PORT\nAlpha DPP Port (0,3)=> ORU Port(0)\nAlpha DPP Port (1,4)=> ORU Port(1)\nAlpha DPP Port (2,5)=> ORU Port(2)\nVDU POD & NIC Interface mapping for  C-Band MMU\nRMP fh0, DPP fh0 : ens1f1 ↔ Alpha MMU L0\n DPP fh3 : ens2f1 ↔ Alpha MMU L1  \nRMP fh1, DPP fh1 : ens1f2 ↔ Beta MMU L0 \nDPP fh4 : ens2f2 ↔ Beta MMU L1  \nRMP fh2, DPP fh2 : ens1f3 ↔ Gamma MMU L0 \nDPP fh5 : ens2f3 ↔ Gamma MMU L1\nWhen these cables are connected wrongly, this leads to MSG3 decoding fails in the sectors where the cables are connected wrongly.','100% ENDC DROP on the offender vDU','RACH MSG1=(RachPreambleAPerBeam+RachPreambleACFRAPerBeam)\nRACH MSG3=(NumMSG3PerBeam+NumMSG3CFRAPerBeam)\nRACH MSG1 high  and RACH MSG3=0 along with CU-CSL 0x101A, CauseInternalRandomAccessProblem being pegged','Login to dmp pod and check loop back result\n[root@adpf13191033330-dmp0-66dd5484cf-vgd4z /]# nrconfd_cli -u vsmuser\nWelcome to the ConfD CLI\nvsmuser@adpf13191033330-dmp0-66dd5484cf-vgd4z 20:04:46>show table managed-element hardware-management o-ran-radio-unit o-ran-radio-unit-info cuplane-info  \nO                                                                                                 NR                                     \nRAN   CUPLANE                        CONNECTED  CONNECTED  CONNECTED                              SUPPORT                                \nRU    CONNECT  CONNECTED  CONNECTED  POD PORT   RU PORT    FSU PORT   VLAN  PROCESSING  LOOPBACK  CELL                   LOOPBACK  FPGA  \nID    TYPE     POD TYPE   POD ID     ID         ID         ID         ID    ELEMENT     RESULT    NUMBER   NAME          RESULT    ID    \n-----------------------------------------------------------------------------------------------------------------------------------------\n0     -        dpp        0          0          0          -          950   -           -         [ 0 ]    re_0_0_0_950  pass      -     \n               dpp        0          3          1          -          950   -           -         [ 0 ]    re_0_3_1_950  pass      -     \n1     -        dpp        0          1          0          -          950   -           -         [ 1 ]    re_0_1_0_950  pass      -     \n               dpp        0          4          1          -          950   -           -         [ 1 ]    re_0_4_1_950  fail     -     \n2     -        dpp        0          2          0          -          950   -           -         [ 2 ]    re_0_2_0_950  pass      -     \n               dpp        0          5          1          -          950   -           -         [ 2 ]    re_0_5_1_950  fail      -     ','Create external ticket and reach out to VZW NA team to correct the cable swap','Operational Issue'),(29,'vDU 22A','Open','SNAP/BAU','C-Band(64T64R)','External','Retainability','100% ENDC Drop due to various vDU-MMU interface alarms','100 % ENDC Drops due to the pegging of the cause code [0x101A]CauseInternalRandomAccessProblem','Due to the following reasons various vDU-MMU interface alarms are generated:\n1. SFPs connected to vDU and MMU become faulty\n2. CPRI cables are connected to wrong ports at MMU side\n3. Ethernet interfaces that connect MMU and vDU are down','100% ENDC DROP on the offender vDU','RACH MSG1=(RachPreambleAPerBeam+RachPreambleACFRAPerBeam)\nRACH MSG3=(NumMSG3PerBeam+NumMSG3CFRAPerBeam)\nRACH MSG1 high  and RACH MSG3=0 along with CU-CSL 0x101A, CauseInternalRandomAccessProblem being pegged','Check the vDU and MMU-Interface alarms\nSome of the alarms include:\n1. dpp port-down \n2. Digital Input low (DIL)\n3. Oran-interface fault','Create external ticket and reach out to VZW NA team to recover from the alarms','Operational Issue'),(30,'vDU 22A','Open','SNAP/BAU','C-Band(8T8R)','External','Retainability','100% ENDC Drop due to wrong firmware subtype','100 % ENDC Drops due to the pegging of the cause code [0x101A]CauseInternalRandomAccessProblem','Post 22A all vDU should be on the following firmware versions:\n8T8R: Subtype1\n4T4R: Subtype2\nIn some cases, during upgrade the RRH firmware is not correctly updated leading to wrong signal calibration and MSG3 decoding failure','100% ENDC DROP on the offender vDU','RACH MSG1=(RachPreambleAPerBeam+RachPreambleACFRAPerBeam)\nRACH MSG3=(NumMSG3PerBeam+NumMSG3CFRAPerBeam)\nRACH MSG1 high  and RACH MSG3=0 along with CU-CSL 0x101A, CauseInternalRandomAccessProblem being pegged','[HNRTNYCRLSM-MS03:/home/lsm] mmu_fw.sh 13693533746 \n----------------------------------------------------------------------------------------------------------------------------------------\nvDU ID: 13693533746\n----------------------------------------------------------------------------------------------------------------------------------------\nRU                                              PRODUCT     VENDOR  BUILD  BUILD  BUILD\nID    NAME  STATUS  ACTIVE  RUNNING  ACCESS     CODE        CODE    ID     NAME   VERSION      NAME   VERSION    PATH     INTEGRITY\n----------------------------------------------------------------------------------------------------------------------------------------\n0     ss_0  VALID   false   false    READ_ONLY  RT8808-77A  SS      1      subtype_1  1.0.1715645  .inits 22.A.0.01  pkg/bin     OK\n      ss_1  VALID   false   false    READ_WRITE RT8808-77A  SS      1      subtype_0  1.0.5172534  .inits 22.A.0.01  pkg/bin     OK\n      ss_2  VALID   true    true     READ_WRITE RT8808-77A  SS      1      subtype_1  1.0.5172515  .inits 22.A.0.01  pkg/bin     OK\n1     ss_0  VALID   false   false    READ_ONLY  RT8808-77A  SS      1      subtype_1  1.0.1715645  .inits 22.A.0.01  pkg/bin     OK\n      ss_1  VALID   false   false    READ_WRITE RT8808-77A  SS      1      subtype_0  1.0.5172534  .inits 22.A.0.01  pkg/bin     OK\n      ss_2  VALID   true    true     READ_WRITE RT8808-77A  SS      1      subtype_1  1.0.5172515  .inits 22.A.0.01  pkg/bin     OK\n2     ss_0  VALID   false   false    READ_ONLY  RT8808-77A  SS      1      subtype_1  1.0.1715645  .inits 22.A.0.01  pkg/bin     OK\n      ss_1  VALID   false   false    READ_WRITE RT8808-77A  SS      1      subtype_0  1.0.5172534  .inits 22.A.0.01  pkg/bin     OK\n      ss_2  VALID   true    true     READ_WRITE RT8808-77A  SS      1      subtype_1  1.0.5172515  .inits 22.A.0.01  pkg/bin     OK\n---------------------------------------------------------------------------------------------------------------------------------------','Create external ticket and reach out to VZW NA team to recover from the alarms','Operational Issue'),(31,'vDU 22A','Open','SNAP/BAU','DSS/Cband','External','Retainability','High ENDC Drop due to Intra-SgNB handover failures','100 % ENDC Drops due to the pegging of the cause code CauseF1ApMiscUnspecifiedFailure','After SCG Faiure when Intra-SgNB handover is triggerred immediately, MAC Scheduler rejects the UE Context Setup as it cannot allocate dedicated preamble','HIGH ENDC DROP on the offender vDU','CU CSL [0x2304]CauseF1apMiscUnspecifiedFailure, is pegged high','Check for  CU CSL [0x2304]CauseF1apMiscUnspecifiedFailure pegging high','Work-Around not available, fix is part of vDU 22C','vDU 22C'),(32,'AU/IAU 22A','Open','SNAP/BAU','mmWave','External','Accessibility','High FR2 Accessibility failure rate to S23 issue on AU/IAU with 4 contiguous carriers','FR2 accessibility degrades when S23 tries to access the AU/IAU with EndcAddfailCpfail and from enb side the fail is ENDC_AddFail_RRE','Due to UL permutation IAU/AU send band combinations to the UE which are not supported and UE responds back with RRE','High FR2 Access failures on AU/IAU','EndcAddfailCpfail on AU side and ENDC_AddFail_RRE on enb side.','Check for AU/IAU with 4 contiguous carriers.','Blacklist band combinations that cause the issue on AU/IAU','AU-22CP2, IAU-23A'),(33,'NA','Open','SNAP/BAU','C-Band/DSS/FR2','External','Accessibility & Retainability','TEST_CA Req Band and ENDC Band Config','Additional/missing NR Band configuration in CA Req Freq Band and mismatch between CA Req Freq Band and ENDC Band config','Due to additonal NR Band in CA Req Band config - eNB MRDC table getting filled and eNB not sending correct band combo to vDU. \nDue to mstmatch between CA Req Band config and ENDC Band config - eNB does not include the ex. n77 band combos whiile sending CBand sgNB Addition Req.','high access Fails due to DU Prep fail cause','High EndcAddPrepFail_DuFail',NULL,'Add missing NR band or remove additional NR band in CA Req Band config and match the band config between CA Req Band config and ENDC band config','LTE 22C for missing/addiitional NR band.\nOpen issue for mismatch between CA Req Band and ENDC Band config');
/*!40000 ALTER TABLE `known_knowledge_base_07262023` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `known_knowledge_base_backup`
--

DROP TABLE IF EXISTS `known_knowledge_base_backup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `known_knowledge_base_backup` (
  `issue` int NOT NULL,
  `SW` varchar(20) DEFAULT NULL,
  `Status` varchar(20) NOT NULL,
  `Area` varchar(20) NOT NULL,
  `Technology` varchar(50) DEFAULT NULL,
  `Visibility` varchar(50) DEFAULT NULL,
  `Major_KPI_Degradation` varchar(50) DEFAULT NULL,
  `Issue_Category` varchar(200) NOT NULL,
  `Description` varchar(500) DEFAULT NULL,
  `Root_Cause` varchar(1000) DEFAULT NULL,
  `Impact` varchar(150) DEFAULT NULL,
  `Detection_Methodology_OMs` varchar(500) DEFAULT NULL,
  `Detection_Methodology_Log_Script` varchar(5000) DEFAULT NULL,
  `Interim_Solution_Workaround` varchar(200) DEFAULT NULL,
  `Permanent_Fix` varchar(200) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `known_knowledge_base_backup`
--

LOCK TABLES `known_knowledge_base_backup` WRITE;
/*!40000 ALTER TABLE `known_knowledge_base_backup` DISABLE KEYS */;
INSERT INTO `known_knowledge_base_backup` VALUES (1,NULL,'Closed','SNAP/BAU','C-Band/DSS','Internal','OOS','UL Waveform Adaptation','Continuous UL DATA Arrival RACH and spike in SgNB Modification attempts resulting in almost zero traffic on the impacted cell','Issue occurs when the vDU MAC assigns invalid MCS (MCS 28) instead of Max MCS (MCC 27) for a DFT-S OFDM UE.\nUL grants are not sent to this specific UE and also no grants are allocated to any UE on the impacted cell.','Almost zero traffic on the impacted cell\n2 out of ~6500 cells on the audit day\n60 cells over a period of 3 months','huge delta in SgNB Modifications counters',NULL,'Cell lock/unlock','vDU 22AP2'),(2,'21B','Open','SNAP/BAU','C-Band','Internal','Accessibility & Retainability','CAC','Almost Zero traffic for 3 to 4 hours after vDU CAC limit = 1200 is reached','No specific cause was identified from OM analysis by HQ.\nHQ requested to capture live logs while the issue is ongoing to further debug and root cause.','Almost zero traffic on the impacted cell\n100% Reconfiguration failures\n3 occurrences in the last 4 months (2 in May and 1 in July)','DU CSL:[0xB006]CauseInternalCacCallCountOver > 0',NULL,'vDU reset','Open Issue'),(3,'NA','Open','SNAP/BAU','C-Band/DSS/FR2','External','Accessibility & Retainability','CA Req Band and ENDC Band Config','Additional/missing NR Band configuration in CA Req Freq Band and mismatch between CA Req Freq Band and ENDC Band config','Due to additonal NR Band in CA Req Band config - eNB MRDC table getting filled and eNB not sending correct band combo to vDU. \nDue to mstmatch between CA Req Band config and ENDC Band config - eNB does not include the ex. n77 band combos whiile sending CBand sgNB Addition Req.','high access Fails due to DU Prep fail cause','High EndcAddPrepFail_DuFail',NULL,'Add missing NR band or remove additional NR band in CA Req Band config and match the band config between CA Req Band config and ENDC band config','LTE 22C for missing/addiitional NR band.\nOpen issue for mismatch between CA Req Band and ENDC Band config'),(4,NULL,'Closed','SNAP/BAU','C-Band/DSS','External','Accessibility & Retainability','RLC IP','100% Reconfiguration failures & ENDC Drop Rate due to RLC IP conflict.','During any SW initialization, if correct sequence is not followed then mismatch of IP between vDU OS and YANG happens which results in call processing failures.\nThis issue may/may not occur during vDU reset, depending on the SW initialization sequence. If the VNP block initializes before NCM block initialization, the issue would not happen. Only when VNP block initializes after NCM block, ifindex does not get updated in YANG model and the issue can occur.','100% Reconfiguration failures & 100% ENDC Drop Rate\n6 occurrences in the last month','DU CSL: [ 0xB10F] CauseInternalRlcNoRoutableBeaerIp > 0',NULL,'Restart ncm.xcg SW block (run killall ncm.xcg ” in DPP POD)','vDU 22AP1'),(5,NULL,'Closed','SNAP/BAU','C-Band','External','Retainability','MMU Low I/Q','High ENDC Drop Rate due to NR RACH failures in specific sectors. Almost zero Msg1 attempts, i.e PRACH cannot be detected.','In FPGA processing, reference signal for the timing is 10ms frame. When internal block “RAFE/CIC” lost this 10 ms reference signal (sync error) signal processing to the next blocks is stopped which leads to low I/Q level in MMU.','100% ENDC Drop Rate\n 7 sites in latest audit, will be doing periodic audit to capture the site count','RACH MSG1 = 0, ENDC Drop Rate = 90-100% Then confirmation from MMU log',NULL,'MMU reset','vDU 22A'),(6,NULL,'Closed','SNAP/BAU','C-Band/DSS','Internal','Packet Loss','F1U DL Packet Loss','High packet loss observed on DL F1U interface from KPIs after DU/AU SW to 21D from 21B','Packet LOSS/Out of Sequence Cnt abnormally increases when processing gtp packets that do not include GTP SN The actual packet does not have LOSS, and only statistics collection is abnormal.','Shows high packet loss count after 21D upgrades','Spike in S5NR_F1UPacketLossRate_DL_%',NULL,'NA','vDU 22AP3 or 22C'),(7,NULL,'Closed','SNAP/BAU','C-Band/DSS','External','HO','Intra gNB HO Fail Rate','High fail rate in HO from SS n5/n2 to n77 in preparation phase','Issue is seen when n77 DL only device HO from n5/n2 to n77 \nSS vCU checks only target band but misses band combination check due to SW bug','Huge spike in Intra gNB HO fail rate','EndcIntraChgPrepSucc = 0 for n77 DL only devices\nHigh S5NR_IntragNBHOFailRate_% - SS n5/n2 --> n77',NULL,'NA','vCU 22AP1'),(8,'NA','Open','SNAP/BAU','C-Band/DSS','External','HO','Inter gNB HO Fail Rate','High fail rate in HO from SS FR1 to SS FR1','Issue is seen when N// anchor is missing relation to target NR and NR to NR HO triggers\nN// ANR will only add relation if X2 is manually defined, here X2 is missing (N// LTE to Target SS gNB)','Huge spike in Inter gNB HO fail rate','EndcInterChgSrcPrepFail_MenbFail > 0 (Src SS gNB)\nRx_X2apSgNBChangeRefuse > 0 (N// MeNB - Target SS gNB)',NULL,'Define missing X2 from N// LTE to Target SS gNB','Enhance N// ANR to define auto X2'),(9,NULL,'Closed','SNAP','C-Band','External','Retainability','High ENDC Drop Rate due to Sync Reconfig Fails','Observed spike in drop rate due to x1032 CRR after vDU 21DP2 upgrades','During N// n5/n2 to n77 HO, particularly in 21DP2 RACH Config Common IE is removed which causes HO exec failure and results in x1032 CRR Drop','High 0x1032 CRR during N// n5/n2 to n77 HO','Spike in [0x1032]CauseInternalSynchReconfigFailureScg CRR after 21DP2 upgrade from 21B',NULL,'Remove N// n5/n2 to n77 HO relations with VZ approval Also push for 21DP2.01 upgrades','vDU 21DP2.01'),(10,NULL,'Closed','SNAP','C-Band/DSS/mmW','External','Retainability','High ENDC Drop Rate due to Sync Reconfig Fails','Observed spike in drop rate due to x1032 CRR','During n77 to n5 IFHO, UE is directed to HO to weaker n77 cell\nWhen UE sends A5 MR it contains Intra Freq MR & Inter Freq MR, and ideally IFHO must trigger but due to SW bug HO is triggered to Intra Freq cell which is weaker than Source cell and resulting in Drop\nThis occurs only when target Inter Freq cell is not defined as neighbor','High 0x1032 CRR during any IFHO (n77<-->n5/n2, n77<-->FR2, n5/n2<-->FR2)','Spike in [0x1032]CauseInternalSynchReconfigFailureScg CRR during IFHO scenarios',NULL,'Define the missing relation to target inter freq cell','vCU 22AP2'),(11,NULL,'Closed','SNAP/BAU','C-Band','External','BLER','High UL Initial & Residual BLER','High BLER I-BLER > 10% and R-BLER > 1% \nPUCCH SR detected during DRX sleep period which is false SR','False SR mechanism was not well optimized.DCI for UL grant is sent but it is ignored as UE is in sleep mode (DRX) which results in no PUSCH and high BLER','Intial & Residual BLER spikes up by 40%','I & R BLER%',NULL,'Turn OFF DRX (until vDU 21DP2.01 deploys)','vDU 21DP2.01'),(12,NULL,'Closed','SNAP','C-Band','External','Retainability','High ENDC Drop Rate due to DU RLC Max Retx','Observed spike in drop rate due to x1022 CRR after C-Band launch','During N// n5/n2 to n77 HO, due to n77 missing max mimo layer IE it results in data stall followed by NR release due to x1022 CRR','High 0x1022 CRR during N// n5/n2 to n77 HO','Spike in [0x1022]CauseInternalDuRlcMaxNumRetx during N// n5/n2 to n77 HO',NULL,'Remove N// n5/n2 to n77 HO relations with VZ approval Also push for 21DP2.01 upgrades','vDU 21DP2.01'),(13,NULL,'Closed','SNAP/BAU','C-Band','External','Retainability','High ENDC Drop Rate due to DU RLC Max Retx','Observed spike in drop rate due to x1022 CRR after C-Band launch','In poor RF conditions large number of PRB allocation to UL power limited UEs lead to high UL BLER and unacknowledged DL RLC data, leading to DL RLC retx and finally drop call.','High 0x1022 CRR','Spike in [0x1022]CauseInternalDuRlcMaxNumRetx',NULL,'NA','vDU 21DP2.01'),(14,NULL,'Closed','SNAP/BAU','DSS','External','NR CA','High NR CA addition failure rate','Very high CA add fails during n5/n2 to n77 NR CA','Issue is seen when n77 PSCell only device is added in NR CA\nSS vCU checks only  band but misses band combination check due to SW bug','No impact to end user, counters/KPI show high failures','Very high CA_ACTION_DU:CaAddFail on n5/n2',NULL,'NA','vCU 22AP2'),(15,NULL,'Closed','SNAP/BAU','DSS','External','Retainability','Very high ENDC Drop Rate on n5/n2 cells','RACH failure and high ENDC Drop Rate increase on impacted cell due to x101A CRR','RACH issue is due to invalid PRACH data packets received on vDU.\nWhen upgrading eNB vDU , if there is unstable clock during CPRI link initialization','> 85% ENDC Drop rate on impacted cell','[0x101A]CauseInternalRandomAccessProblem; very high ENDC Drop Rate on DSS cell (>85%)',NULL,'Hard reset FSU\n“reset mode” = hard.\nAlso push to upgrade to FSU 21BP1.02 or later','FSU 21BP1.02'),(16,NULL,'Closed','SNAP','C-Band/DSS/mmW','External','Accessibility','High Reconfiguration Fail Rate','Spike in ENDC setup failures in SNAP markets','Signature shows failures are from N// eNBs cancelling the setup by sending release request instead of reconfiguration complete','High Access Fails due to MeNB cause','OMs: EndcAddFail_MenbFail > 0\n[0x402B] CauseX2apRadioNetworkLayerRadioConnectionWithUeLost>0',NULL,'Identify N// anchors and discuss with VZ for root cause','NA'),(17,NULL,'Closed','SNAP/BAU','4G','External','Accessibility','High ERAB SF Rate (90%) due to high Buffer usage in LTE 21D','Observed spike in ERAB SF Rate on 6 eNBs','Due to multi core operation, multiple threads are operated at the same time. Due to memory access timing issue, another core can try to access the same queue already in use, resulting in data corruption in the buffer. . Over time, buffer leak accumulates, resulting in reduced buffer availability. Some sites were observed to have reached buffer availability of 10% or less in ~30 days. Once the buffer is fully occupied, ERAB setup failures start to occur.','Users cannot access the site once the high buffer utilization is reached.','high CRR330 peg on sites',NULL,'Reset sites based on buffer utilization>70% from the daily audit','LTE 22A'),(18,NULL,'Closed','SNAP/BAU','4G','External','OOS','CBRS TX Path shutdown issue in LTE 21D','CBRS KPIs degraded post Preferred EARFCN changes and manual grant request procedure','As per LTE 21D design eNB doesn’t check the Tx status. The Tx status check is to be performed by RU prior to measuring the RSSI.Due to software bug when eNB requests the RSSI measurement, RU fails to check if all the cells are locked or Tx path is disabled.\nSince the RU did not check the Tx path status, the Tx path is shutdown resulting in RX only mode and RSSI is measured.\nThe Tx path remained shut down even after the CBRS grant procedure is completed and the cells were unlocked. This impacted the overall CBRS service','User experience is impacted since performance are degraded on CBRS cells.\nAll TX Paths are disabled on the CBRS RRH','Zero DL MAC Vol/THP, degradation on DL I BLER/R BLER, DL RLC ReTx for CBRS cells',NULL,'Reset CBRS RRH for sites where current-amp-state is shutdown from the daily audit','LTE 22AP2'),(19,NULL,'Closed','SNAP/BAU','4G','External','OOS','High UMP memory Alarms and Reboots for high capacity sites in LTE 21D','Observed reboots on sites with high traffic after critical UMP memory alarms observed','ENDC users are taking up 2.2X more memory than LTE users. Due to this the ECCB memory is getting depleted quicker for high capacity sites leading to critical UMP memory alarms and reboots','Site is OOS for 5 minutes','Alarm: Check critical UMP memory alarm',NULL,'Implement HQ recommended 21D settings for high capacity sites','LTE 22A'),(20,'NA','Open','SNAP/BAU','C-Band/DSS','External','Retainability','High ENDC Drop when SgNB addtions are attempted from Nokia anchor >6miles','High % ENDC Drops due to the pegging of the cause code [0x101A]CauseInternalRandomAccessProblem','Due to PCI confusion(far anchor) Nokia anchor forwards the SgNB addition to wrong SgNB','High % ENDC DROP on the offender vDU','RACH MSG1=(RachPreambleAPerBeam+RachPreambleACFRAPerBeam)\nRACH MSG3=(NumMSG3PerBeam+NumMSG3CFRAPerBeam)\n(RACH MSG1/[0x101A]CauseInternalRandomAccessProblem)<10','Check there are more RandomAccess problems reported than the actual MSG1 detected\ncheck the anchor-vDU relation causing this drop and calculate the distance\nif distance is greater than 6miles, it falls under far anchor and this NBR relation need to be black listed','Reach out to VZW and black list the far anchor neighour relation','Operational Issue'),(21,'NA','Open','SNAP/BAU','C-Band','External','Retainability','100% ENDC Drop due to missing PTP clock sync','100 % ENDC Drops due to the pegging of the cause code [0x101A]CauseInternalRandomAccessProblem','Both vDU and MMU should be receiving the clock and should be in sync','100% ENDC DROP on the offender vDU','RACH MSG1=(RachPreambleAPerBeam+RachPreambleACFRAPerBeam)\nRACH MSG3=(NumMSG3PerBeam+NumMSG3CFRAPerBeam)\nRACH MSG1 =0  and RACH MSG3=0 along with CU-CSL 0x101A, CauseInternalRandomAccessProblem being pegged, on all the 3 sectors','check the PTP clock sync at both vDU and MMU\nChecking Method:\nvsmuser@adpf13291523020-dmp0-76c595d464-f2f58 21:33:19>show managed-element hardware-management o-ran-radio-unit o-ran-radio-unit-info sync o-ran-sync sync\nmanaged-element hardware-management o-ran-radio-unit o-ran-radio-unit-info 0\nsync o-ran-sync sync sync-capability sync-t-tsc -\nsync o-ran-sync sync sync-status sync-state LOCKED\nITEM \nAbove sync state should be in locked state.','Create external ticket and reach out to VZW NA team to recover the clock sync','Operational Issue'),(22,NULL,'Closed','SNAP/BAU','mmWave','External','Data Stall','Data stalls seen at the UE when UE tries to move from CP to DFTs OFDM (Lower MCS)','Due to SW issue, the gNB does not provide UL grants under certain conditions','The gNB does not provide UL grant for short packets meeting the criteria:\n(RB= min 8RB, Waveform = DFT OFDM , MCS ~= Transition','Data Stalls seen at UE','User experience',NULL,'Disable UL Waveform Adaptation','AU 21D'),(23,'vDU 22A','Open','SNAP/BAU','C-Band/DSS','External','Retainability & Accessibility','100% ENDC Access Failure and ENDC drop','100% ENDC Access Failure rate and ENDC drop is observed after vDU initialization/SW Upgrade','During vDU initialization, F1 IP Address is not configured due to missing synchronization between Configuration Management(CM) block and DFCB block','100% Access Failures and ENDC Drop','[0xB005]CauseInternalMDSSendFail >0','Automatic Recovery script is in progress Check [0xB005]CauseInternalMDSSendFail >0','Cell lock/unlock to be performed on the offender vDU','vDU 22CP3'),(24,'vDU 22A','Open','SNAP/BAU','C-Band(64T64R)','External','Retainability','100% ENDC Drop due to wrong eAxc_ID configuration in MMU on 22A P3 LS6 vDU','100 % ENDC Drops due to the pegging of the cause code [0x101A]CauseInternalRandomAccessProblem','During vDU initialization/cell setup procedure, M-plane configuration message processed by Radio Configuration Module(RCM) is lost and invalid configuration was made to eAxC_ID leading to Rach Messages(MSG3) not getting decoded by vDU.','100% ENDC DROP on the offender vDU','RACH MSG1=(RachPreambleAPerBeam+RachPreambleACFRAPerBeam)\nRACH MSG3=(NumMSG3PerBeam+NumMSG3CFRAPerBeam)\nRACH MSG1 is high and RACH MSG3=0 along with CU-CSL 0x101A, CauseInternalRandomAccessProblem being pegged','Automatic Recovery script is in progress\nLogin in to MMU Ushell and check Abnormal register config\nNormal Config:\nNormal FPGA EAXCID register value:\nUShell >md 0xa980e2c0 NOTE: \n0xa980e2c0: 0000 0000 0001 0000 0002 0000 0003 0000  0xa980e2d0: 0004 0000 0005 0000 0006 0000 0007 0000  0xa980e2e0: 0008 0000 0009 0000 000a 0000 000b 0000  0xa980e2f0: 000c 0000 000d 0000 000e 0000 000f 0000 \nAbnormal Config Example:\nAbnormal FPGA EAXCID register value:\nUShell >md 0xa980e2c0 \n0xa980e2c0: 0000 0000 0001 0000 0002 0000 0003 0000 0xa980e2d0: 0004 0000 0005 0000 0006 0000 0007 0000 0xa980e2e0: 0008 0000 0009 0000 000a 0000 008b 0000 0xa980e2f0: 008c 0000 008d 0000 008e 0000 008f 0000','MMU reset to recover the wrong configuration','vDU 22CP3'),(25,'vDU 22A','Open','SNAP/BAU','C-Band(64T64R)','Internal','Retainability','100% ENDC Drop due to invalid packet length in MMU on 22A P3 LS6 vDU','100 % ENDC Drops due to the pegging of the cause code [0x101A]CauseInternalRandomAccessProblem','In rare cases, the UL control plane message is received out of synchronization window in MMU\nIt causes reading invalid length of packet from MMU buffer, MMU sends MSG3 packet to vDU with invalid packet length\nvDU fails to process the UL (MSG3)','100% ENDC DROP on the offender vDU','RACH MSG1=(RachPreambleAPerBeam+RachPreambleACFRAPerBeam)\nRACH MSG3=(NumMSG3PerBeam+NumMSG3CFRAPerBeam)\nRACH MSG1 is high and RACH MSG3=0 along with CU-CSL 0x101A, CauseInternalRandomAccessProblem being pegged','go to dpp pod -> pkg/bin/ -> .nphycli -> put “oran show errcnt” -> wait 10 seconds (During Rach fail happens)  -> put “oran show errcnt”\nCheck increase in 53, packet parsing error count to confirm this issue\nDevice ] ErrCnt\n[ id: stats name:thread] cnt : first time - last time: last value\n[ 11: 11_ota_source_main:+80us:0] 5197 : 1357366971.380778904 - 1357486735.946576494 : 85423 719\n[ 12: 12_ota_source_main:+60us:0] 12 : 1357366971.384577913 - 1357486735.946581738 : 63881 1725\n[ 13: 13_ota_source_main:+40us:0] 14 : 1357366971.384581268 - 1357486735.946586154 : 41511 2676\n[ 14: 14_ota_source_main:+20us:0] 67590 : 1357366971.384582911 - 1357615338.193112409 : 23123 31581\n[ 15: 15_ota_source_main:+10us:0] 195427 : 1357366971.384584748 - 1357615338.193113955 : 15741 1546\n[ 53: 53_parse_upul:x_payl:0] 53518659 : 1357366992.727101940 - 1357615338.997612246 : 4552 14 4556 4566 <-------------\n[ 53: 53_parse_upul:x_payl:1] 1703874 : 1357366992.727111977 - 1357615338.997605827 : 4552 14 4556 4566 <-------------\n[ 53: 53_parse_upul:x_payl:2] 14022 : 1357366992.727111977 - 1357615332.687607588 : 4552 14 4560 4566\n[ 53: 53_parse_upul:x_payl:3] 3 : 1357374781.937607376 - 1357482776.187102322 : 4560 14 4548 4574','MMU reset to recover the wrong configuration','vDU 22CP3'),(26,'vDU 22A','Open','SNAP/BAU','C-Band/DSS','Internal','Retainability','100% ENDC Drop due to nPHY thread hang','100 % ENDC Drops due to the pegging of the cause code [0x101A]CauseInternalRandomAccessProblem','At L1 nphy S/W modules for parallel processing, CPU core was not assigned properly. \nThere was a problem in task management module of 22A L1 nphy.\nIf the number of task and cores generated simultaneously does not match, the task management module could be blocked.','100% ENDC DROP on the offender vDU','RACH MSG1=(RachPreambleAPerBeam+RachPreambleACFRAPerBeam)\nRACH MSG3=(NumMSG3PerBeam+NumMSG3CFRAPerBeam)\nRACH MSG1 =0 and RACH MSG3=0 along with CU-CSL 0x101A, CauseInternalRandomAccessProblem being pegged','1.go to dpp pod -> /var/log/subsystem/phy -> and check nphy_error_log.txt.* files\nBelow log is continously printed in the error logs\nCorePoolRunner~:0202 I/CONTROL_COREPOOLRUNNER: Not enough memory for allocation of schedules. Already created 255 (CorePool1). This is highly liked caused by cpu issue\n2. go to dpp pod\n ps -ef | grep nphy\nroot 30828 1 99 Feb03 pts/0 17-14:03:10 /usr/local/bin/nphy.xcg ...\npstack 30828 >> pstack_dump.txt\n Check  Nr::TaskPipelineExecutor::waitTask()','Restart nPHY block to recover the site','vDU 22C'),(27,'NA','Open','SNAP/BAU','C-Band/DSS','Internal','Retainability','100% ENDC Drop due to thermal issue at the vDU','100 % ENDC Drops due to the pegging of the cause code [0x101A]CauseInternalRandomAccessProblem','Due to improper maintenance of cooling system at the vDU,the CPU went to high temperature and CPU clock is slowed down because of this high temeperature.This slower clock speed leads to delayed processing of MSG#1,2,3 at th L1 and L2 blocks of the DPP pod, which in turn leads to 100% msg1 and msg3 failures.','100% ENDC DROP on the offender vDU','RACH MSG1=(RachPreambleAPerBeam+RachPreambleACFRAPerBeam)\nRACH MSG3=(NumMSG3PerBeam+NumMSG3CFRAPerBeam)\nRACH MSG1 =0 and RACH MSG3=0 along with CU-CSL 0x101A, CauseInternalRandomAccessProblem being pegged','Check the CPU clock for the abnormal vDU and compare with normal case\nAbnormal case clock < Normal case,\nExample:\nNormal Case: 2499.938 Mhz\nAbnormal Case:799.987 Mhz','Restart the vDU to recover the CPU.But environment need to be changed by talking to VZW.otherwise same issue re-occurs periodically','Operational Issue'),(28,'vDU 22A','Open','SNAP/BAU','C-Band(64T64R)','External','Retainability','100% ENDC Drop due to Cable Swap between different sectors of vDU and MMU.','100 % ENDC Drops due to the pegging of the cause code [0x101A]CauseInternalRandomAccessProblem','DPP PORT==> ORU PORT\nAlpha DPP Port (0,3)=> ORU Port(0)\nAlpha DPP Port (1,4)=> ORU Port(1)\nAlpha DPP Port (2,5)=> ORU Port(2)\nVDU POD & NIC Interface mapping for  C-Band MMU\nRMP fh0, DPP fh0 : ens1f1 ↔ Alpha MMU L0\n DPP fh3 : ens2f1 ↔ Alpha MMU L1  \nRMP fh1, DPP fh1 : ens1f2 ↔ Beta MMU L0 \nDPP fh4 : ens2f2 ↔ Beta MMU L1  \nRMP fh2, DPP fh2 : ens1f3 ↔ Gamma MMU L0 \nDPP fh5 : ens2f3 ↔ Gamma MMU L1\nWhen these cables are connected wrongly, this leads to MSG3 decoding fails in the sectors where the cables are connected wrongly.','100% ENDC DROP on the offender vDU','RACH MSG1=(RachPreambleAPerBeam+RachPreambleACFRAPerBeam)\nRACH MSG3=(NumMSG3PerBeam+NumMSG3CFRAPerBeam)\nRACH MSG1 high  and RACH MSG3=0 along with CU-CSL 0x101A, CauseInternalRandomAccessProblem being pegged','Login to dmp pod and check loop back result\n[root@adpf13191033330-dmp0-66dd5484cf-vgd4z /]# nrconfd_cli -u vsmuser\nWelcome to the ConfD CLI\nvsmuser@adpf13191033330-dmp0-66dd5484cf-vgd4z 20:04:46>show table managed-element hardware-management o-ran-radio-unit o-ran-radio-unit-info cuplane-info  \nO                                                                                                 NR                                     \nRAN   CUPLANE                        CONNECTED  CONNECTED  CONNECTED                              SUPPORT                                \nRU    CONNECT  CONNECTED  CONNECTED  POD PORT   RU PORT    FSU PORT   VLAN  PROCESSING  LOOPBACK  CELL                   LOOPBACK  FPGA  \nID    TYPE     POD TYPE   POD ID     ID         ID         ID         ID    ELEMENT     RESULT    NUMBER   NAME          RESULT    ID    \n-----------------------------------------------------------------------------------------------------------------------------------------\n0     -        dpp        0          0          0          -          950   -           -         [ 0 ]    re_0_0_0_950  pass      -     \n               dpp        0          3          1          -          950   -           -         [ 0 ]    re_0_3_1_950  pass      -     \n1     -        dpp        0          1          0          -          950   -           -         [ 1 ]    re_0_1_0_950  pass      -     \n               dpp        0          4          1          -          950   -           -         [ 1 ]    re_0_4_1_950  fail     -     \n2     -        dpp        0          2          0          -          950   -           -         [ 2 ]    re_0_2_0_950  pass      -     \n               dpp        0          5          1          -          950   -           -         [ 2 ]    re_0_5_1_950  fail      -     ','Create external ticket and reach out to VZW NA team to correct the cable swap','Operational Issue'),(29,'vDU 22A','Open','SNAP/BAU','C-Band(64T64R)','External','Retainability','100% ENDC Drop due to various vDU-MMU interface alarms','100 % ENDC Drops due to the pegging of the cause code [0x101A]CauseInternalRandomAccessProblem','Due to the following reasons various vDU-MMU interface alarms are generated:\n1. SFPs connected to vDU and MMU become faulty\n2. CPRI cables are connected to wrong ports at MMU side\n3. Ethernet interfaces that connect MMU and vDU are down','100% ENDC DROP on the offender vDU','RACH MSG1=(RachPreambleAPerBeam+RachPreambleACFRAPerBeam)\nRACH MSG3=(NumMSG3PerBeam+NumMSG3CFRAPerBeam)\nRACH MSG1 high  and RACH MSG3=0 along with CU-CSL 0x101A, CauseInternalRandomAccessProblem being pegged','Check the vDU and MMU-Interface alarms\nSome of the alarms include:\n1. dpp port-down \n2. Digital Input low (DIL)\n3. Oran-interface fault','Create external ticket and reach out to VZW NA team to recover from the alarms','Operational Issue'),(30,'vDU 22A','Open','SNAP/BAU','C-Band(8T8R)','External','Retainability','100% ENDC Drop due to wrong firmware subtype','100 % ENDC Drops due to the pegging of the cause code [0x101A]CauseInternalRandomAccessProblem','Post 22A all vDU should be on the following firmware versions:\n8T8R: Subtype1\n4T4R: Subtype2\nIn some cases, during upgrade the RRH firmware is not correctly updated leading to wrong signal calibration and MSG3 decoding failure','100% ENDC DROP on the offender vDU','RACH MSG1=(RachPreambleAPerBeam+RachPreambleACFRAPerBeam)\nRACH MSG3=(NumMSG3PerBeam+NumMSG3CFRAPerBeam)\nRACH MSG1 high  and RACH MSG3=0 along with CU-CSL 0x101A, CauseInternalRandomAccessProblem being pegged','[HNRTNYCRLSM-MS03:/home/lsm] mmu_fw.sh 13693533746 \n----------------------------------------------------------------------------------------------------------------------------------------\nvDU ID: 13693533746\n----------------------------------------------------------------------------------------------------------------------------------------\nRU                                              PRODUCT     VENDOR  BUILD  BUILD  BUILD\nID    NAME  STATUS  ACTIVE  RUNNING  ACCESS     CODE        CODE    ID     NAME   VERSION      NAME   VERSION    PATH     INTEGRITY\n----------------------------------------------------------------------------------------------------------------------------------------\n0     ss_0  VALID   false   false    READ_ONLY  RT8808-77A  SS      1      subtype_1  1.0.1715645  .inits 22.A.0.01  pkg/bin     OK\n      ss_1  VALID   false   false    READ_WRITE RT8808-77A  SS      1      subtype_0  1.0.5172534  .inits 22.A.0.01  pkg/bin     OK\n      ss_2  VALID   true    true     READ_WRITE RT8808-77A  SS      1      subtype_1  1.0.5172515  .inits 22.A.0.01  pkg/bin     OK\n1     ss_0  VALID   false   false    READ_ONLY  RT8808-77A  SS      1      subtype_1  1.0.1715645  .inits 22.A.0.01  pkg/bin     OK\n      ss_1  VALID   false   false    READ_WRITE RT8808-77A  SS      1      subtype_0  1.0.5172534  .inits 22.A.0.01  pkg/bin     OK\n      ss_2  VALID   true    true     READ_WRITE RT8808-77A  SS      1      subtype_1  1.0.5172515  .inits 22.A.0.01  pkg/bin     OK\n2     ss_0  VALID   false   false    READ_ONLY  RT8808-77A  SS      1      subtype_1  1.0.1715645  .inits 22.A.0.01  pkg/bin     OK\n      ss_1  VALID   false   false    READ_WRITE RT8808-77A  SS      1      subtype_0  1.0.5172534  .inits 22.A.0.01  pkg/bin     OK\n      ss_2  VALID   true    true     READ_WRITE RT8808-77A  SS      1      subtype_1  1.0.5172515  .inits 22.A.0.01  pkg/bin     OK\n---------------------------------------------------------------------------------------------------------------------------------------','Create external ticket and reach out to VZW NA team to recover from the alarms','Operational Issue'),(31,'vDU 22A','Open','SNAP/BAU','DSS/Cband','External','Retainability','High ENDC Drop due to Intra-SgNB handover failures','100 % ENDC Drops due to the pegging of the cause code CauseF1ApMiscUnspecifiedFailure','After SCG Faiure when Intra-SgNB handover is triggerred immediately, MAC Scheduler rejects the UE Context Setup as it cannot allocate dedicated preamble','HIGH ENDC DROP on the offender vDU','CU CSL [0x2304]CauseF1apMiscUnspecifiedFailure, is pegged high','Check for  CU CSL [0x2304]CauseF1apMiscUnspecifiedFailure pegging high','Work-Around not available, fix is part of vDU 22C','vDU 22C'),(32,'AU/IAU 22A','Open','SNAP/BAU','mmWave','External','Accessibility','High FR2 Accessibility failure rate to S23 issue on AU/IAU with 4 contiguous carriers','FR2 accessibility degrades when S23 tries to access the AU/IAU with EndcAddfailCpfail and from enb side the fail is ENDC_AddFail_RRE','Due to UL permutation IAU/AU send band combinations to the UE which are not supported and UE responds back with RRE','High FR2 Access failures on AU/IAU','EndcAddfailCpfail on AU side and ENDC_AddFail_RRE on enb side.','Check for AU/IAU with 4 contiguous carriers.','Blacklist band combinations that cause the issue on AU/IAU','AU-22CP2, IAU-23A'),(33,'NA','Open','SNAP/BAU','C-Band/DSS/FR2','External','Accessibility & Retainability','TEST_CA Req Band and ENDC Band Config','Additional/missing NR Band configuration in CA Req Freq Band and mismatch between CA Req Freq Band and ENDC Band config','Due to additonal NR Band in CA Req Band config - eNB MRDC table getting filled and eNB not sending correct band combo to vDU. \nDue to mstmatch between CA Req Band config and ENDC Band config - eNB does not include the ex. n77 band combos whiile sending CBand sgNB Addition Req.','high access Fails due to DU Prep fail cause','High EndcAddPrepFail_DuFail',NULL,'Add missing NR band or remove additional NR band in CA Req Band config and match the band config between CA Req Band config and ENDC band config','LTE 22C for missing/addiitional NR band.\nOpen issue for mismatch between CA Req Band and ENDC Band config');
/*!40000 ALTER TABLE `known_knowledge_base_backup` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `scripts`
--

DROP TABLE IF EXISTS `scripts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `scripts` (
  `issue_id` int NOT NULL,
  `SW` varchar(20) DEFAULT NULL,
  `Technology` varchar(50) DEFAULT NULL,
  `Status` varchar(20) NOT NULL,
  `action_type` varchar(50) DEFAULT NULL,
  `script_name` varchar(500) NOT NULL,
  `Script_owner` varchar(100) NOT NULL,
  `Script_location` varchar(50) DEFAULT NULL,
  `server_Login` varchar(50) DEFAULT NULL,
  `server_password` varchar(100) DEFAULT NULL,
  `Server_IP` varchar(20) DEFAULT NULL,
  `Sequence_num` int NOT NULL,
  `Task_id` int NOT NULL,
  `script_path` varchar(500) DEFAULT NULL,
  `args` varchar(500) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `scripts`
--

LOCK TABLES `scripts` WRITE;
/*!40000 ALTER TABLE `scripts` DISABLE KEYS */;
INSERT INTO `scripts` VALUES (33,'NA',NULL,'Open','RUN SCRIPT','CLI.pl','Praseeda siddha','REMOTE','toolsuser','58BBE35153948ECB4EE2DE0339E1CA61','10.100.1.79',1,33,'/opt/vz_raw_data/Scripts/TEST_iFAST/CmdExecuter','/opt/vz_raw_data/Scripts/TEST_iFAST/CmdExecuter/Conf/ifast.conf'),(34,'21B',NULL,'Open','RUN SCRIPT','gNodeB_PCI_Conflict.py','Shivani','NTPC','toolsuser','58BBE35153948ECB4EE2DE0339E1CA61','10.100.1.241',1,34,'/opt/vz_raw_data/Scripts/TEST_iFAST/CBAND_DSS','');
/*!40000 ALTER TABLE `scripts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `scripts_bkup`
--

DROP TABLE IF EXISTS `scripts_bkup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `scripts_bkup` (
  `issue_id` int NOT NULL,
  `SW` varchar(20) DEFAULT NULL,
  `Technology` varchar(50) DEFAULT NULL,
  `Status` varchar(20) NOT NULL,
  `action_type` varchar(50) DEFAULT NULL,
  `Script_Name` varchar(20) NOT NULL,
  `Script_owner` varchar(20) DEFAULT NULL,
  `Script_location` varchar(50) DEFAULT NULL,
  `server_Login` varchar(50) DEFAULT NULL,
  `server_password` varchar(100) DEFAULT NULL,
  `Server_IP` varchar(20) DEFAULT NULL,
  `Sequence_num` int NOT NULL,
  `Task_id` int NOT NULL,
  `script_path` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`issue_id`,`Task_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `scripts_bkup`
--

LOCK TABLES `scripts_bkup` WRITE;
/*!40000 ALTER TABLE `scripts_bkup` DISABLE KEYS */;
INSERT INTO `scripts_bkup` VALUES (33,'NA',NULL,'Open','RUN SCRIPT','hello.sh','PraseedaSv','NTPC','toolsuser','58BBE35153948ECB4EE2DE0339E1CA61','10.100.1.241',1,33,'/opt/vz_raw_data/Scripts/TEST_iFAST/');
/*!40000 ALTER TABLE `scripts_bkup` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `session`
--

DROP TABLE IF EXISTS `session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `session` (
  `session_id` bigint NOT NULL,
  `sequence_id` int NOT NULL,
  `action_type` varchar(100) DEFAULT NULL,
  `task_id` int DEFAULT NULL,
  `username` varchar(45) DEFAULT NULL,
  `timestamp` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `session`
--

LOCK TABLES `session` WRITE;
/*!40000 ALTER TABLE `session` DISABLE KEYS */;
INSERT INTO `session` VALUES (-5114766734850,1,'RUN SCRIPT',33,'admin','2023-09-18 04:26:00'),(-5114766734850,1,'RUN SCRIPT',33,'admin','2023-09-18 04:29:37'),(-5114766734850,1,'RUN SCRIPT',33,'admin','2023-09-18 04:39:17'),(3234639556298,3,'GREP',33,'admin','2023-09-20 00:07:26'),(3234639556298,3,'GREP',33,'admin','2023-09-20 00:46:10'),(3234639556298,3,'GREP',33,'admin','2023-09-20 00:49:00'),(1166758149545,1,'RUN SCRIPT',34,'admin','2023-09-22 15:15:44'),(1166758149545,1,'RUN SCRIPT',34,'admin','2023-09-22 15:20:20'),(3234639556298,3,'GREP',33,'admin','2023-09-27 20:30:00'),(-1755771057654,2,'GET FILE',33,'admin','2023-10-03 02:59:05'),(3234639556298,3,'GREP',33,'admin','2023-10-03 03:03:46'),(-5114766734850,1,'RUN SCRIPT',33,'admin','2023-10-03 19:38:48'),(-5114766734850,1,'RUN SCRIPT',33,'admin','2023-10-03 19:57:06'),(-5114766734850,1,'RUN SCRIPT',33,'admin','2023-10-03 20:00:00'),(-5114766734850,1,'RUN SCRIPT',33,'admin','2023-10-03 20:05:31'),(-5114766734850,1,'RUN SCRIPT',33,'admin','2023-10-03 20:07:43'),(-5114766734850,1,'RUN SCRIPT',33,'admin','2023-10-04 07:02:44'),(-5114766734850,1,'RUN SCRIPT',33,'admin','2023-10-04 09:08:12'),(-5114766734850,1,'RUN SCRIPT',33,'admin','2023-10-04 11:59:24'),(-5114766734850,1,'RUN SCRIPT',33,'admin','2023-10-04 12:01:53'),(-1755771057654,2,'GET FILE',33,'admin','2023-10-04 12:21:14'),(-1755771057654,2,'GET FILE',33,'admin','2023-10-04 12:29:22'),(3234639556298,3,'GREP',33,'admin','2023-10-04 12:30:41'),(-5114766734850,1,'RUN SCRIPT',33,'admin','2023-10-04 12:45:14'),(3234639556298,3,'GREP',33,'admin','2023-10-04 13:41:14'),(-5114766734850,1,'RUN SCRIPT',33,'admin','2023-10-05 05:37:13'),(-1755771057654,2,'GET FILE',33,'admin','2023-10-05 06:30:42'),(-1755771057654,2,'GET FILE',33,'admin','2023-10-05 06:34:53'),(3234639556298,3,'GREP',33,'admin','2023-10-05 06:39:41'),(-5114766734850,1,'RUN SCRIPT',33,'admin','2023-10-05 10:47:19'),(-5114766734850,1,'RUN SCRIPT',33,'admin','2023-10-05 10:49:24'),(-1755771057654,2,'GET FILE',33,'admin','2023-10-05 10:50:29'),(3234639556298,3,'GREP',33,'admin','2023-10-05 10:50:43'),(-5114766734850,1,'RUN SCRIPT',33,'admin','2023-10-05 11:14:00'),(-5114766734850,1,'RUN SCRIPT',33,'admin','2023-10-05 11:12:14'),(-1755771057654,2,'GET FILE',33,'admin','2023-10-05 11:30:07'),(3234639556298,3,'GREP',33,'admin','2023-10-05 11:31:05');
/*!40000 ALTER TABLE `session` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `session_details`
--

DROP TABLE IF EXISTS `session_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `session_details` (
  `session_id` bigint NOT NULL,
  `sequence_id` int NOT NULL,
  `action_type` varchar(100) DEFAULT NULL,
  `task_id` int DEFAULT NULL,
  `username` varchar(45) DEFAULT NULL,
  `timestamp` datetime DEFAULT NULL,
  `log_path` varchar(200) DEFAULT NULL,
  `log_file_name` varchar(200) DEFAULT NULL,
  `arguments` varchar(250) DEFAULT NULL,
  `server_ip` varchar(45) DEFAULT NULL,
  `server_id` varchar(45) DEFAULT NULL,
  `script_path` varchar(250) DEFAULT NULL,
  `script_name` varchar(200) DEFAULT NULL,
  `copy_file_name` varchar(200) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `session_details`
--

LOCK TABLES `session_details` WRITE;
/*!40000 ALTER TABLE `session_details` DISABLE KEYS */;
INSERT INTO `session_details` VALUES (-5114766734850,1,'RUN SCRIPT',33,'admin','2023-09-18 04:29:37','/Logs/33_1/RUN_SCRIPT','CLI_2023_09_18_042937.txt','/opt/vz_raw_data/Scripts/TEST_iFAST/CmdExecuter/Conf/ifast.conf','10.100.1.79','toolsuser','/opt/vz_raw_data/Scripts/TEST_iFAST/CmdExecuter','CLI.pl',''),(-5114766734850,1,'RUN SCRIPT',33,'admin','2023-09-18 04:39:17','/Logs/33_1/RUN_SCRIPT','CLI_2023_09_18_043917.txt','/opt/vz_raw_data/Scripts/TEST_iFAST/CmdExecuter/Conf/ifast.conf','10.100.1.79','toolsuser','/opt/vz_raw_data/Scripts/TEST_iFAST/CmdExecuter','CLI.pl',''),(3234639556298,3,'GREP',33,'admin','2023-09-20 00:07:26','/Logs/33_3/grep','grep_CmdExecuter_2023_09_20_000726.txt','curl','','','','','CmdExecuter.log'),(3234639556298,3,'GREP',33,'admin','2023-09-20 00:46:10','/Logs/33_3/grep','grep_CmdExecuter_2023_09_20_004610.txt','curl','','','','','CmdExecuter.log'),(3234639556298,3,'GREP',33,'admin','2023-09-20 00:49:00','/Logs/33_3/grep','grep_CmdExecuter_2023_09_20_004900.txt','curl','','','','','CmdExecuter.log'),(1166758149545,1,'RUN SCRIPT',34,'admin','2023-09-22 15:15:44','/Logs/34_1/RUN_SCRIPT','gNodeB_PCI_Conflict_2023_09_22_151544.txt','','10.100.1.241','toolsuser','/opt/vz_raw_data/Scripts/TEST_iFAST/CBAND_DSS','gNodeB_PCI_Conflict.py',''),(1166758149545,1,'RUN SCRIPT',34,'admin','2023-09-22 15:20:20','/Logs/34_1/RUN_SCRIPT','gNodeB_PCI_Conflict_2023_09_22_152020.txt','','10.100.1.241','toolsuser','/opt/vz_raw_data/Scripts/TEST_iFAST/CBAND_DSS','gNodeB_PCI_Conflict.py',''),(3234639556298,3,'GREP',33,'admin','2023-09-27 20:30:00','/Logs/33_3/grep','grep_CmdExecuter_091823_043842_29237_2023_09_27_203000.txt','curl','REMOTE_HOST','USERNAME','','','CmdExecuter_091823_043842_29237.log'),(-1755771057654,2,'GET FILE',33,'admin','2023-10-03 02:59:05','/Logs/33_2/get_file','grep_CmdExecuter_091823_043842_29237_2023_10_03_025905.txt',NULL,'10.100.1.241','toolsuser','','','CmdExecuter_091823_043842_29237.log'),(3234639556298,3,'GREP',33,'admin','2023-10-03 03:03:46','/Logs/33_3/grep','grep_CmdExecuter_091823_043842_29237_2023_10_03_030346.txt','curl','REMOTE_HOST','USERNAME','','','CmdExecuter_091823_043842_29237.log'),(-5114766734850,1,'RUN SCRIPT',33,'admin','2023-10-03 19:38:48','/Logs/33_1/RUN_SCRIPT','CLI_2023_10_03_193848.txt','/opt/vz_raw_data/Scripts/TEST_iFAST/CmdExecuter/Conf/ifast.conf','10.100.1.79','toolsuser','/opt/vz_raw_data/Scripts/TEST_iFAST/CmdExecuter','CLI.pl',''),(-5114766734850,1,'RUN SCRIPT',33,'admin','2023-10-03 19:57:06','/Logs/33_1/RUN_SCRIPT','CLI_2023_10_03_195706.txt','/opt/vz_raw_data/Scripts/TEST_iFAST/CmdExecuter/Conf/ifast.conf','10.100.1.79','toolsuser','/opt/vz_raw_data/Scripts/TEST_iFAST/CmdExecuter','CLI.pl',''),(-5114766734850,1,'RUN SCRIPT',33,'admin','2023-10-03 20:00:00','/Logs/33_1/RUN_SCRIPT','CLI_2023_10_03_200000.txt','/opt/vz_raw_data/Scripts/TEST_iFAST/CmdExecuter/Conf/ifast.conf','10.100.1.79','toolsuser','/opt/vz_raw_data/Scripts/TEST_iFAST/CmdExecuter','CLI.pl',''),(-5114766734850,1,'RUN SCRIPT',33,'admin','2023-10-03 20:05:31','/Logs/33_1/RUN_SCRIPT','CLI_2023_10_03_200531.txt','/opt/vz_raw_data/Scripts/TEST_iFAST/CmdExecuter/Conf/ifast.conf','10.100.1.79','toolsuser','/opt/vz_raw_data/Scripts/TEST_iFAST/CmdExecuter','CLI.pl',''),(-5114766734850,1,'RUN SCRIPT',33,'admin','2023-10-03 20:07:43','/Logs/33_1/RUN_SCRIPT','CLI_2023_10_03_200743.txt','/opt/vz_raw_data/Scripts/TEST_iFAST/CmdExecuter/Conf/ifast.conf','10.100.1.79','toolsuser','/opt/vz_raw_data/Scripts/TEST_iFAST/CmdExecuter','CLI.pl',''),(-5114766734850,1,'RUN SCRIPT',33,'admin','2023-10-04 07:02:44','/Logs/33_1/RUN_SCRIPT','CLI_2023_10_04_070244.txt','/opt/vz_raw_data/Scripts/TEST_iFAST/CmdExecuter/Conf/ifast.conf','10.100.1.79','toolsuser','/opt/vz_raw_data/Scripts/TEST_iFAST/CmdExecuter','CLI.pl',''),(-5114766734850,1,'RUN SCRIPT',33,'admin','2023-10-04 09:08:12','/Logs/33_1/RUN_SCRIPT','CLI_2023_10_04_090812.txt','/opt/vz_raw_data/Scripts/TEST_iFAST/CmdExecuter/Conf/ifast.conf','10.100.1.79','toolsuser','/opt/vz_raw_data/Scripts/TEST_iFAST/CmdExecuter','CLI.pl',''),(-5114766734850,1,'RUN SCRIPT',33,'admin','2023-10-04 11:59:24','/Logs/33_1/RUN_SCRIPT','CLI_2023_10_04_115924.txt','/opt/vz_raw_data/Scripts/TEST_iFAST/CmdExecuter/Conf/ifast.conf','10.100.1.79','toolsuser','/opt/vz_raw_data/Scripts/TEST_iFAST/CmdExecuter','CLI.pl',''),(-5114766734850,1,'RUN SCRIPT',33,'admin','2023-10-04 12:01:53','/Logs/33_1/RUN_SCRIPT','CLI_2023_10_04_120153.txt','/opt/vz_raw_data/Scripts/TEST_iFAST/CmdExecuter/Conf/ifast.conf','10.100.1.79','toolsuser','/opt/vz_raw_data/Scripts/TEST_iFAST/CmdExecuter','CLI.pl',''),(-1755771057654,2,'GET FILE',33,'admin','2023-10-04 12:21:14','/Logs/33_2/get_file','grep_CmdExecuter_100423_120108_14621_2023_10_04_122114.txt',NULL,'10.100.1.241','toolsuser','','','CmdExecuter_100423_120108_14621.log'),(-1755771057654,2,'GET FILE',33,'admin','2023-10-04 12:29:22','/Logs/33_2/get_file','grep_CmdExecuter_100423_120108_14621_2023_10_04_122922.txt',NULL,'10.100.1.241','toolsuser','','','CmdExecuter_100423_120108_14621.log'),(3234639556298,3,'GREP',33,'admin','2023-10-04 12:30:41','/Logs/33_3/grep','grep_CmdExecuter_091823_043842_29237_2023_10_04_123041.txt','curl','10.100.1.241','toolsuser','','','CmdExecuter_091823_043842_29237.log'),(-5114766734850,1,'RUN SCRIPT',33,'admin','2023-10-04 12:45:14','/Logs/33_1/RUN_SCRIPT','CLI_2023_10_04_124514.txt','/opt/vz_raw_data/Scripts/TEST_iFAST/CmdExecuter/Conf/ifast.conf','10.100.1.79','toolsuser','/opt/vz_raw_data/Scripts/TEST_iFAST/CmdExecuter','CLI.pl',''),(3234639556298,3,'GREP',33,'admin','2023-10-04 13:41:14','/Logs/33_3/grep','grep_CmdExecuter_091823_043842_29237_2023_10_04_134114.txt','curl','10.100.1.241','toolsuser','','','CmdExecuter_091823_043842_29237.log'),(-5114766734850,1,'RUN SCRIPT',33,'admin','2023-10-05 05:37:13','/Logs/33_1/RUN_SCRIPT','CLI_2023_10_05_053713.txt','/opt/vz_raw_data/Scripts/TEST_iFAST/CmdExecuter/Conf/ifast.conf','10.100.1.79','toolsuser','/opt/vz_raw_data/Scripts/TEST_iFAST/CmdExecuter','CLI.pl',''),(-1755771057654,2,'GET FILE',33,'admin','2023-10-05 06:30:42','/Logs/33_2/get_file','grep_CmdExecuter_100523_053628_25854_2023_10_05_063042.txt',NULL,'10.100.1.241','toolsuser','','','CmdExecuter_100523_053628_25854.log'),(-1755771057654,2,'GET FILE',33,'admin','2023-10-05 06:34:53','/Logs/33_2/get_file','grep_CmdExecuter_100523_053628_25854_2023_10_05_063453.txt',NULL,'10.100.1.241','toolsuser','','','CmdExecuter_100523_053628_25854.log'),(3234639556298,3,'GREP',33,'admin','2023-10-05 06:39:41','/Logs/33_3/grep','grep_CmdExecuter_100523_053628_25854_2023_10_05_063941.txt','curl','10.100.1.241','toolsuser','','','CmdExecuter_100523_053628_25854.log'),(-5114766734850,1,'RUN SCRIPT',33,'admin','2023-10-05 10:47:19','/Logs/33_1/RUN_SCRIPT','CLI_2023_10_05_104719.txt','/opt/vz_raw_data/Scripts/TEST_iFAST/CmdExecuter/Conf/ifast.conf','10.100.1.79','toolsuser','/opt/vz_raw_data/Scripts/TEST_iFAST/CmdExecuter','CLI.pl',''),(-5114766734850,1,'RUN SCRIPT',33,'admin','2023-10-05 10:49:24','/Logs/33_1/RUN_SCRIPT','CLI_2023_10_05_104924.txt','/opt/vz_raw_data/Scripts/TEST_iFAST/CmdExecuter/Conf/ifast.conf','10.100.1.79','toolsuser','/opt/vz_raw_data/Scripts/TEST_iFAST/CmdExecuter','CLI.pl',''),(-1755771057654,2,'GET FILE',33,'admin','2023-10-05 10:50:29','/Logs/33_2/get_file','grep_CmdExecuter_100523_104838_16461_2023_10_05_105029.txt',NULL,'10.100.1.241','toolsuser','','','CmdExecuter_100523_104838_16461.log'),(3234639556298,3,'GREP',33,'admin','2023-10-05 10:50:43','/Logs/33_3/grep','grep_CmdExecuter_100523_104838_16461_2023_10_05_105043.txt','curl','10.100.1.241','toolsuser','','','CmdExecuter_100523_104838_16461.log'),(-5114766734850,1,'RUN SCRIPT',33,'admin','2023-10-05 11:14:00','/Logs/33_1/RUN_SCRIPT','CLI_2023_10_05_111400.txt','/opt/vz_raw_data/Scripts/TEST_iFAST/CmdExecuter/Conf/ifast.conf','10.100.1.79','toolsuser','/opt/vz_raw_data/Scripts/TEST_iFAST/CmdExecuter','CLI.pl',''),(-5114766734850,1,'RUN SCRIPT',33,'admin','2023-10-05 11:12:14','/Logs/33_1/RUN_SCRIPT','CLI_2023_10_05_111214.txt','/opt/vz_raw_data/Scripts/TEST_iFAST/CmdExecuter/Conf/ifast.conf','10.100.1.79','toolsuser','/opt/vz_raw_data/Scripts/TEST_iFAST/CmdExecuter','CLI.pl',''),(-1755771057654,2,'GET FILE',33,'admin','2023-10-05 11:30:07','/Logs/33_2/get_file','grep_CmdExecuter_100523_111315_6082_2023_10_05_113007.txt',NULL,'10.100.1.241','toolsuser','','','CmdExecuter_100523_111315_6082.log'),(3234639556298,3,'GREP',33,'admin','2023-10-05 11:31:05','/Logs/33_3/grep','grep_CmdExecuter_100523_111315_6082_2023_10_05_113105.txt','curl','10.100.1.241','toolsuser','','','CmdExecuter_100523_111315_6082.log');
/*!40000 ALTER TABLE `session_details` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `technology_known_knowledge`
--

DROP TABLE IF EXISTS `technology_known_knowledge`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `technology_known_knowledge` (
  `technology_id` int NOT NULL,
  `Technology` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `technology_known_knowledge`
--

LOCK TABLES `technology_known_knowledge` WRITE;
/*!40000 ALTER TABLE `technology_known_knowledge` DISABLE KEYS */;
INSERT INTO `technology_known_knowledge` VALUES (1,'UL Waveform Adaptation'),(2,'CAC'),(3,'CA Req Band and ENDC Band Config'),(4,'RLC IP'),(5,'MMU Low I/Q'),(6,'F1U DL Packet Loss'),(7,'Intra gNB HO Fail Rate'),(8,'Inter gNB HO Fail Rate'),(9,'High ENDC Drop Rate due to Sync Reconfig Fails'),(10,'High ENDC Drop Rate due to Sync Reconfig Fails'),(11,'High UL Initial & Residual BLER'),(12,'High ENDC Drop Rate due to DU RLC Max Retx'),(13,'High ENDC Drop Rate due to DU RLC Max Retx'),(14,'High NR CA addition failure rate'),(15,'Very high ENDC Drop Rate on n5/n2 cells'),(16,'High Reconfiguration Fail Rate'),(17,'High ERAB SF Rate (90%) due to high Buffer usage in LTE 21D'),(18,'CBRS TX Path shutdown issue in LTE 21D'),(19,'High UMP memory Alarms and Reboots for high capacity sites in LTE 21D'),(20,'High ENDC Drop when SgNB addtions are attempted from Nokia anchor >6miles'),(21,'100% ENDC Drop due to missing PTP clock sync'),(22,'Data stalls seen at the UE when UE tries to move from CP to DFTs OFDM (Lower MCS)'),(23,'100% ENDC Access Failure and ENDC drop'),(24,'100% ENDC Drop due to wrong eAxc_ID configuration in MMU on 22A P3 LS6 vDU'),(25,'100% ENDC Drop due to invalid packet length in MMU on 22A P3 LS6 vDU'),(26,'100% ENDC Drop due to nPHY thread hang'),(27,'100% ENDC Drop due to thermal issue at the vDU'),(28,'100% ENDC Drop due to Cable Swap between different sectors of vDU and MMU.'),(29,'100% ENDC Drop due to various vDU-MMU interface alarms'),(30,'100% ENDC Drop due to wrong firmware subtype'),(31,'High ENDC Drop due to Intra-SgNB handover failures'),(32,'High FR2 Accessibility failure rate to S23 issue on AU/IAU with 4 contiguous carriers');
/*!40000 ALTER TABLE `technology_known_knowledge` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `test1`
--

DROP TABLE IF EXISTS `test1`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `test1` (
  `test_id` int NOT NULL,
  `test_type` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`test_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `test1`
--

LOCK TABLES `test1` WRITE;
/*!40000 ALTER TABLE `test1` DISABLE KEYS */;
INSERT INTO `test1` VALUES (1,'run_scripts'),(2,'get_file');
/*!40000 ALTER TABLE `test1` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `test2`
--

DROP TABLE IF EXISTS `test2`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `test2` (
  `issue_id` int NOT NULL,
  `action_id` int NOT NULL,
  `test_id` int NOT NULL,
  `Issue_category` varchar(200) NOT NULL,
  `SW` varchar(20) DEFAULT NULL,
  `Technology` varchar(50) DEFAULT NULL,
  `Status` varchar(20) NOT NULL,
  `Script_Name` varchar(20) NOT NULL,
  `Script_owner` varchar(20) DEFAULT NULL,
  `Script_location` varchar(50) DEFAULT NULL,
  `server_Login` varchar(50) DEFAULT NULL,
  `server_password` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`issue_id`,`action_id`,`Script_Name`),
  KEY `test_id` (`test_id`),
  CONSTRAINT `test2_ibfk_1` FOREIGN KEY (`test_id`) REFERENCES `test1` (`test_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `test2`
--

LOCK TABLES `test2` WRITE;
/*!40000 ALTER TABLE `test2` DISABLE KEYS */;
/*!40000 ALTER TABLE `test2` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_information`
--

DROP TABLE IF EXISTS `user_information`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_information` (
  `id` int NOT NULL,
  `user_name` varchar(50) NOT NULL,
  `user_id` varchar(50) NOT NULL,
  `password` varchar(100) NOT NULL,
  `status` varchar(50) DEFAULT NULL,
  `team` varchar(50) DEFAULT NULL,
  `role` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`,`user_id`,`user_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_information`
--

LOCK TABLES `user_information` WRITE;
/*!40000 ALTER TABLE `user_information` DISABLE KEYS */;
INSERT INTO `user_information` VALUES (1,'admin','admin','6677A74994FA8211812B2189819D12CC','Active','STM','superadmin'),(2,'Praseeda','p.venkata','DE70B5F325AC1D24F3561B3F017E5D3D','Active','STM','user');
/*!40000 ALTER TABLE `user_information` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_login`
--

DROP TABLE IF EXISTS `user_login`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_login` (
  `even_date_time` timestamp NULL DEFAULT NULL,
  `event_type` varchar(100) NOT NULL,
  `user_id` varchar(50) NOT NULL,
  `description` varchar(500) NOT NULL,
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_login`
--

LOCK TABLES `user_login` WRITE;
/*!40000 ALTER TABLE `user_login` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_login` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'iFAST'
--

--
-- Final view structure for view `ENDC_issue_category_known`
--

/*!50001 DROP VIEW IF EXISTS `ENDC_issue_category_known`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`admin`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `ENDC_issue_category_known` AS select `known_knowledge_base`.`issue` AS `issue`,`known_knowledge_base`.`SW` AS `SW`,`known_knowledge_base`.`Status` AS `Status`,`known_knowledge_base`.`Area` AS `Area`,`known_knowledge_base`.`Technology` AS `Technology`,`known_knowledge_base`.`Visibility` AS `Visibility`,`known_knowledge_base`.`Major_KPI_Degradation` AS `Major_KPI_Degradation`,`known_knowledge_base`.`Issue_Category` AS `Issue_Category`,`known_knowledge_base`.`Description` AS `Description`,`known_knowledge_base`.`Root_Cause` AS `Root_Cause`,`known_knowledge_base`.`Impact` AS `Impact`,`known_knowledge_base`.`Detection_Methodology_OMs` AS `Detection_Methodology_OMs`,`known_knowledge_base`.`Detection_Methodology_Log_Script` AS `Detection_Methodology_Log_Script`,`known_knowledge_base`.`Interim_Solution_Workaround` AS `Interim_Solution_Workaround`,`known_knowledge_base`.`Permanent_Fix` AS `Permanent_Fix` from `known_knowledge_base` where (`known_knowledge_base`.`Issue_Category` like '%ENDC%') */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-01-10  3:43:45
