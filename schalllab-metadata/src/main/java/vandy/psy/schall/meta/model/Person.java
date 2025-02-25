package vandy.psy.schall.meta.model;

import static javax.persistence.GenerationType.IDENTITY;

import java.util.HashSet;
import java.util.Set;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.OneToMany;
import javax.persistence.Table;

@Entity
@Table(name = "person", catalog = "schalllab")
public class Person implements java.io.Serializable {

	private static final long serialVersionUID = 7672483352959598682L;
	@Id
	@GeneratedValue(strategy = IDENTITY)
	@Column(name = "person_id", unique = true, nullable = false)
	private Integer personId;
	
	@Column(name = "person_firstname", length = 100)
	private String personFirstname;
	
	@Column(name = "person_lastname", length = 100)
	private String personLastname;
	
	@Column(name = "person_email", length = 100)
	private String personEmail;
	
	@OneToMany(fetch = FetchType.LAZY, mappedBy = "person", targetEntity=Study.class, cascade=CascadeType.ALL)
	private Set<Study> studies = new HashSet<Study>(0);

	public Person() {
	}

	public Person(String personFirstname, String personLastname, String personEmail, Set<Study> studies) {
		this.personFirstname = personFirstname;
		this.personLastname = personLastname;
		this.personEmail = personEmail;
		this.studies = studies;
	}

	public Integer getPersonId() {
		return this.personId;
	}

	public void setPersonId(Integer personId) {
		this.personId = personId;
	}

	public String getPersonFirstname() {
		return this.personFirstname;
	}

	public void setPersonFirstname(String personFirstname) {
		this.personFirstname = personFirstname;
	}

	public String getPersonLastname() {
		return this.personLastname;
	}

	public void setPersonLastname(String personLastname) {
		this.personLastname = personLastname;
	}

	public String getPersonEmail() {
		return this.personEmail;
	}

	public void setPersonEmail(String personEmail) {
		this.personEmail = personEmail;
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
		result = prime * result + ((personEmail == null) ? 0 : personEmail.hashCode());
		result = prime * result + ((personFirstname == null) ? 0 : personFirstname.hashCode());
		result = prime * result + ((personId == null) ? 0 : personId.hashCode());
		result = prime * result + ((personLastname == null) ? 0 : personLastname.hashCode());
		result = prime * result + ((studies == null) ? 0 : studies.hashCode());
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
		Person other = (Person) obj;
		if (personEmail == null) {
			if (other.personEmail != null)
				return false;
		} else if (!personEmail.equals(other.personEmail))
			return false;
		if (personFirstname == null) {
			if (other.personFirstname != null)
				return false;
		} else if (!personFirstname.equals(other.personFirstname))
			return false;
		if (personId == null) {
			if (other.personId != null)
				return false;
		} else if (!personId.equals(other.personId))
			return false;
		if (personLastname == null) {
			if (other.personLastname != null)
				return false;
		} else if (!personLastname.equals(other.personLastname))
			return false;
		if (studies == null) {
			if (other.studies != null)
				return false;
		} else if (!studies.equals(other.studies))
			return false;
		return true;
	}

	@Override
	public String toString() {
		return "Person [personId=" + personId + ", personFirstname=" + personFirstname + ", personLastname="
				+ personLastname + ", personEmail=" + personEmail + ", studies=" + studies + "]";
	}

}
