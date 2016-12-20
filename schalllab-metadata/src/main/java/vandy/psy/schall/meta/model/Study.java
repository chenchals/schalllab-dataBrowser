package vandy.psy.schall.meta.model;

import java.util.Date;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import static javax.persistence.GenerationType.IDENTITY;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

@Entity
@Table(name = "study", catalog = "schalllab")
public class Study implements java.io.Serializable {

	private static final long serialVersionUID = 5128371311147669998L;
	@Id
	@GeneratedValue(strategy = IDENTITY)
	@Column(name = "study_id", unique = true, nullable = false)
	private Integer studyId;

	@ManyToOne(optional= false, cascade=CascadeType.ALL, fetch = FetchType.LAZY)
	@JoinColumn(name = "person_id", referencedColumnName="person_id", nullable = false)
	private Person person;

	@ManyToOne(optional= false, cascade=CascadeType.ALL, fetch = FetchType.LAZY)
	@JoinColumn(name = "subject_id", referencedColumnName="subject_id", nullable = false)
	private StudySubject studySubject;

	@Column(name = "study_datafile", length = 100)
	private String studyDatafile;

	@Column(name = "study_description", length = 100)
	private String studyDescription;

	@Temporal(TemporalType.DATE)
	@Column(name = "study_date", length = 10)
	private Date studyDate;

	public Study() {
	}

	public Study(Person person, StudySubject studySubject) {
		this.person = person;
		this.studySubject = studySubject;
	}

	public Study(Person person, StudySubject studySubject, String studyDatafile, String studyDescription,
			Date studyDate) {
		this.person = person;
		this.studySubject = studySubject;
		this.studyDatafile = studyDatafile;
		this.studyDescription = studyDescription;
		this.studyDate = studyDate;
	}

	public Integer getStudyId() {
		return this.studyId;
	}

	public void setStudyId(Integer studyId) {
		this.studyId = studyId;
	}

	public Person getPerson() {
		return this.person;
	}

	public void setPerson(Person person) {
		this.person = person;
	}

	public StudySubject getStudySubject() {
		return this.studySubject;
	}

	public void setStudySubject(StudySubject studySubject) {
		this.studySubject = studySubject;
	}

	public String getStudyDatafile() {
		return this.studyDatafile;
	}

	public void setStudyDatafile(String studyDatafile) {
		this.studyDatafile = studyDatafile;
	}

	public String getStudyDescription() {
		return this.studyDescription;
	}

	public void setStudyDescription(String studyDescription) {
		this.studyDescription = studyDescription;
	}

	public Date getStudyDate() {
		return this.studyDate;
	}

	public void setStudyDate(Date studyDate) {
		this.studyDate = studyDate;
	}

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((person == null) ? 0 : person.hashCode());
		result = prime * result + ((studyDatafile == null) ? 0 : studyDatafile.hashCode());
		result = prime * result + ((studyDate == null) ? 0 : studyDate.hashCode());
		result = prime * result + ((studyDescription == null) ? 0 : studyDescription.hashCode());
		result = prime * result + ((studyId == null) ? 0 : studyId.hashCode());
		result = prime * result + ((studySubject == null) ? 0 : studySubject.hashCode());
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
		Study other = (Study) obj;
		if (person == null) {
			if (other.person != null)
				return false;
		} else if (!person.equals(other.person))
			return false;
		if (studyDatafile == null) {
			if (other.studyDatafile != null)
				return false;
		} else if (!studyDatafile.equals(other.studyDatafile))
			return false;
		if (studyDate == null) {
			if (other.studyDate != null)
				return false;
		} else if (!studyDate.equals(other.studyDate))
			return false;
		if (studyDescription == null) {
			if (other.studyDescription != null)
				return false;
		} else if (!studyDescription.equals(other.studyDescription))
			return false;
		if (studyId == null) {
			if (other.studyId != null)
				return false;
		} else if (!studyId.equals(other.studyId))
			return false;
		if (studySubject == null) {
			if (other.studySubject != null)
				return false;
		} else if (!studySubject.equals(other.studySubject))
			return false;
		return true;
	}

	@Override
	public String toString() {
		return "Study [studyId=" + studyId + ", person=" + person + ", studySubject=" + studySubject
				+ ", studyDatafile=" + studyDatafile + ", studyDescription=" + studyDescription + ", studyDate="
				+ studyDate + "]";
	}

}
