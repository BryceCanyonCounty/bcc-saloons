CREATE TABLE IF NOT EXISTS `brewing` (
  `id` uuid NOT NULL,
  `propname` varchar(255) DEFAULT NULL,
  `x` double DEFAULT NULL,
  `y` double DEFAULT NULL,
  `z` double DEFAULT NULL,
  `h` double DEFAULT NULL,
  `isbrewing` int(11) DEFAULT NULL,
  `stage` int(11) DEFAULT NULL,
  `currentbrew` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;