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
 * @cvs-id $Id: adChatServer.java,v 1.2 2006/03/14 12:16:08 emmar Exp $
 */
public class adChatServer {

    private int port;
    private int backlog = 50;
    private adChatDatasource datasource = new adChatDatasource();
    private boolean running = true;
    private ServerSocket server = null;

    public adChatServer(int port) {
        this.port = port;
    }

    /**
     * Listen for incoming java connection. For each connection
     * spawn a new thread.
     */
    public void start() {
        try {
            server = new ServerSocket(port);
            System.out.println("[" + new Date() + "] - Chat server listens on port " + port);
            while(running) {
                Socket incoming = server.accept();
                if (running) {
                    System.out.println("[" + new Date() + "] - Connection from " + incoming);
                    adClientSession session = new adClientSession(this, incoming);
                    session.start();
                }
            }
        } catch (IOException io) {
            // Server shut down normally.
        } catch (Exception e) {
            System.out.println("Socket server exception: " + e);
        }
        System.out.println("[" + new Date() + "] - Chat server shuts down.");
    }
    
    /**
     * Open tcp socket and send a bye message to the chat server.
     */
    public void stop() {
        try {
            Socket socket = new Socket(InetAddress.getLocalHost(), port);
            PrintWriter output = new PrintWriter(socket.getOutputStream(), true);           
            output.println("Bye");
            output.close();
        } catch (Exception e) {
            System.out.println("Exception in stoping server: " + e);
        }
    }

    /**
     * Shut down the current server.
     */
    public synchronized void shutdown() {
        running = false;
        try {
            if (server != null)
                server.close();
        } catch(Exception e) {}
    }

    public adChatDatasource getDatasource() {
        return datasource;
    }

    public InetAddress getInetAddress() {
        return server.getInetAddress();
    }

    public static void main(String[] args) {
        if (args.length < 2) {
            System.out.println("   Usuage: java adChatServer (start | stop) <port>");
            return;
        }
        int port = Integer.parseInt(args[1]);
        adChatServer server = new adChatServer(port);
        if (args[0].equals("start")) 
            server.start();
        else if (args[0].equals("stop"))
            server.stop();
        else 
            System.out.println("   Usuage: java adChatServer (start | stop) <port>");
        
    }
}







