import java.io.*;
import java.net.*;
import java.util.*;
import java.awt.*;
import java.awt.event.*;

/**
 *
 * @author David Dao (ddao@arsdigita.com)
 * @author Stefan Deusch (stefan@arsdigita.com)
 * @creation-date December 6, 2000
 * @cvs-id $Id: adClientSession.java,v 1.4 2007/11/19 01:14:15 donb Exp $
 */

class adClientSession extends Thread {
    private Socket socket = null;

    private BufferedReader input = null;
    private PrintWriter output = null;
    private boolean running = true;
    private adChatDatasource datasource = null;
    private adChatServer server = null;

    private boolean authenticate_p = false;
    private boolean from_HTML_client = false;
    private String room_id = null;
    private InetAddress inet_address = null;

    public String  user_name = null;
    public String  user_id   = null;
    public boolean moderator = false;

    public adClientSession(adChatServer server, Socket socket) {
        this.datasource = server.getDatasource();
        this.socket = socket;
        this.server = server;

        inet_address = socket.getInetAddress();
    }

    public void run() {
        try {
            input = new BufferedReader(new InputStreamReader(socket.getInputStream()));
            output = new PrintWriter(socket.getOutputStream(), true);

            while(running) {
                String str = input.readLine();
                      
                System.out.println("Receive [" + str + "]");
                if (str.equals("Bye")) {
                    running = false;
                    output.close();
                    datasource.disconnectAll();
                    // For security reason you could only shutdown server from local host.
                    // TODO: Later might be able to shutdown chat server remotely with proper user
                    // authentication.
                    if (inet_address.equals(InetAddress.getLocalHost()))
                        server.shutdown();

                    return;
                }
                
                /**
                 * Authenticate user log in here. If invalid login then 
                 * close the connection immediately
                 */
                if (!authenticate_p) {
                    // Authenticate user log in.
                    adChatLoginMessage login = new adChatLoginMessage(str);

                    if (!login.isValid()) {
                        // Invalid log in message.
                        output.println(adChatMessage.buildBroadcastMsg(null, "Administrator", null, "Access denied."));
                        output.close();
                        socket.close();
                        running = false;
                        return;
                    } else {
                        user_name = login.getUserName();
                        room_id   = login.getRoomId();
                        user_id   = login.getUserId();
                        // Temporary.
                        // TODO: Fix it.
                        String tmp = login.getPassword();
                        if (tmp != null && tmp.equals("T"))
                            moderator = true;
                        System.out.println("User name: " + user_name + ", moderator = " + moderator);
                        if (user_name.equals("AOL_READER")) {
                            datasource.addAolSession(this);
                            authenticate_p = true;
                            
                        } else if (user_name.equals("AOL_WRITER")) {
                            from_HTML_client = true;
                            authenticate_p = true;
                        } else if (datasource.isDuplicate(user_name, room_id)) {
                            output.println(adChatMessage.buildBroadcastMsg(null, "Administrator", null, "User already in the room."));
                            output.close();
                            running = false;
                            return;
                        } else {
                            String user_list = datasource.getAppletUsers(room_id);

                            if (user_list != null) 
                                output.println(user_list);

                            datasource.addSession(this, room_id);
                            datasource.broadcastAppletOnly(adChatSystemMessage.buildUserEnterMsg(user_id, user_name), room_id);
                            datasource.broadcastAppletOnly(adChatMessage.buildBroadcastMsg(user_id, user_name, room_id, " has entered the room!"), room_id);
                            datasource.broadcastAolOnly(adChatMessage.buildBroadcastMsg(user_id, user_name, room_id, "/enter"), room_id);
                            authenticate_p = true;
                        }
                    }
                    continue;
                }
                System.out.println("Broadcast [" + str + "]");
                
                // Test to see if this is a log out message.
                if (adChatSimpleXMLParser.containTag(str, "system")) {
                    datasource.broadcastAppletOnly(str, room_id);
                    continue;
                }

                if (from_HTML_client) {
                    adChatMessage msg = new adChatMessage(str);
                    room_id = msg.getRoomId();
                }
                
                // Current assumption is all rooms are moderate.
                // TODO: Need to check if room is moderate or not.
                if (!moderator) {
                    adChatMessage msg = new adChatMessage(str);
                    str = adChatMessage.buildModerateMsg(msg.getFromUser(), msg.getRoomId(), msg.getBody());
                }
                
                if (from_HTML_client) {
                	//System.out.println("BroadCasting to applets only!");
                	datasource.broadcastAppletOnly(str, room_id);
                } else {
                	//System.out.println("BroadCasting to all stations!");
                	datasource.broadcast(str, room_id);
                }
                    
            }
            socket.close();
        } catch (Exception exc) {
            // Client connection die abnormally. Log this user off.
        }
        // Remove user from room. And broadcast message to everyone in the room.
        datasource.removeSession(this, room_id);
        datasource.broadcastAppletOnly(adChatMessage.buildBroadcastMsg(user_id, user_name, room_id, " has left the room!"), room_id);
        datasource.broadcastAolOnly(adChatMessage.buildBroadcastMsg(user_id, user_name, room_id, "/leave"), room_id);
    }

    public void postMessage(String msg) {
        try {
            output.println(msg);
        } catch (Exception exc) {}
    }

    public void disconnect() {
        running = false;
        try {
            socket.close();
        } catch (Exception exc) {}
    }
}






