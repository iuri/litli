/**
 * 
 *   @author David Dao (ddao@arsdigita.com)
 *   @creation-date December 7, 2000
 *   @cvs-id $Id: adChatClientInfo.java,v 1.2 2006/03/14 12:16:08 emmar Exp $
 */
public class adChatClientInfo {
    public String host = null;
    public int port = -1;
    public String user_id = null;
    public String user_name = null;
    public String room_id = null;
    public boolean moderator = false;
    public boolean admin = false;

    public adChatClientInfo() {
    }
    public adChatClientInfo(String user_id, String user_name) {
	this.user_id = user_id;
	this.user_name = user_name;
    }
}
