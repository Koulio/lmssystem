package org.hcmus.lmsclient.activation;

import java.sql.Connection;
import java.sql.PreparedStatement;

import org.hcmus.lmsclient.util.Constant;
import org.hcmus.lmsclient.util.DataProvider;
import org.jpos.iso.ISOChannel;
import org.jpos.iso.ISOMsg;
import org.jpos.iso.ISOPackager;
import org.jpos.iso.channel.ASCIIChannel;
import org.jpos.iso.packager.GenericPackager;

import junit.framework.TestCase;
/**
 * Purpose of this case use to check check card hasn�t activated yet.
 * @author HUNGPT
 *
 */
public class HappyActivation extends TestCase {

	public HappyActivation(String name) {
		super(name);
	}
	
	protected void setUp() throws Exception {
		super.setUp();
		Connection con = DataProvider.getConnection();
		String sql = "update JPOS_Card set JPOS_IsActivate = '0' where JPOS_CardId = '8765432112345678' ";
		PreparedStatement st = con.prepareStatement(sql);
		st.executeUpdate();
		con.close();
	}
	
	public void testHappyActivation(){
		try {
			// set package iso87binary.XML
			ISOPackager p = new GenericPackager("cfg/iso87binary.xml");

			// create and set field for message
			ISOMsg m = new ISOMsg();
			m.setMTI("0200");
			m.set("3", "457000");
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
			if (!r.hasField(62) && !r.hasField(39)) {
				fail();
			}
			assertEquals("00",r.getValue(39));
			assertEquals(Constant.SUCCESFULL,r.getValue(62));
			
			// close connection
			channel.disconnect();

		} catch (Exception ex) {
			fail("Some exceptions founded.");
		}
	}
}
