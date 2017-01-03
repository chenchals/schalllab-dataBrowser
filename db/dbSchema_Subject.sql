--
-- Database: `schalllab`
--

-- --------------------------------------------------------

--
-- Table structure for table `subject`
--

CREATE TABLE `subject` (
  `subject_id` int(10) UNSIGNED NOT NULL,
  `subject_species` varchar(100) DEFAULT NULL,
  `subject_name` varchar(50) DEFAULT NULL,
  `subject_name_abbr` varchar(50) DEFAULT NULL,
  `subject_data_dir` varchar(50) DEFAULT NULL,
  `subject_is_active` tinyint(1) DEFAULT NULL,
  `subject_dob` date DEFAULT NULL,
  `subject_acquisition_date` date DEFAULT NULL,
  `subject_dod` date DEFAULT NULL,
  `subject_gender` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `subject`
--

INSERT INTO `subject` (`subject_id`, `subject_species`, `subject_name`, `subject_name_abbr`, `subject_data_dir`, `subject_is_active`, `subject_dob`, `subject_acquisition_date`, `subject_dod`, `subject_gender`) VALUES
(1, 'Macaca', 'Andy', 'A', 'andy', 0, '1989-06-27', '1990-09-27', '1999-09-24', 'U'),
(2, 'Macaca', 'Archimedes', 'Ar', 'Archimedes', 0, '2004-11-24', '2009-08-14', '2012-11-15', 'U'),
(3, 'Macaca', 'Bernie', 'B', 'bernie', 0, '1983-03-26', NULL, '1995-03-29', 'U'),
(4, 'Macaca', 'Broca', 'Br', 'Broca', 1, '2005-03-16', '2008-08-14', NULL, 'U'),
(5, 'Macaca', 'Cajal', 'Ca', 'Cajal', 1, '2005-09-07', '2011-08-11', NULL, 'U'),
(6, 'Macaca', 'Chase', 'C', 'chase', 0, '1990-06-30', NULL, '2001-02-20', 'U'),
(7, 'Macaca', 'Darwin', 'Da', 'Darwin', 1, '2006-07-24', '2011-08-11', NULL, 'U'),
(8, 'Macaca', 'Elvis', 'E', 'Elvis', 0, '1992-03-27', '1994-01-27', NULL, 'U'),
(9, 'Macaca', 'Euler', 'Eu', 'Euler', 0, '2006-08-11', '2011-08-11', NULL, 'U'),
(10, 'Macaca', 'Fechner', 'F', 'Fechner', 0, '1993-02-27', '1995-10-18', '2011-09-23', 'U'),
(11, 'Macaca', 'Gauss', 'Ga', 'Gauss', 0, '2006-09-08', '2011-08-11', '2016-07-14', 'U'),
(12, 'Macaca', 'George', 'G', 'George', 0, NULL, NULL, NULL, 'U'),
(13, 'Macaca', 'Helmholtz', 'He', 'Helmholtz', 1, '2007-06-28', '2012-05-01', NULL, 'U'),
(14, 'Macaca', 'Hoagie', 'H', 'Hoagie', 0, '1993-02-17', '1997-04-23', '2002-05-02', 'U'),
(15, 'Macaca', 'Indy', 'I', 'Indy', 0, '1993-07-28', '1997-04-23', '1997-10-07', 'U'),
(16, 'Macaca', 'Ivan', 'Iv', 'Ivan', 1, '2012-05-26', '2015-09-16', NULL, 'U'),
(17, 'Macaca', 'JJ', 'J', 'JJ', 0, '1994-03-31', NULL, '2000-03-06', 'U'),
(18, 'Macaca', 'Joule', 'Jo', 'Joule', 1, '2012-05-30', '2015-09-16', NULL, 'U'),
(19, 'Macaca', 'Kelvin', 'Ke', 'Kelvin', 1, '2012-08-28', '2015-09-16', NULL, 'U'),
(20, 'Macaca', 'Kong', 'K', 'Kong', 0, NULL, NULL, NULL, 'U'),
(21, 'Macaca', 'Leonardo', 'Le', 'Leonardo', 1, '2012-07-09', '2015-09-16', NULL, 'U'),
(22, 'Macaca', 'Lucy', 'L', 'Lucy', 0, '1993-05-19', '1999-03-24', '2006-09-06', 'U'),
(23, 'Macaca', 'Mac', 'M', 'mac', 0, '1995-10-04', '1999-09-08', '2007-09-07', 'U'),
(24, 'Macaca', 'Norm', 'N', 'Norm', 0, '1996-04-15', NULL, '2006-05-01', 'U'),
(25, 'Macaca', 'Otis', 'O', 'otis', 0, '1996-10-23', '2000-05-04', '2005-09-13', 'U'),
(26, 'Macaca', 'Pep', 'P', 'pep', 0, '1997-12-12', '2000-05-04', '2008-05-10', 'U'),
(27, 'Macaca', 'Quincy', 'Q', 'Quincy', 0, '2000-01-01', '2002-06-14', '2013-05-24', 'U'),
(28, 'Macaca', 'Regina', 'R', 'Regina', 0, '2001-09-01', '2006-03-01', '2007-02-23', 'U'),
(29, 'Macaca', 'Seymour', 'S', 'Seymour', 0, '2000-01-01', '2002-06-14', '2013-05-22', 'U'),
(30, 'Macaca', 'Theo', 'T', 'Theo', 0, '2000-01-07', '1993-10-01', '2007-05-08', 'U'),
(31, 'Macaca', 'Upton', 'U', 'Upton', 0, '2002-05-30', '2005-08-23', '2011-10-12', 'U'),
(32, 'Macaca', 'Vincent', 'V', 'Vincent', 0, '2002-06-12', '2005-08-23', '2006-03-14', 'U'),
(33, 'Macaca', 'Wilma', 'W', 'Wilma', 0, '1999-01-16', '2006-03-01', '2010-12-06', 'U'),
(34, 'Macaca', 'Xena', 'X', 'Xena', 0, '2004-02-14', '2006-03-01', '2015-03-02', 'U'),
(35, 'Macaca', 'Yo Yo', 'Y', 'Yoyo', 0, '2002-02-02', '2006-03-01', '2012-02-09', 'U'),
(36, 'Macaca', 'Zorro', 'Z', 'Zorro', 0, '2004-02-27', '2006-03-01', '2011-09-01', 'U');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `subject`
--
ALTER TABLE `subject`
  ADD PRIMARY KEY (`subject_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `subject`
--
ALTER TABLE `subject`
  MODIFY `subject_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=37;
