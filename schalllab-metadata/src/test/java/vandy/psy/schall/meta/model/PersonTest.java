package vandy.psy.schall.meta.model;

import java.sql.Connection;
import java.sql.DriverManager;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.EntityTransaction;
import javax.persistence.Persistence;
import javax.persistence.Query;

import org.junit.After;
import org.junit.Before;
import org.junit.Ignore;
import org.junit.Test;

public class PersonTest {

	// Get the entity manager for the tests.
	EntityManagerFactory emf;
	EntityManager em;


	@Before
	public void setup() {
		emf = Persistence.createEntityManagerFactory("schalllab-metadata");
		em = emf.createEntityManager();

	}

	@After
	public void testdown() {
        em.close();
	}

	@Ignore
	public void testConn() throws Exception {
		String password = "";
		String username = "";
		String url = "jdbc:mysql://129.59.231.27:6603/schalllab?connectionTimeout=3000";
		try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection conn = DriverManager.getConnection(url, username, password);
			System.out.println(conn.getSchema());
		} catch (Exception ex) {
			ex.printStackTrace(System.out);
		}

	}

	@Test
	public void findAllPersonStudies() throws Exception {
		
		List<Person> persons = em.createNamedQuery("Person.findAllPersonStudies",Person.class).getResultList();
	    for (Person person : persons) {
			System.out.println(person);
		}
	}

	@Test
	public void test1() throws Exception {
		try {
			// // Persist the object in the DB
			// // em.persist();
			// StudySubject studySubject = createStudySubject();
			// Person person = createPerson();
			//
			// em.persist(person);
			// em.persist(studySubject);
			//
			// Set<Study> studies = createStudies(studySubject, person, 5);
			// person.setStudies(studies);
			// studySubject.setStudies(studies);
			//
			// for (Study study : studies) {
			// em.persist(study);
			// }
			// save or update
			EntityTransaction trx=em.getTransaction();
			trx.begin();
//			Query query=em.createQuery("select p, s from Person p join p.studies s");
//			List<Person> persons = query.getResultList();
			
			Person p1=em.find(Person.class, 8);
			System.out.println(p1);
			
			
//			List<Person> persons = em.createQuery("select p from Person p").getResultList();
//       
//			for (Person p : persons) {
//				Set<Study> studies=p.getStudies();
//				System.out.println(studies);
//				System.out.println(p);
//			}
			// System.out.println(persons);
			// Person existing=em.find(Person.class, person);
			// if(null==existing){
			// em.persist(person);
			// }else{
			// existing.setPersonEmail(person.getPersonEmail());
			// existing.setPersonFirstname(person.getPersonFirstname());
			// existing.setPersonLastname(person.getPersonLastname());
			// existing.setStudies(person.getStudies());
			// em.merge(existing);
			// }

			// Commit and end the transaction
            em.getTransaction().commit();
		} catch (RuntimeException e) {
			
			throw e;
		}
	}

	private StudySubject createStudySubject() throws Exception {
		SimpleDateFormat sdf = new SimpleDateFormat("MM/dd/yyyy");
		Date dob = sdf.parse("06/20/2011");
		Date aqd = sdf.parse("07/30/2012");
		Date dod = null;
		return new StudySubject("Macaca", "MonkTest", "MT", "data/monktest", "Y", dob, aqd, dod, "M",
				new HashSet<Study>());

	}

	private Person createPerson() {
		return new Person("testFirst", "testLast", "test@monk.edu", new HashSet<Study>());
	}

	private Set<Study> createStudies(StudySubject studySubject, Person person, int nStudies) {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
		Set<Study> studies = new HashSet<Study>();
		for (int i = 0; i < nStudies; i++) {
			Calendar cal = Calendar.getInstance();
			cal.add(Calendar.DATE, -10 * i);
			Study study = new Study(person, studySubject);
			study.setStudyDatafile(studySubject.getSubjectNameAbbr() + sdf.format(cal.getTime()) + ".mat");
			study.setStudyDescription("Test study" + Integer.toString(i) + " sef CC");
			study.setStudyDate(cal.getTime());
			studies.add(study);
		}
		return studies;
	}

}
