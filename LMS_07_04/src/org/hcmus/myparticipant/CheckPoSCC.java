package org.hcmus.myparticipant;

import java.io.Serializable;
import java.sql.Connection;

import org.hcmus.Util.Constant;
import org.hcmus.Util.MessageHelper;
import org.hcmus.bus.JPOS_PoSCCBUS;
import org.jpos.iso.ISOMsg;
import org.jpos.transaction.Context;
import org.jpos.transaction.TransactionParticipant;

/**
 * Check device which sends ISO8583 message is supported.
 * @author HUNGPT
 *
 */
public class CheckPoSCC implements TransactionParticipant {

	@Override
	public void abort(long id, Serializable serializeable) {

	}

	@Override
	public void commit(long id, Serializable serializeable) {

	}

	@Override
	public int prepare(long id, Serializable serializeable) {

		// get context from space
		Context ctx = (Context) serializeable;

		// get message from context
		ISOMsg msg = (ISOMsg) ctx.get(Constant.REQUEST);

		// Get connection from context
		Connection con = (Connection) ctx.get(Constant.CONN);
		if (con == null) {
			ctx.put(Constant.RC, "12");
			return ABORTED | READONLY | NO_JOIN;
		}

		if (msg != null) {
			String posccid = MessageHelper.getPoSCC(msg);
			if (!posccid.isEmpty()) {
				int result = JPOS_PoSCCBUS.checkPoSCC(posccid, con);
				if (result == 0) {
					ctx.put(Constant.RC, "58");
					return ABORTED | READONLY | NO_JOIN;
				} else {
					return PREPARED | READONLY | NO_JOIN;
				}
			} else {
				ctx.put(Constant.RC, "58");
				return ABORTED | READONLY | NO_JOIN;
			}
		} else {
			ctx.put(Constant.RC, 12);
			return ABORTED | READONLY | NO_JOIN;
		}
	}

}
