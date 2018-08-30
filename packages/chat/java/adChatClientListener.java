import java.io.*;
import java.net.*;
import java.util.*;
import java.awt.*;

/**
 *
 *   @author David Dao (ddao@arsdigita.com)
 *   @creation-date November 17, 2000
 *   @cvs-id $Id: adChatClientListener.java,v 1.2 2006/03/14 12:16:08 emmar Exp $
 */
public class adChatClientListener implements Runnable {
    private Socket socket = null;

    private PrintWriter output = null;
    private BufferedReader input = null;
    private boolean running = true;

    private adChatClient client = null;
    private adChatClientInfo client_info = null;

    public adChatClientListener(adChatClient client, adChatClientInfo client_info) {
        this.client = client;
        this.client_info = client_info;

        try {
            // Spawn new thread for client
            socket = new Socket(client_info.host, client_info.port);
            input = new BufferedReader(new InputStreamReader(socket.getInputStream()));
            output = new PrintWriter(socket.getOutputStream(), true);

            Thread t = new Thread(this);
            t.start();

        } catch (Exception exc) {
            if (client != null) 
                client.receiveMessage(adChatMessage.buildBroadcastMsg(null, "System", null, "Could not reach chat server."));

        }
    }

    public void run() {
        try {
            // Send authenticate request here.
            logOn();
            while(running) {
                client.receiveMessage(input.readLine());
            }
            socket.close();
        } catch (Exception exc) {
            if (client != null) 
                client.receiveMessage(adChatMessage.buildBroadcastMsg(null, "System", null, "Chat server shuting down."));
        }       
    }

    public void logOn() {
        try {
            /** 
             * Let's do a work around now. If pw is true then the client is moderator.
             * TODO: Need to remove this.
             */
            String pw;
            if (client_info.moderator)
                pw = "T";
            else
                pw = "F";

            String msg = adChatLoginMessage.buildLoginMsg(client_info.user_id, client_info.user_name, pw, client_info.room_id);
            output.println(msg);
        } catch (Exception exc) {
            System.out.println("Exception in logOn: " + exc);
        }
    }

    public void postPrivateMessage(String to_user, String msg) {
        try {
            msg = adChatMessage.buildPrivateMsg(client_info.user_name, to_user, client_info.room_id, msg);
            output.println(msg);
        } catch (Exception exc) {
            System.out.println("Exception in postPrivateMessage");
        }
    }

    public void postMessage(String msg) {
        try {
            msg = adChatMessage.buildBroadcastMsg(client_info.user_id, client_info.user_name, client_info.room_id, msg);
            output.println(msg);
            
        } catch( Exception exc) {
            System.out.println("Exception in postMessage: " + exc);
        }
    }

    public void rejectModerateMessage(String user, String message_id, String msg) {
        try {
            msg = adChatMessage.buildRejectModerateMsg(message_id, user, client_info.room_id, msg);
            output.println(msg);
        } catch (Exception exc) {
            System.out.println("Exception in rejectModerateMessage: " + exc);
        }
    }

    public void approveModerateMessage(String user, String message_id, String msg) {
        try {
            msg = adChatMessage.buildBroadcastMsg(message_id, null, user, client_info.room_id, msg);
            output.println(msg);
        } catch ( Exception exc) {
            System.out.println("Exception in approve moderate message: " + exc);
        }
    }

    public void disconnect() {
        running = false;
        try {
            output.println(adChatSystemMessage.buildUserLeaveMsg(client_info.user_id, client_info.user_name));
            socket.close();
        } catch (Exception exc) {}
    }

}












