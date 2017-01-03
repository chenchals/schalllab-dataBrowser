--
-- Database: `schalllab`
--

-- --------------------------------------------------------

--
-- Table structure for table `study`
--

CREATE TABLE `study` (
  `study_id` int(10) UNSIGNED NOT NULL,
  `subject_id` int(10) UNSIGNED NOT NULL,
  `person_id` int(10) UNSIGNED DEFAULT NULL,
  `study_datafile` varchar(100) NOT NULL,
  `study_description` varchar(100) DEFAULT NULL,
  `study_date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Indexes for table `study`
--
ALTER TABLE `study`
  ADD PRIMARY KEY (`study_id`),
  ADD UNIQUE KEY `study_datafile` (`study_datafile`);

--
-- AUTO_INCREMENT for table `study`
--
ALTER TABLE `study`
  MODIFY `study_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;