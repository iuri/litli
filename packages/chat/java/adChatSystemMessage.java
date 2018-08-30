/**
 *
 * @author David Dao (ddao@arsdigita.com)
 * @creation-date December 7, 2000
 * @cvs-id $Id: adChatSystemMessage.java,v 1.2 2006/03/14 12:16:08 emmar Exp $
 */
import java.util.Vector;

public class adChatSystemMessage {

    public static int USER_ENTER = 0;
    public static int USER_LEAVE = 1;
    public static int USER_LIST  = 2;

    /**
     * Private variables.
     */
    private int type;
    private Vector list = null;
    private boolean valid = true;

    public adChatSystemMessage() {
	list = new Vector();
    }

    public adChatSystemMessage(String xml) {
	if (!adChatSimpleXMLParser.containTag(xml, "system")) {
	    valid = false;
	    return;
	}
	if (adChatSimpleXMLParser.containTag(xml, "user_enter"))
	    type = USER_ENTER;
	else if (adChatSimpleXMLParser.containTag(xml, "user_leave"))
	    type = USER_LEAVE;
	else if (adChatSimpleXMLParser.containTag(xml, "user_list"))
	    type = USER_LIST;
	else {
	    valid = false;
	    return;
	}

	list = new Vector();
	boolean done = false;

	while (!done) {
	    String user_id = adChatSimpleXMLParser.getTag(xml, "user_id");
	    String user_name = adChatSimpleXMLParser.getTag(xml, "user_name");
	    if (user_id == null || user_name == null) {
		done = true;
		continue;
	    }

	    adChatClientInfo client_info = new adChatClientInfo();
	    client_info.user_id = user_id;
	    client_info.user_name = user_name;

	    list.addElement(client_info);
	    if (type == USER_LIST)
		xml = adChatSimpleXMLParser.removeTag(xml, "user");
	    else 
		done = true;

	}
    }

    public void setType(int type) {
	this.type = type;
    }

    public int getType() {
	return type;
    }

    public Vector getList() {
	return list;
    }

    public int getListCount() {
	if (list != null)
	    return list.size();
	else 
	    return 0;
    }

    public String getUserName(int index) {
	if (index >= 0 && index < list.size())
	    return ((adChatClientInfo) list.elementAt(index)).user_name;
	return null;
    }

    public String getUserId(int index) {
	if (index >= 0 && index < list.size())
	    return ((adChatClientInfo) list.elementAt(index)).user_id;
	return null;
    }

    public void appendUser(String user_id, String user_name) {
	adChatClientInfo user = new adChatClientInfo();
	user.user_id = user_id;
	user.user_name = user_name;
	list.addElement(user);
    }

    public boolean isValid() {
	return valid;
    }

    public String buildXML() {
	return toString();
    }

    public String toString() {
	if (type == USER_ENTER)
	    return adChatSystemMessage.buildUserEnterMsg(getUserId(0), getUserName(0));
	else if (type == USER_LEAVE)
	    return adChatSystemMessage.buildUserLeaveMsg(getUserId(0), getUserName(0));
	else if (type == USER_LIST)
	    return adChatSystemMessage.buildUserList(list);
	else
	    return null;
    }

    public static String buildUserEnterMsg(String user_id, String user_name) {
	StringBuffer sb = new StringBuffer(400);

	sb.append("<system>");
	sb.append("<user_enter>");
	if (user_id != null)
	    sb.append("<user_id>").append(user_id).append("</user_id>");
	if (user_name != null)
	    sb.append("<user_name>").append(user_name).append("</user_name>");
	sb.append("</user_enter>");
	sb.append("</system>");

	return sb.toString();
    }

    public static String buildUserLeaveMsg(String user_id, String user_name) {
	StringBuffer sb = new StringBuffer(400);

	sb.append("<system>");
	sb.append("<user_leave>");
	if (user_id != null)
	    sb.append("<user_id>").append(user_id).append("</user_id>");
	if (user_name != null)
	    sb.append("<user_name>").append(user_name).append("</user_name>");
	sb.append("</user_leave>");
	sb.append("</system>");

	return sb.toString();
    }
    public static String buildUserList(Vector user_list) {
	if (user_list == null || user_list.size() == 0)
	    return null;

	StringBuffer sb = new StringBuffer(400);
	sb.append("<system><user_list>");

	for (int i = 0; i < user_list.size(); i++) {
	    sb.append("<user>");
	    sb.append("<user_id>").append(((adChatClientInfo) user_list.elementAt(i)).user_id).append("</user_id>");
	    sb.append("<user_name>").append(((adChatClientInfo) user_list.elementAt(i)).user_name).append("</user_name>");
	    sb.append("</user>");
	}

	sb.append("</user_list></system>");

	return sb.toString();
	    
    }
    public static void main(String argv[]) {
	String xml = "<system><user_list>";
	xml += "<user><user_id>1</user_id><user_name>A</user_name></user>";
	xml += "</user_list></system>";
	adChatSystemMessage m = new adChatSystemMessage(xml);
	for (int i = 0; i < m.getListCount(); i++) {
	    System.out.println("User_Id(" + i + ") = " + m.getUserId(i));
	    System.out.println("User_Name(" + i + ") = " + m.getUserName(i));
	}
    }
}

