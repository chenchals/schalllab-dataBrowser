package vandy.psy.schall.meta.model;

import java.util.Date;
import java.util.HashSet;
import java.util.Set;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import static javax.persistence.GenerationType.IDENTITY;
import javax.persistence.Id;
import javax.persistence.OneToMany;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

@Entity
@Table(name = "study_subject", catalog = "schalllab")
public class StudySubject implements java.io.Serializable {

	private static final long serialVersionUID = -6533355566969075947L;
	@Id
	@GeneratedValue(strategy = IDENTITY)
	@Column(name = "subject_id", unique = true, nullable = false)
	private Integer subjectId;

	@Column(name = "subject_species", length = 100)
	private String subjectSpecies;

	@Column(name = "subject_name", length = 50)
	private String subjectName;

	@Column(name = "subject_name_abbr", length = 50)
	private String subjectNameAbbr;

	@Column(name = "subject_data_dir", length = 50)
	private String subjectDataDir;

	@Column(name = "subject_is_active", length = 1)
	private String subjectIsActive;

	@Temporal(TemporalType.DATE)
	@Column(name = "subject_dob", length = 10)
	private Date subjectDob;

	@Temporal(TemporalType.DATE)
	@Column(name = "subject_acquisition_date", length = 10)
	private Date subjectAcquisitionDate;

	@Temporal(TemporalType.DATE)
	@Column(name = "subject_dod", length = 10)
	private Date subjectDod;

	@Column(name = "subject_gender", length = 10)
	private String subjectGender;

	@OneToMany(fetch = FetchType.EAGER, mappedBy = "studySubject")
	private Set<Study> studies = new HashSet<Study>(0);

	public StudySubject() {
	}

	public StudySubject(String subjectSpecies, String subjectName, String subjectNameAbbr, String subjectDataDir,
			String subjectIsActive, Date subjectDob, Date subjectAcquisitionDate, Date subjectDod, String subjectGender,
			Set<Study> studies) {
		this.subjectSpecies = subjectSpecies;
		this.subjectName = subjectName;
		this.subjectNameAbbr = subjectNameAbbr;
		this.subjectDataDir = subjectDataDir;
		this.subjectIsActive = subjectIsActive;
		this.subjectDob = subjectDob;
		this.subjectAcquisitionDate = subjectAcquisitionDate;
		this.subjectDod = subjectDod;
		this.subjectGender = subjectGender;
		this.studies = studies;
	}

	public Integer getSubjectId() {
		return this.subjectId;
	}

	public void setSubjectId(Integer subjectId) {
		this.subjectId = subjectId;
	}

	public String getSubjectSpecies() {
		return this.subjectSpecies;
	}

	public void setSubjectSpecies(String subjectSpecies) {
		this.subjectSpecies = subjectSpecies;
	}

	public String getSubjectName() {
		return this.subjectName;
	}

	public void setSubjectName(String subjectName) {
		this.subjectName = subjectName;
	}

	public String getSubjectNameAbbr() {
		return this.subjectNameAbbr;
	}

	public void setSubjectNameAbbr(String subjectNameAbbr) {
		this.subjectNameAbbr = subjectNameAbbr;
	}

	public String getSubjectDataDir() {
		return this.subjectDataDir;
	}

	public void setSubjectDataDir(String subjectDataDir) {
		this.subjectDataDir = subjectDataDir;
	}

	public String getSubjectIsActive() {
		return this.subjectIsActive;
	}

	public void setSubjectIsActive(String subjectIsActive) {
		this.subjectIsActive = subjectIsActive;
	}

	public Date getSubjectDob() {
		return this.subjectDob;
	}

	public void setSubjectDob(Date subjectDob) {
		this.subjectDob = subjectDob;
	}

	public Date getSubjectAcquisitionDate() {
		return this.subjectAcquisitionDate;
	}

	public void setSubjectAcquisitionDate(Date subjectAcquisitionDate) {
		this.subjectAcquisitionDate = subjectAcquisitionDate;
	}

	public Date getSubjectDod() {
		return this.subjectDod;
	}

	public void setSubjectDod(Date subjectDod) {
		this.subjectDod = subjectDod;
	}

	public String getSubjectGender() {
		return this.subjectGender;
	}

	public void setSubjectGender(String subjectGender) {
		this.subjectGender = subjectGender;
	}

	public Set<Study> getStudies() {
		return this.studies;
	}

	public void setStudies(Set<Study> studies) {
		this.studies = studies;
	}

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((studies == null) ? 0 : studies.hashCode());
		result = prime * result + ((subjectAcquisitionDate == null) ? 0 : subjectAcquisitionDate.hashCode());
		result = prime * result + ((subjectDataDir == null) ? 0 : subjectDataDir.hashCode());
		result = prime * result + ((subjectDob == null) ? 0 : subjectDob.hashCode());
		result = prime * result + ((subjectDod == null) ? 0 : subjectDod.hashCode());
		result = prime * result + ((subjectGender == null) ? 0 : subjectGender.hashCode());
		result = prime * result + ((subjectId == null) ? 0 : subjectId.hashCode());
		result = prime * result + ((subjectIsActive == null) ? 0 : subjectIsActive.hashCode());
		result = prime * result + ((subjectName == null) ? 0 : subjectName.hashCode());
		result = prime * result + ((subjectNameAbbr == null) ? 0 : subjectNameAbbr.hashCode());
		result = prime * result + ((subjectSpecies == null) ? 0 : subjectSpecies.hashCode());
		return result;
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		StudySubject other = (StudySubject) obj;
		if (studies == null) {
			if (other.studies != null)
				return false;
		} else if (!studies.equals(other.studies))
			return false;
		if (subjectAcquisitionDate == null) {
			if (other.subjectAcquisitionDate != null)
				return false;
		} else if (!subjectAcquisitionDate.equals(other.subjectAcquisitionDate))
			return false;
		if (subjectDataDir == null) {
			if (other.subjectDataDir != null)
				return false;
		} else if (!subjectDataDir.equals(other.subjectDataDir))
			return false;
		if (subjectDob == null) {
			if (other.subjectDob != null)
				return false;
		} else if (!subjectDob.equals(other.subjectDob))
			return false;
		if (subjectDod == null) {
			if (other.subjectDod != null)
				return false;
		} else if (!subjectDod.equals(other.subjectDod))
			return false;
		if (subjectGender == null) {
			if (other.subjectGender != null)
				return false;
		} else if (!subjectGender.equals(other.subjectGender))
			return false;
		if (subjectId == null) {
			if (other.subjectId != null)
				return false;
		} else if (!subjectId.equals(other.subjectId))
			return false;
		if (subjectIsActive == null) {
			if (other.subjectIsActive != null)
				return false;
		} else if (!subjectIsActive.equals(other.subjectIsActive))
			return false;
		if (subjectName == null) {
			if (other.subjectName != null)
				return false;
		} else if (!subjectName.equals(other.subjectName))
			return false;
		if (subjectNameAbbr == null) {
			if (other.subjectNameAbbr != null)
				return false;
		} else if (!subjectNameAbbr.equals(other.subjectNameAbbr))
			return false;
		if (subjectSpecies == null) {
			if (other.subjectSpecies != null)
				return false;
		} else if (!subjectSpecies.equals(other.subjectSpecies))
			return false;
		return true;
	}

	@Override
	public String toString() {
		return "StudySubject [subjectId=" + subjectId + ", subjectSpecies=" + subjectSpecies + ", subjectName="
				+ subjectName + ", subjectNameAbbr=" + subjectNameAbbr + ", subjectDataDir=" + subjectDataDir
				+ ", subjectIsActive=" + subjectIsActive + ", subjectDob=" + subjectDob + ", subjectAcquisitionDate="
				+ subjectAcquisitionDate + ", subjectDod=" + subjectDod + ", subjectGender=" + subjectGender
				+ ", studies=" + studies + "]";
	}

}
