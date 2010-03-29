package org.hcmus.lmsclient.addpoint;

import org.hcmus.lmsclient.util.Constant;
import org.jpos.iso.ISOChannel;
import org.jpos.iso.ISOMsg;
import org.jpos.iso.ISOPackager;
import org.jpos.iso.channel.ASCIIChannel;
import org.jpos.iso.packager.GenericPackager;

import junit.framework.TestCase;

public class ExpireCardCase extends TestCase {

	public ExpireCardCase(String name) {
		super(name);
	}

	protected void setUp() throws Exception {
		super.setUp();
	}

	protected void tearDown() throws Exception {
		super.tearDown();
	}
	
	
	public void testExpireCard(){
		try {
			// set package iso87binary.xml
			ISOPackager p = new GenericPackager("cfg/iso87binary.xml");

			// create and set field for message
			ISOMsg m = new ISOMsg();
			m.setMTI("0200");
			m.set("3", "407000");
			m.set("4", "000001500000");
			m.set("11", "123456");
			m.set("12", "114109");
			m.set("13", "0122");
			m.set("25", "00");
			m.set("35", "1234567887654321=10041011765710800000");
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
			assertEquals("54",r.getValue(39));
			assertEquals(Constant.EXPIRE_CARD,r.getValue(62));
			// close connection
			channel.disconnect();

		} catch (Exception ex) {
			fail("Some exceptions founded.");
		}
	}
}
