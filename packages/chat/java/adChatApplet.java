import java.io.*;
import java.net.*;
import java.util.*;
import java.awt.*;
import java.awt.event.*;
import java.applet.*;

/**
 * Applet client.
 *
 *   @author David Dao (ddao@arsdigita.com)
 *   @creation-date November 17, 2000
 *   @cvs-id $Id: adChatApplet.java,v 1.2 2006/03/14 12:16:08 emmar Exp $
 *   <HTML>
 *   <body>
 *   <applet code=adChatApplet.class width=500 height=500></applet>
 *   </body>
 *   </html>
 */
public class adChatApplet extends Applet implements ActionListener, adChatClient{

    //private TextArea text_area = null;
    private Panel text_area_panel = null;
    private ScrollPane text_area = null;
    private TextField text_field = null;
    private Button send_button = null;
    private Button logoff_button = null;
    private Button private_button = null;
    private Button ignore_button = null;

    private adChatterList chatter_list = null;
    private adChatClientListener listener = null;
    private adChatClientInfo client_info = null;
    private String user_id;
    private String user_name;
    private String room_id;

    private boolean moderated_room;

    private int format_msg_width;
    private Dimension applet_size = null;

    private static int GAP = 5;

    private static String PersonImage = "person.gif";

    // Key for this hash table is from_user_id:to_user_id
    private Hashtable private_chat_frames = null;
    // Key for this hash table is user_id
    private Hashtable ignore_user_list = null; 

    private Hashtable moderate_msgs = null;

   public static String replace (String target, String from, String to) {   
     // target is the original string
     // from   is the string to be replaced
     // to     is the string which will used to replace
     int start = target.indexOf (from);
     if (start==-1) return target;
     int lf = from.length();
     char [] targetChars = target.toCharArray();
     StringBuffer buffer = new StringBuffer();
     int copyFrom=0;
     while (start != -1) {
       buffer.append (targetChars, copyFrom, start-copyFrom);
       buffer.append (to);
       copyFrom=start+lf;
       start = target.indexOf (from, copyFrom);
       }
     buffer.append (targetChars, copyFrom, targetChars.length-copyFrom);
     return buffer.toString();
     }

    /**
     * Initialize applet.
     */
    public void init() {
        super.init();

        /**
         * Getting server information.
         */
        client_info = new adChatClientInfo();
        client_info.host = getParameter("host");
        client_info.port = Integer.parseInt(getParameter("port"));


        //client_info.host = "localhost";
        //client_info.port = 8202;

        /** 
         * First get user_id, user_name, room_id
         */
        client_info.user_id = getParameter("user_id");
        client_info.user_name = getParameter("user_name");
        client_info.room_id = getParameter("room_id");

        // Temporary store moderator value in the applet.
        if (getParameter("moderator") != null)
            client_info.moderator = true;

        //client_info.user_id = "1";
        //client_info.user_name = "David";
        //client_info.room_id = "1";

        applet_size = getSize();

        private_chat_frames = new Hashtable();
        ignore_user_list = new Hashtable();
        moderate_msgs = new Hashtable();

        /** 
         * Calculate dimension for each chat component.
         */
        int text_field_height = 40;
        int text_area_width = (applet_size.width - 3 * GAP ) * 7 / 10;
        
        int text_area_height = applet_size.height - 3 * GAP - text_field_height;
        int text_area_x = GAP;
        int text_area_y = GAP;

        format_msg_width = text_area_width;

        int text_field_width = text_area_width;
        int text_field_x = GAP;
        int text_field_y = text_area_y + text_area_height + GAP;

        int chat_list_width = (applet_size.width - 3 * GAP) * 3 / 10;
        int chat_list_height = text_area_height - 30;
        int chat_list_x = text_area_x + text_area_width + GAP;
        int chat_list_y = GAP;

        int private_button_x = chat_list_x;
        int private_button_y = chat_list_y + chat_list_height + GAP;
        int private_button_width = 80;
        int private_button_height = 25;

        int ignore_button_width = 50;
        int ignore_button_height = 25;
        int ignore_button_x = chat_list_x + private_button_width + GAP;
        int ignore_button_y = private_button_y;

        int send_button_x = chat_list_x;
        int send_button_y = text_field_y;
        int send_button_width = 50;
        int send_button_height = text_field_height;

        int logoff_button_width = 70;
        int logoff_button_height = text_field_height;
        int logoff_button_x = applet_size.width - GAP - logoff_button_width;
        int logoff_button_y = text_field_y;

        /**
         * End calculate dimension.
         */

        // Just a quick solution to support moderate chat. Need to plan this more careful.

        if (getParameter("room_moderated") == null)
            moderated_room = false;
        else
            moderated_room = true;
        /*
        if (getParameter("moderator") == null)
            moderator = false;
        else
            moderator = true;
        */

        /**
         * GUI Layout Design
         */
        setLayout(null);
        text_area = new ScrollPane();
        //text_area = new TextArea();
        //text_area.setEditable(false);
        text_area.setBounds(text_area_x, text_area_y, text_area_width, text_area_height);
        text_area.setBackground(Color.white);

        text_area_panel = new Panel();
        text_area_panel.setLayout(new OneColumnLayout());
        //text_area_panel.setBounds(text_area_x, text_area_y, text_area_width, text_area_height);
        text_area.add(text_area_panel);

        text_field = new TextField(50);
        text_field.setBounds(text_field_x, text_field_y, text_field_width, text_field_height);
        text_field.addActionListener(this);
        text_field.setBackground(Color.white);
        Image icon = getImage(getDocumentBase(), PersonImage);
        chatter_list = new adChatterList(icon);
        chatter_list.setBounds(chat_list_x, chat_list_y, chat_list_width, chat_list_height);
        chatter_list.setBackground(Color.white);

        send_button = new Button("Send");
        send_button.setBounds(send_button_x, send_button_y, send_button_width, send_button_height);
        send_button.addActionListener(this);
        send_button.setBackground(null);

        logoff_button = new Button("Log off");
        logoff_button.setBounds(logoff_button_x, logoff_button_y, logoff_button_width, logoff_button_height);
        logoff_button.setForeground(Color.red);
        logoff_button.setBackground(null);
        logoff_button.addActionListener(this);
        
        private_button = new Button("Private");
        private_button.setBounds(private_button_x, private_button_y, private_button_width, private_button_height);
        private_button.addActionListener(this);

        ignore_button = new Button("Ignore");
        ignore_button.setBounds(ignore_button_x, ignore_button_y, ignore_button_width, ignore_button_height);
        ignore_button.addActionListener(this);

        add(text_area);
        //add(text_area_panel);
        add(text_field);
        add(chatter_list);
        add(send_button);
        add(logoff_button);
        add(private_button);
        add(ignore_button);

        // Set applet background.
        setBackground(Color.white);
        /**
         * End GUI Layout
         */
    }

    public void destroy() {
        System.out.println("Destroy invoked");
        listener.disconnect();
        super.destroy();
    }

    public void stop() {
        System.out.println("Stop invoked");
        listener.disconnect();
        super.stop();
    }

    /**
     * Spawn a separate thread and listen for new message from the room.
     */
    public void start() {
        super.start();
        listener = new adChatClientListener(this, client_info);
    }

    private void postMessage() {
        if (!text_field.getText().equals("")) {
            listener.postMessage(text_field.getText());
            text_field.setText("");
            //text_field.setText(text_field.getText());
        }
    }

    public void actionPerformed(ActionEvent e) {
        Object src = e.getSource();

        if (src == text_field || src == send_button) 
            postMessage();
        else if (src == private_button) {
            adUserInfo user_info = chatter_list.getSelectedItem();

            if (user_info != null) {
                // Ignore private message from user in ignore list.
                
                if (ignore_user_list.containsKey(user_info.user_name))
                    return;
                String key = user_info.user_name;
                adPrivateChatFrame f = (adPrivateChatFrame)private_chat_frames.get(key);
                System.out.println("Frame f = " + f + ", key = " + key);
                if (f == null) {
                    f = new adPrivateChatFrame(new adUserInfo(client_info.user_id, client_info.user_name), user_info, room_id, listener);
                    f.show();
                    private_chat_frames.put(key, f);
                } else {
                    f.show();
                    f.toFront();
                }
            }
        }
        else if (src == logoff_button) {
            URL exitURL = null;
            try 
              {
              exitURL = new URL(replace (getCodeBase().toString(), "/chat", ""));
              //ERROR in IExplorer: http://support.microsoft.com/kb/884763
              //workaround?
              getAppletContext().showDocument(exitURL);
              } 
            catch (MalformedURLException ex) 
              {
              System.out.println("Could not exit Chat to URL " + exitURL.toString());
              }           
        }
        else if (src == ignore_button) {
            adUserInfo user_info = chatter_list.getSelectedItem();

            if (user_info != null) {
                // If the key already in user ignore list then click on ignore again will remove
                // user from the ignore list.

                if (ignore_user_list.containsKey(user_info.user_name)) {
                    ignore_user_list.remove(user_info.user_name); // Remove this user from ignore list.
                    ((adUserInfoExt) user_info).ignore = false;
                } else {
                    System.out.println("Ignore user [" + user_info.user_name +"]");
                    ignore_user_list.put(user_info.user_name, user_info.user_id); // Add this user to ignore list.
                    ((adUserInfoExt) user_info).ignore = true;
                }
                chatter_list.invalidate();
                chatter_list.repaint();
            }
        }
        
    }

    /**
     * New message arrive from this room.
     */
    public void receiveMessage(String msg) {
        System.out.println("receivedMessage [" + msg + "]");
        //String system = adChatSimpleXMLParser.getTag(msg, "system");

        if (adChatSimpleXMLParser.containTag(msg, "system")) {
            adChatSystemMessage system_message = new adChatSystemMessage(msg);
            if (system_message.getType() == adChatSystemMessage.USER_ENTER) {
                //text_area_panel.add(new adChatFormatMessage(format_msg_width, system_message.getUserName(0), " has entered the room"));
                //text_area_panel.repaint();
                
                //text_area_panel.validate();
                //text_area.validate(); 
            } else if (system_message.getType() == adChatSystemMessage.USER_LEAVE) {
                //text_area_panel.add(new adChatFormatMessage(format_msg_width, system_message.getUserName(0), " has leave the room"));
                //text_area_panel.repaint();
                
                //text_area_panel.validate();
                //text_area.validate(); 
                chatter_list.removeChatter(new adUserInfo(system_message.getUserId(0), system_message.getUserName(0)));
                return;
            }

            //System.out.println("List count = " + system_message.getListCount());
            for (int i = 0; i < system_message.getListCount(); i++)
                chatter_list.addChatter( new adUserInfoExt(system_message.getUserId(i), system_message.getUserName(i)) );

            return;
        }           
        adChatMessage chat_message = new adChatMessage(msg);

        // This is not a valid chat message.
        if (!chat_message.isValid())
            return;

        // If user is in ignore list then discard message from this user.
        if (ignore_user_list.containsKey(chat_message.getFromUser()))
            return;

        if (chat_message.getToUser() != null) {  // Private conversation

            String key = chat_message.getFromUser();
            adPrivateChatFrame f = (adPrivateChatFrame) private_chat_frames.get(key);
            System.out.println("Frame receive f = " + f + ", key = " + key);

            if (f == null){
                f = new adPrivateChatFrame(new adUserInfo(client_info.user_id, client_info.user_name), new adUserInfo(user_id, chat_message.getFromUser()), room_id, listener);

                private_chat_frames.put(key, f);
            }
            f.show();
            f.receiveMessage(chat_message.getFromUser(), chat_message.getBody());
            return;
           
        } 
        // TODO: 
        boolean moderate = (chat_message.getStatus() != null && chat_message.getStatus().equals("pending")) ? true : false;
        adChatFormatMessage frm_msg = new adChatFormatMessage(format_msg_width, listener, msg);
        //adChatFormatMessage frm_msg = new adChatFormatMessage(listener, chat_message.getFromUser(), chat_message.getBody(), moderate);
        if (moderate) {
            // Put moderate msg in the hash table.
            if (chat_message.getMessageId() != null) {
                moderate_msgs.put(chat_message.getMessageId(), frm_msg);
            }
        }
        if (!moderate && chat_message.getMessageId() != null) {
            // The message is approve moderate message.
            adChatFormatMessage m = (adChatFormatMessage) moderate_msgs.get(chat_message.getMessageId());
            if (m != null)
                m.setVisible(false);

        }
        if (chat_message.getStatus() != null && !chat_message.getStatus().equals("rejected"))
            text_area_panel.add(frm_msg);
        text_area_panel.repaint();

        text_area_panel.validate();
        text_area.validate();   

    }

    public void disconnect() {
        listener.disconnect();
    }

    

    public static void main(String args[]) {
        Frame f = new Frame();
        if (args.length < 3) {
            System.out.println("Usage: java adChatClient user_id user_name room_id");
            return;
        }
        //Panel client_interface = new adChatClient(args[0], args[1], args[2]);
        Panel client_interface = new adChatApplet();
        f.add(client_interface);
        f.setSize(570, 400);
        f.addWindowListener(new WindowAdapter() {
                public void windowClosing(WindowEvent e) {
                    System.exit(0);
                }
            });

        f.show();
    }
}

















