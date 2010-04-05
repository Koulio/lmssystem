package org.hcmus.lmsclient.balanceinquiry;

import java.sql.Connection;
import java.sql.PreparedStatement;

import junit.framework.TestCase;

import org.hcmus.lmsclient.util.DataProvider;
import org.jpos.iso.ISOChannel;
import org.jpos.iso.ISOMsg;
import org.jpos.iso.ISOPackager;
import org.jpos.iso.channel.ASCIIChannel;
import org.jpos.iso.packager.GenericPackager;

/**
 * Purpose of this test case is use to check Balance Inquiry Happy path case.
 * @author HUNGPT
 *
 */
public class BalanceInquiryTest extends TestCase {

	public BalanceInquiryTest(String name) {
		super(name);
	}
	
	protected void setUp() throws Exception {
		super.setUp();
		Connection con = DataProvider.getConnection();
		String sql = "update JPOS_Customer set JPOS_CurrentPoint=50 where JPOS_IDCustomer=41";
		PreparedStatement st = con.prepareStatement(sql);
		st.executeUpdate();
		
		String sql1 = "update JPOS_Card set JPOS_IsActivate = '1' where JPOS_CardId = '8765432112345678' ";
		st = con.prepareStatement(sql1);
		st.executeUpdate();
		
		con.close();
	}

	protected void tearDown() throws Exception {
		super.tearDown();
	}
	
	public void testBalanceInquiry(){
		try {
			// set package iso87binary.XML
			ISOPackager p = new GenericPackager("cfg/iso87binary.xml");

			// create and set field for message
			ISOMsg m = new ISOMsg();
			m.setMTI("0200");
			
			m.set("3", "427000");
			m.set("11", "123456");
			m.set("12", "114109");
			m.set("13", "0122");
			m.set("25", "00");
			m.set("35", "8765432112345678=10041011765710800000");
			m.set("41", "00000001");
			m.set("42", "000000000000001");

			// set package for message
			m.setPackager(p);

			// set channel for message with server address, port and package
			ISOChannel channel = new ASCIIChannel("localhost", 9800, p);

			// connect to loyalty manage system server
			channel.connect();

			// send message
			channel.send(m);

			// receive response
			ISOMsg r = channel.receive();

			// logic
			if (!r.hasField(63) && !r.hasField(39)) {
				fail();
			}
			assertEquals("00",r.getValue(39));
			assertEquals("0000000050",r.getValue(63));
			// close connection
			channel.disconnect();

		} catch (Exception ex) {
			fail("Some exceptions founded.");
		}
	}
}
