package vandy.psy.schall.meta.model;

import java.sql.Connection;
import java.sql.DriverManager;

import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.EntityTransaction;
import javax.persistence.Persistence;

import org.junit.Ignore;
import org.junit.Test;

public class PersonTest {

	@Ignore
	public void testConn() throws Exception {
		String password = "";
		String username = "";
		String url = "jdbc:mysql://127.59.231.27:6603/schalllab?connectionTimeout=120000";
		try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection conn = DriverManager.getConnection(url, username, password);
			System.out.println(conn.getSchema());
		} catch (Exception ex) {
			ex.printStackTrace(System.out);
		}

	}

	@Test
	public void testConn2() throws Exception {
		String password = "";
		String username = "";
		String url = "jdbc:mysql://127.0.0.1:3306/scratch";
		try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection conn = DriverManager.getConnection(url, username, password);
			System.out.println(conn.getSchema());
		} catch (Exception ex) {
			ex.printStackTrace(System.out);
		}

	}

	@Test
	public void test1() throws Exception {
		// Get the entity manager for the tests.
		EntityManagerFactory emf = Persistence.createEntityManagerFactory("schalllab-metadata");
		EntityManager em = emf.createEntityManager();
		EntityTransaction trx = null;
		try {
			// Get a new transaction
			trx = em.getTransaction();
			// Start the transaction
			trx.begin();
			// Persist the object in the DB
			em.persist(new Person("testFirst", "testLast", "test@monk.edu", null));
			// Commit and end the transaction
			trx.commit();
		} catch (RuntimeException e) {
			if (trx != null && trx.isActive()) {
				trx.rollback();
			}
			throw e;
		} finally {
			// Close the manager
			em.close();
			emf.close();
		}
	}

}
