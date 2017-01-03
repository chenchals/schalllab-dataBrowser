--
-- Database: `schalllab`
--

-- --------------------------------------------------------

--
-- Table structure for table `person`
--

CREATE TABLE `person` (
  `person_id` int(10) UNSIGNED NOT NULL,
  `person_initials` varchar(5) NOT NULL,
  `person_firstname` varchar(100) DEFAULT NULL,
  `person_lastname` varchar(100) DEFAULT NULL,
  `person_email` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Indexes for table `person`
--
ALTER TABLE `person`
  ADD PRIMARY KEY (`person_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `person`
--
ALTER TABLE `person`
  MODIFY `person_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- Dumping data for table `person`
--

--INSERT INTO `person` (`person_id`, `person_firstname`, `person_lastname`, `person_email`) VALUES
--(1, 'Rich', 'Hietz', 'richard.heitz@gmail.com'),


