package org.hcmus.myparticipant;

import java.io.Serializable;
import java.sql.Connection;

import org.hcmus.Util.Constant;
import org.hcmus.Util.MessageHelper;
import org.hcmus.bus.JPOS_CustomerBUS;
import org.jpos.iso.ISOMsg;
import org.jpos.transaction.Context;
import org.jpos.transaction.TransactionParticipant;

/**
 * Get point information of client.
 * @author HUNGPT
 *
 */
public class BalanceInquiry implements TransactionParticipant {

	@Override
	public void abort(long arg0, Serializable arg1) { }

	@Override
	public void commit(long arg0, Serializable arg1) { }

	@Override
	public int prepare(long id, Serializable serializable) {
		Context ctx = (Context) serializable;
		ISOMsg msg = (ISOMsg) ctx.get(Constant.REQUEST);
		Connection con = (Connection) ctx.get(Constant.CONN);
		if (con == null) {
			ctx.put(Constant.RC, "12");
			return ABORTED | READONLY | NO_JOIN;
		}
		if (msg != null) {

			/** get card number **/
			String cardNumber = MessageHelper.getCardId(msg);

			/** Balance inquiry business **/
			int result = JPOS_CustomerBUS.getCurrentPoint(cardNumber, con);
			
			/** if not successful  **/
			if(result == -1){
				ctx.put(Constant.RC, "12");
				return ABORTED | READONLY | NO_JOIN;
			}
			
			/** convert point to response string message **/
			String strPoint = MessageHelper.makeTLV("FF51", MessageHelper
					.format(Integer.toString(result), 4));
					
			/** put it to context for response participant **/
			ctx.put(Constant.POINT, strPoint);
			
			return PREPARED | READONLY | NO_JOIN;

		} else {
			ctx.put(Constant.RC, "12");
			return ABORTED | NO_JOIN;
		}
	}

}