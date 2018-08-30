/**
 *
 * @author David Dao (ddao@arsdigita.com)
 * @creation-date December 7, 2000
 * @cvs-id $Id: adChatMessage.java,v 1.2 2006/03/14 12:16:08 emmar Exp $
 */
public class adChatMessage {

    /**
     * Private variables.
     */
    private String message_id = null;
    private String from =  null;
    private String from_user_id = null;
    private String to = null;
    private String to_user_id = null;
    private String room_id = null;
    private String status = null;
    private String body = null;

    private boolean valid = true;

    public adChatMessage() {
    }

    public adChatMessage(String xml) {
        if (!adChatSimpleXMLParser.containTag(xml, "message")) {
            valid = false;
            return;
        }

        message_id   = adChatSimpleXMLParser.getTag(xml, "message_id");
        from         = adChatSimpleXMLParser.getTag(xml, "from");
        from_user_id = adChatSimpleXMLParser.getTag(xml, "from_user_id");
        to           = adChatSimpleXMLParser.getTag(xml, "to");
        to_user_id   = adChatSimpleXMLParser.getTag(xml, "to_user_id");
        room_id      = adChatSimpleXMLParser.getTag(xml, "room_id");
        status       = adChatSimpleXMLParser.getTag(xml, "status");
        body         = adChatSimpleXMLParser.getTag(xml, "body");
    }

    public void setMessageId(String id) {
        message_id = id;
    }

    public String getMessageId() {
        return message_id;
    }

    public void setFromUser(String user) {
        from = user;
    }

    public String getFromUser() {
        return from;
    }

    public void setFromUserId(String user_id) {
        from_user_id = user_id;
    }

    public String getFromUserId() {
        return from_user_id;
    }

    public void setToUserId(String user_id) {
        to_user_id = user_id;
    }

    public String getToUserId() {
        return to_user_id;
    }

    public void setToUser(String user) {
        to = user;
    }

    public String getToUser() {
        return to;
    }

    public void setRoomId(String room_id) {
        this.room_id = room_id;
    }

    public String getRoomId() {
        return room_id;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getStatus() {
        return status;
    }

    public void setBody(String msg) {
        body = msg;
    }

    public String getBody() {
        return body;
    }

    public String buildXML() {
        return adChatMessage.buildXML(message_id, from_user_id, from, to_user_id, to, room_id, status, body);
    }

    public boolean isValid() {
        return valid;
    }

    public String toString() {
        return adChatMessage.buildXML(message_id, from_user_id, from, to_user_id, to, room_id, status, body);
    }

    public static String buildXML(String message_id, String from_user_id, String from,
                                  String to_user_id, String to, String room_id, 
                                  String status, String body) {
        StringBuffer sb = new StringBuffer(400);

        sb.append("<message>");

        if (message_id != null)
            sb.append("<message_id>").append(message_id).append("</message_id>");
        if (from_user_id != null)
            sb.append("<from_user_id>").append(from_user_id).append("</from_user_id>");
        if (from != null)
            sb.append("<from>").append(from).append("</from>");
        if (to_user_id != null)
            sb.append("<to_user_id>").append(to_user_id).append("</to_user_id>");
        if (to != null) 
            sb.append("<to>").append(to).append("</to>");
        if (room_id != null)
            sb.append("<room_id>").append(room_id).append("</room_id>");
        if (status != null)
            sb.append("<status>").append(status).append("</status>");
        if (body != null)
            sb.append("<body>").append(body).append("</body>");

        sb.append("</message>");

        return sb.toString();
    }

    public static String buildBroadcastMsg(String id, String user_id, String from_user, String room_id, String body) {
        return buildXML(id, user_id, from_user, null, null, room_id, "approved", body);
    }

    public static String buildBroadcastMsg(String user_id, String from_user, String room_id, String body) {
        return buildXML(null, user_id, from_user, null, null, room_id, "approved", body);
    }

    public static String buildPrivateMsg(String from_user, String to_user, String room_id, String body) {
        return buildXML(null, null, from_user, null, to_user, room_id, null, body);
    }

    public static String buildModerateMsg(String from_user, String room_id, String body) {
        return buildXML(null, null, from_user, null, null, room_id, "pending", body);
    }
    public static String buildRejectModerateMsg(String id, String from_user, String room_id, String body) {
        return buildXML(id, null, from_user, null, null, room_id, "rejected", body);
    }
}























