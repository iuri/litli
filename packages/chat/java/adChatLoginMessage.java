/**
 *
 * @author David Dao (ddao@arsdigita.com)
 * @creation-date December 7, 2000
 * @cvs-id $Id: adChatLoginMessage.java,v 1.2 2006/03/14 12:16:08 emmar Exp $
 */
public class adChatLoginMessage {

    /**
     * Private variables.
     */
    private String user_id = null;
    private String user_name = null;
    private String pw = null;
    private String room_id = null;

    private boolean valid = true;

    public adChatLoginMessage() {
    }

    public adChatLoginMessage(String xml) {
	if (!adChatSimpleXMLParser.containTag(xml, "login")) {
	    valid = false;
	    return;
	}

	user_id   = adChatSimpleXMLParser.getTag(xml, "user_id");
	user_name = adChatSimpleXMLParser.getTag(xml, "user_name");
	pw        = adChatSimpleXMLParser.getTag(xml, "pw");
	room_id   = adChatSimpleXMLParser.getTag(xml, "room_id");
    }

    public void setUserId(String user_id) {
	this.user_id = user_id;
    }

    public String getUserId() {
	return user_id;
    }

    public void setUserName(String user_name) {
	this.user_name = user_name;
    }

    public String getUserName() {
	return user_name;
    }

    public void setPassword(String pw) {
	this.pw = pw;
    }

    public String getPassword() {
	return pw;
    }

    public void setRoomId(String room_id) {
	this.room_id = room_id;
    }

    public String getRoomId() {
	return room_id;
    }

    public boolean isValid() {
	return valid;
    }

    public String buildXML() {
	return adChatLoginMessage.buildLoginMsg(user_id, user_name, pw, room_id);
    }

    public String toString() {
	return adChatLoginMessage.buildLoginMsg(user_id, user_name, pw, room_id);
    }

    public static String buildLoginMsg(String user_id, String user_name, String pw, String room_id) {

	StringBuffer sb = new StringBuffer(400);

	sb.append("<login>");
	if (user_id != null)
	    sb.append("<user_id>").append(user_id).append("</user_id>");
	if (user_name != null)
	    sb.append("<user_name>").append(user_name).append("</user_name>");
	if (pw != null)
	    sb.append("<pw>").append(pw).append("</pw>");
	if (room_id != null)
	    sb.append("<room_id>").append(room_id).append("</room_id>");
	sb.append("</login>");

	return sb.toString();
    }
}












