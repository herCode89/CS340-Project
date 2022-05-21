-- phpMyAdmin SQL Dump
-- version 4.9.4
-- https://www.phpmyadmin.net/
--
-- Host: classmysql.engr.oregonstate.edu:3306
-- Generation Time: Mar 30, 2020 at 01:02 PM
-- Server version: 10.4.11-MariaDB-log
-- PHP Version: 7.4.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `persist_cs340_schutfoj`
--

-- --------------------------------------------------------

--
-- Table structure for table `COURSE`
--

CREATE TABLE `COURSE` (
  `Course_name` varchar(30) NOT NULL,
  `Course_number` varchar(8) NOT NULL,
  `Credit_hours` int(1) NOT NULL,
  `Department` char(4) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `COURSE`
--

INSERT INTO `COURSE` (`Course_name`, `Course_number`, `Credit_hours`, `Department`) VALUES
('Data Structures', 'CS261', 4, 'CS'),
('Web Dev', 'CS290', 4, 'CS'),
('Algorithms', 'CS325', 4, 'CS'),
('Database', 'CS340', 4, 'CS'),
('Discrete Math', 'MTH231', 4, 'MTH'),
('Differential Calculus', 'MTH251', 4, 'MTH');

-- --------------------------------------------------------

--
-- Table structure for table `GRADE_REPORT`
--

CREATE TABLE `GRADE_REPORT` (
  `Student_number` char(8) NOT NULL,
  `Section_identifier` int(11) NOT NULL,
  `Grade` varchar(2) NOT NULL DEFAULT 'A'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `GRADE_REPORT`
--

INSERT INTO `GRADE_REPORT` (`Student_number`, `Section_identifier`, `Grade`) VALUES
('111', 112, 'D'),
('111', 166, 'A'),
('111', 444, 'A'),
('111', 555, 'A-'),
('222', 213, 'A'),
('222', 222, 'A'),
('222', 300, 'A'),
('222', 444, 'B'),
('333', 213, 'C'),
('555', 112, 'B'),
('555', 555, 'A');

-- --------------------------------------------------------

--
-- Table structure for table `PREREQUISITE`
--

CREATE TABLE `PREREQUISITE` (
  `Course_number` varchar(8) NOT NULL,
  `Pre_number` varchar(8) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `PREREQUISITE`
--

INSERT INTO `PREREQUISITE` (`Course_number`, `Pre_number`) VALUES
('CS325', 'CS261'),
('CS325', 'MTH251'),
('CS340', 'CS290');

-- --------------------------------------------------------

--
-- Table structure for table `SECTION`
--

CREATE TABLE `SECTION` (
  `Section_id` int(11) NOT NULL,
  `Course_number` varchar(8) NOT NULL,
  `Semester` varchar(8) NOT NULL,
  `Year` int(4) NOT NULL,
  `Instructor` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `SECTION`
--

INSERT INTO `SECTION` (`Section_id`, `Course_number`, `Semester`, `Year`, `Instructor`) VALUES
(112, 'CS261', 'Fall', 2017, 'Smith'),
(166, 'MTH231', 'Fall', 2018, 'Lee'),
(213, 'MTH251', 'Spring', 2018, 'Lee'),
(222, 'CS290', 'Spring', 2018, 'Roberts'),
(300, 'CS261', 'Fall', 2018, 'Johnson'),
(444, 'CS261', 'Fall', 2018, 'Smith'),
(555, 'CS325', 'Spring', 2018, 'Jones');

-- --------------------------------------------------------

--
-- Table structure for table `STUDENT`
--

CREATE TABLE `STUDENT` (
  `Name` varchar(30) NOT NULL,
  `Student_number` char(8) NOT NULL,
  `Class` int(11) NOT NULL,
  `Major` char(4) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

--
-- Dumping data for table `STUDENT`
--

INSERT INTO `STUDENT` (`Name`, `Student_number`, `Class`, `Major`) VALUES
('Amy', '111', 3, 'CS'),
('Bob', '222', 3, 'MTH'),
('Dave', '333', 3, 'CS'),
('Chris', '555', 4, 'CS'),
('Steve', '789', 4, 'MTH');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `COURSE`
--
ALTER TABLE `COURSE`
  ADD PRIMARY KEY (`Course_number`);

--
-- Indexes for table `GRADE_REPORT`
--
ALTER TABLE `GRADE_REPORT`
  ADD PRIMARY KEY (`Student_number`,`Section_identifier`),
  ADD KEY `Section_identifier` (`Section_identifier`);

--
-- Indexes for table `PREREQUISITE`
--
ALTER TABLE `PREREQUISITE`
  ADD PRIMARY KEY (`Course_number`,`Pre_number`),
  ADD KEY `Pre_number` (`Pre_number`);

--
-- Indexes for table `SECTION`
--
ALTER TABLE `SECTION`
  ADD PRIMARY KEY (`Section_id`),
  ADD KEY `Course_number` (`Course_number`);

--
-- Indexes for table `STUDENT`
--
ALTER TABLE `STUDENT`
  ADD PRIMARY KEY (`Student_number`);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `GRADE_REPORT`
--
ALTER TABLE `GRADE_REPORT`
  ADD CONSTRAINT `GRADE_REPORT_ibfk_1` FOREIGN KEY (`Section_identifier`) REFERENCES `SECTION` (`Section_id`),
  ADD CONSTRAINT `GRADE_REPORT_ibfk_2` FOREIGN KEY (`Student_number`) REFERENCES `STUDENT` (`Student_number`);

--
-- Constraints for table `PREREQUISITE`
--
ALTER TABLE `PREREQUISITE`
  ADD CONSTRAINT `PREREQUISITE_ibfk_1` FOREIGN KEY (`Course_number`) REFERENCES `COURSE` (`Course_number`),
  ADD CONSTRAINT `PREREQUISITE_ibfk_2` FOREIGN KEY (`Pre_number`) REFERENCES `COURSE` (`Course_number`);

--
-- Constraints for table `SECTION`
--
ALTER TABLE `SECTION`
  ADD CONSTRAINT `SECTION_ibfk_1` FOREIGN KEY (`Course_number`) REFERENCES `COURSE` (`Course_number`) ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
--
-- 

