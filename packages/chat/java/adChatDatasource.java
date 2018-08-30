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
 * @cvs-id $Id: adChatDatasource.java,v 1.2 2006/03/14 12:16:08 emmar Exp $
 */

/**
 * This class is shared by multiple threads. Therefore this class needs
 * to be thread safe.
 *
 * Each chat user MUST have a unique screen name.
 */
public class adChatDatasource {
    private Hashtable rooms;
    private Vector aol_sessions; // Connections from AOL Server
    private long message_id = 0;

    public adChatDatasource() {
	rooms = new Hashtable();
	aol_sessions = new Vector();
    }

    public synchronized String getNextMessageId() {
	return String.valueOf(message_id++);
    }

    public synchronized void addAolSession(adClientSession session) {
	aol_sessions.addElement(session);
    }

    public synchronized void removeAolSession(adClientSession session) {
	aol_sessions.removeElement(session);
    }

    public synchronized void addSession(adClientSession session, String room_id) {
	if (room_id == null)
	    return;

	Hashtable clients = (Hashtable) rooms.get(room_id);
	if (clients == null) {
	    clients = new Hashtable();
	    rooms.put(room_id, clients);
	} 
	clients.put(session.user_name, session);
    }

    public synchronized void removeSession(adClientSession session, String room_id) {
	if (room_id == null)
	    return;

	Hashtable clients = (Hashtable) rooms.get(room_id);
	if (clients != null) {
	    clients.remove(session.user_name);
	}
    }

    /**
     * Check to see if the same user already exists in the room.
     */
    public synchronized boolean isDuplicate(String user_name, String room_id) {
	if (room_id == null)
	    return false;

	boolean ret = false;

	Hashtable clients = (Hashtable) rooms.get(room_id);
	if (clients != null)
	    ret = clients.containsKey(user_name);

	return ret;
	    
    }

    /**
     * Disconnect all current connections.
     */
    public synchronized void disconnectAll() {
	if (rooms != null) {
	    for (Enumeration r = rooms.elements(); r.hasMoreElements();) {
		Hashtable clients = (Hashtable) r.nextElement();
		for (Enumeration c = clients.elements(); c.hasMoreElements();) {
		    ((adClientSession) c.nextElement()).disconnect();
		}
	    }
	}
    }
    /**
     * List all applet users in the room.
     */
    public synchronized String getAppletUsers(String room_id) {
	if (room_id == null)
	    return null;

	Hashtable clients = (Hashtable) rooms.get(room_id);
	if (clients != null) {
	    Vector list = new Vector();

	    for (Enumeration e = clients.elements(); e.hasMoreElements();) {
		adClientSession client = (adClientSession) e.nextElement();
		adChatClientInfo info = new adChatClientInfo(client.user_id, client.user_name);
		list.addElement(info);
	    }

	    return adChatSystemMessage.buildUserList(list);
	}
	return null;
    }

    /**
     * Broadcast message to applet connection only.
     */
    public synchronized void broadcastAppletOnly(String msg, String room_id) {
	if (room_id == null)
	    return;

	Hashtable clients = (Hashtable) rooms.get(room_id);
	if (clients != null) {
	    adChatMessage chat_msg = new adChatMessage(msg);
	    
	    boolean moderate_msg = (chat_msg.getStatus() != null && (chat_msg.getStatus().equals("rejected") || chat_msg.getStatus().equals("pending"))) ? true : false;
	    /*
	    if (moderate_msg) {
		if (chat_msg.getStatus().equals("pending")) {
		    chat_msg.setMessageId(getNextMessageId()); // Assign next message id
		    msg = chat_msg.toString();
		}
	    }
	    */
	    // Iterate though each clients in the room and broadcast the message.
	    for (Enumeration e = clients.elements(); e.hasMoreElements();) {
		adClientSession client = (adClientSession) e.nextElement();

		// This is not a valid chat message. Just broadcast to clients.
		if (!chat_msg.isValid()) {
		    client.postMessage(msg);
		    continue;
		}

		if (chat_msg.getToUser() == null) {
		    // This is a public message.
		    if (!moderate_msg || (moderate_msg && client.moderator)) {
			client.postMessage(msg);
		    }
		    
		} else if (chat_msg.getToUser().equals(client.user_name)) {
		    // This is a private message.
		    client.postMessage(msg);
		    break;
		}

	    }
	    
	}
    }

    /**
     * Broadcast message to aol connection only.
     */
    public synchronized void broadcastAolOnly(String msg, String room_id) {
	if (room_id == null)
	    return;
	for (int i = 0; i < aol_sessions.size(); i++) {
	    adChatMessage chat_msg = new adChatMessage(msg);
	    // Only broadcast public message to AOL session.
	    if (chat_msg.getToUser() == null)
		((adClientSession) aol_sessions.elementAt(i)).postMessage(msg);
	}
    }

    /**
     * Broadcast message to everyone in the room.
     */
    public synchronized void broadcast(String msg, String room_id) {
	
	adChatMessage chat_msg = new adChatMessage(msg);
	
	boolean moderate_msg = (chat_msg.getStatus() != null && (chat_msg.getStatus().equals("rejected") || chat_msg.getStatus().equals("pending"))) ? true : false;

	if (moderate_msg) {
	    if (chat_msg.getStatus().equals("pending")) {
		chat_msg.setMessageId(getNextMessageId()); // Assign next message id
		msg = chat_msg.toString();
	    }
	}

	System.out.println("In broadcast: " + msg);
	broadcastAppletOnly(msg, room_id);
	broadcastAolOnly(msg, room_id);

    }
}






