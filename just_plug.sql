-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Oct 08, 2024 at 07:28 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `just_plug`
--

-- --------------------------------------------------------

--
-- Table structure for table `devices`
--

CREATE TABLE `devices` (
  `id` int(11) NOT NULL,
  `value_controller_id` int(11) NOT NULL,
  `device_name` varchar(25) NOT NULL,
  `current_value` int(255) NOT NULL,
  `device_status` tinyint(1) NOT NULL DEFAULT 0,
  `alert_status` tinyint(1) NOT NULL DEFAULT 0,
  `firmware_version` varchar(255) NOT NULL,
  `create_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `devices`
--

INSERT INTO `devices` (`id`, `value_controller_id`, `device_name`, `current_value`, `device_status`, `alert_status`, `firmware_version`, `create_at`) VALUES
(1, 0, 'test', 1000, 0, 0, '0.0.1', '2024-10-06 18:45:00'),
(2, 0, '1234567890123456789012345', 100, 0, 0, '0.0.1', '2024-10-06 16:42:23'),
(3, 0, 'Front Home', 3000, 1, 0, '0.0.1', '2024-10-06 18:45:11');

-- --------------------------------------------------------

--
-- Table structure for table `devices_details`
--

CREATE TABLE `devices_details` (
  `id` int(11) NOT NULL,
  `devices_id` int(11) NOT NULL,
  `channel_id` int(11) NOT NULL,
  `channel_status` tinyint(1) NOT NULL DEFAULT 0,
  `update_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `location` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `devices_details`
--

INSERT INTO `devices_details` (`id`, `devices_id`, `channel_id`, `channel_status`, `update_at`, `location`) VALUES
(0, 2, 1, 0, '2024-10-06 18:42:13', 'home');

-- --------------------------------------------------------

--
-- Table structure for table `devices_logs`
--

CREATE TABLE `devices_logs` (
  `id` int(11) NOT NULL,
  `devices_id` int(11) NOT NULL,
  `voltage_value` float NOT NULL,
  `current_value` float NOT NULL,
  `power_value` float NOT NULL,
  `energy_value` float NOT NULL,
  `frequency_value` float NOT NULL,
  `power_factor_value` float NOT NULL,
  `log_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `update_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `devices_logs`
--

INSERT INTO `devices_logs` (`id`, `devices_id`, `voltage_value`, `current_value`, `power_value`, `energy_value`, `frequency_value`, `power_factor_value`, `log_at`, `update_at`) VALUES
(2, 2, 0, 0, 0, 0, 0, 0, '2024-10-06 18:43:09', '2024-10-06 18:43:09');

-- --------------------------------------------------------

--
-- Table structure for table `devices_share`
--

CREATE TABLE `devices_share` (
  `id` int(11) NOT NULL,
  `users_id` int(11) NOT NULL,
  `devices_id` int(11) NOT NULL,
  `token` int(11) NOT NULL,
  `create_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(255) NOT NULL,
  `password` varchar(60) NOT NULL,
  `create_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `password`, `create_at`) VALUES
(1, 'admin', '$2b$12$I8UerezpfiBMeeiLbJdqB.SJGFnubY.pAYPXiLB/DyLvJN5R6mbbG', '2024-10-08 09:55:47'),
(4, 'test', '$2b$12$G9bHe5G4cFvi/EMJiBegkeGF42SHPtBwcUpmCIWbcAZ1DHWu1RYCS', '2024-10-08 10:06:33');

-- --------------------------------------------------------

--
-- Table structure for table `users_details`
--

CREATE TABLE `users_details` (
  `id` int(11) NOT NULL,
  `users_id` int(11) NOT NULL,
  `devices_id` int(11) DEFAULT NULL,
  `name` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `users_details`
--

INSERT INTO `users_details` (`id`, `users_id`, `devices_id`, `name`) VALUES
(1, 4, NULL, 'John Doe');

-- --------------------------------------------------------

--
-- Table structure for table `users_logs`
--

CREATE TABLE `users_logs` (
  `id` int(11) NOT NULL,
  `users_id` int(11) NOT NULL,
  `value` varchar(255) NOT NULL,
  `time_login` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `value_controller`
--

CREATE TABLE `value_controller` (
  `id` int(11) NOT NULL,
  `value_max` float NOT NULL,
  `value_min` float NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `value_controller`
--

INSERT INTO `value_controller` (`id`, `value_max`, `value_min`) VALUES
(1, 2200, 0);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `devices`
--
ALTER TABLE `devices`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `devices_logs`
--
ALTER TABLE `devices_logs`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `devices_share`
--
ALTER TABLE `devices_share`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users_details`
--
ALTER TABLE `users_details`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users_logs`
--
ALTER TABLE `users_logs`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `value_controller`
--
ALTER TABLE `value_controller`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `devices`
--
ALTER TABLE `devices`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `devices_logs`
--
ALTER TABLE `devices_logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `devices_share`
--
ALTER TABLE `devices_share`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `users_details`
--
ALTER TABLE `users_details`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `users_logs`
--
ALTER TABLE `users_logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `value_controller`
--
ALTER TABLE `value_controller`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `devices_details`
--
ALTER TABLE `devices_details`
  ADD CONSTRAINT `devices_details_ibfk_1` FOREIGN KEY (`devices_id`) REFERENCES `devices` (`id`);

--
-- Constraints for table `devices_logs`
--
ALTER TABLE `devices_logs`
  ADD CONSTRAINT `devices_logs_ibfk_1` FOREIGN KEY (`devices_id`) REFERENCES `devices` (`id`);

--
-- Constraints for table `users_details`
--
ALTER TABLE `users_details`
  ADD CONSTRAINT `users_details_ibfk_1` FOREIGN KEY (`users_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `users_logs`
--
ALTER TABLE `users_logs`
  ADD CONSTRAINT `users_logs_ibfk_1` FOREIGN KEY (`users_id`) REFERENCES `users` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
