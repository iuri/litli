import java.awt.*;
import java.awt.event.*;
import java.util.*;

/**
 *
 *
 *  @author David Dao (ddao@arsdigita.com)
 *  @creation-date December 5, 2000
 *  @cvs-id $Id: adChatFormatMessage.java,v 1.2 2006/03/14 12:16:08 emmar Exp $
 */
public class adChatFormatMessage extends Container implements ActionListener{
    private static int GAP = 2;
    private Dimension d = null;
    private int width = 400;
    private int height = 40;
    private int button_width = 20;
    private int button_height = 20;
    private int char_height = -1;

    private String font_name = "Helvetica";
    private int font_size = 12;
    
    private Font font_normal = null;
    private Font font_bold = null;

    private FontMetrics fm_normal = null;
    private FontMetrics fm_bold   = null;

    private int x = GAP;
    private int space = 4;
    private int user_name_width = -1;

    public String msg = "Test string this is a brand new test please enter some meaningful word string getting longer and longer and longer until the end. Test string for longer and longer and longer and longer and longer the end.";
    public String user_name = "David: ";
    public String user = null;
    public String message_id = null;
    public boolean moderated = false;
    private Vector line_break = new Vector();
    private adChatClientListener listener = null;

    private Button accept_button = null;
    private Button reject_button = null;
    public adChatFormatMessage(int width, String user_name, String message) {
        this(width, null, user_name, message, false);
    }

    // Msg is in XML format.
    public adChatFormatMessage(int width, adChatClientListener listener, String msg) {
        
        adChatMessage chat_message = new adChatMessage(msg);
        moderated = (chat_message.getStatus() != null && chat_message.getStatus().equals("pending")) ? true : false;
        this.width = width;
        this.listener = listener;
        this.user_name = chat_message.getFromUser() + ": ";
        this.user = chat_message.getFromUser();
        this.msg = chat_message.getBody();
        message_id = chat_message.getMessageId();
        initialize();
    }

    public adChatFormatMessage(int width, adChatClientListener listener, String user_name, String message, boolean moderated) {
        this.moderated = moderated;
        this.listener = listener;
        this.width = width;


        this.user_name = user_name + ":   ";
        this.user = user_name;
        msg =message;

        initialize();

    }

    private void initialize() {
        d = new Dimension(width, height);
        /**
         * Create two fonts using in the chat message.
         */
        font_normal = new Font(font_name, Font.PLAIN, font_size);
        font_bold   = new Font(font_name, Font.BOLD,  font_size);

        Toolkit toolkit = Toolkit.getDefaultToolkit();
        fm_normal = toolkit.getFontMetrics(font_normal);
        fm_bold   = toolkit.getFontMetrics(font_bold);

        setLayout(null); // Set component layout manually.

        //System.out.println("Font normal = " + font_normal);
        //System.out.println("Font bold   = " + font_bold);
        //System.out.println("fm_normal   = " + fm_normal);
        
        char_height = fm_normal.getHeight();

        button_width  = char_height + GAP * 2;
        button_height = char_height + GAP * 2;

        user_name_width = fm_bold.stringWidth(user_name);

        /**
         * Add accept/reject button for each moderate message.
         */
        if (moderated) {
            accept_button = new Button("A");
            accept_button.setFont(font_normal);
            accept_button.setBounds(GAP, GAP, button_width, button_height);
            accept_button.setForeground(Color.green);
            accept_button.addActionListener(this);
            add(accept_button);
            
            reject_button = new Button("R");
            reject_button.setFont(font_normal);
            reject_button.setBounds(button_width + 2* GAP, GAP, button_width, button_height);
            reject_button.setForeground(Color.red);
            reject_button.addActionListener(this);
            add(reject_button);

            x += (2 * button_width + 2 * GAP);
        }

        d.height = button_height + 2 * GAP;

        calculateLineBreak();
        repaint();
    }

    /**
     * Pre calculate where each line break using this font.
     */
    private void calculateLineBreak() {
        int current_length = x + user_name_width;
        for (int i = 0; i < msg.length(); i++) {
            current_length += fm_normal.charWidth(msg.charAt(i));
            
            if (current_length > d.width) {
                //System.out.println("Char = " + msg.charAt(i) + ", current_length = " + current_length);
                current_length = GAP + fm_normal.charWidth(msg.charAt(i));
                line_break.addElement(new Integer(i - 1));
                
                d.height += char_height;
            }
        }
        line_break.addElement(new Integer(msg.length()));
    }

    public void paint(Graphics g) {
        /*AGUSTIN*/
        /*g.setColor(Color.lightGray);*/
        g.setColor(Color.white);
        g.fillRect(0, 0, d.width, d.height - 5);
        
        /**
         * Draw user name.
         */
        g.setFont(font_bold);
        g.setColor(Color.blue);
        g.drawString(user_name, x, GAP + char_height);

        /**
         * Draw regular message.
         */        
        g.setFont(font_normal);
        g.setColor(Color.black);
        int start_offset = 0;
        int x_loc = x + user_name_width + space;
        int y_loc = GAP + char_height;
        for (int i = 0; i < line_break.size(); i++) {
            int end_offset = ((Integer) line_break.elementAt(i)).intValue();
            //System.out.println("[" + start_offset +", " + end_offset + "] = " + msg.substring(start_offset, end_offset));

            g.drawString(msg.substring(start_offset, end_offset), x_loc, y_loc);
            start_offset = end_offset;
            x_loc = GAP;
            y_loc += char_height;
        }
    }

    public Dimension getPreferredSize() {
        return d;
    }

    public void actionPerformed(ActionEvent e) {
        Object src = e.getSource();
        
        if (listener != null) {
            if (src == accept_button)
                listener.approveModerateMessage(user, message_id, msg);     
            else if (src == reject_button)
                listener.rejectModerateMessage(user, message_id, msg);
        }
        //if (listener != null)
        //    listener.postMessage(msg);
        //if (listener != null)
        //    listener.approveModerateMessage(user, message_id, msg);
        setVisible(false);
    }

    public static void main(String args[]) {
        Frame f = new Frame();
        ScrollPane scroll = new ScrollPane();
        Panel main = new Panel();
        /*
        main.setLayout(new OneColumnLayout());
        main.add(new adChatFormatMessage(false));
        main.add(new adChatFormatMessage(false));
        
        main.add(new adChatFormatMessage(true));
        main.add(new adChatFormatMessage(false));
        main.add(new adChatFormatMessage(true));
        main.add(new adChatFormatMessage(false));
        main.add(new adChatFormatMessage(true));
        main.add(new adChatFormatMessage(false));
        main.add(new adChatFormatMessage(true));
        main.add(new adChatFormatMessage(false));
        main.add(new adChatFormatMessage(true));
        main.add(new adChatFormatMessage(false));
        main.add(new adChatFormatMessage(true));
        main.add(new adChatFormatMessage(false));
        main.add(new adChatFormatMessage(true));
        main.add(new adChatFormatMessage(false));
        main.add(new adChatFormatMessage(true));
        main.add(new adChatFormatMessage(false));
        main.add(new adChatFormatMessage(true));
        main.add(new adChatFormatMessage(false));
        main.add(new adChatFormatMessage(true));
        main.add(new adChatFormatMessage(false));
        main.add(new adChatFormatMessage(true));
        main.add(new adChatFormatMessage(false));
        main.add(new adChatFormatMessage(true));
        main.add(new adChatFormatMessage(false));
        main.add(new adChatFormatMessage(true));
        main.add(new adChatFormatMessage(false));
        main.add(new adChatFormatMessage(true));
        main.add(new adChatFormatMessage(false));
        main.add(new adChatFormatMessage(true));
        main.add(new adChatFormatMessage(false));
        main.add(new adChatFormatMessage(true));
        main.add(new adChatFormatMessage(false));
        main.add(new adChatFormatMessage(true));
        main.add(new adChatFormatMessage(false));
        main.add(new adChatFormatMessage(true));
        main.add(new adChatFormatMessage(false));
        main.add(new adChatFormatMessage(true));
        main.add(new adChatFormatMessage(false));
        main.add(new adChatFormatMessage(true));
        main.add(new adChatFormatMessage(false));
        */
        scroll.add(main);
        f.add(scroll);
        f.setSize(400,400);
        f.addWindowListener(new WindowAdapter() {
                public void windowClosing(WindowEvent e) {
                    System.exit(1);
                }
            });
        f.show();       
    }
}

class OneColumnLayout implements LayoutManager {

    private int hgap = 2;
    public void addLayoutComponent(String name, Component comp) {
    }

    public void removeLayoutComponent(Component comp) {

    }

    public Dimension preferredLayoutSize(Container parent) {
        return calculateLayoutSize(parent);
    }

    public Dimension minimumLayoutSize(Container parent) {
        return calculateLayoutSize(parent);
    }
    
    public void layoutContainer(Container parent) {
        //System.out.println(this + "::layoutContainer");
        synchronized (parent.getTreeLock()) {
            int nmembers = parent.getComponentCount();
            int x = 0;
            int y = 0;
            for (int i = 0; i < nmembers; i++) {
                Component m = parent.getComponent(i);
                if (m.isVisible()) {
                    Dimension d = m.getPreferredSize();
                    m.setBounds(x, y, d.width, d.height);
                    y += (d.height + hgap);
                }
            }
        }
    }

    private Dimension calculateLayoutSize(Container parent) {
        Dimension dim = new Dimension(0, 0);
        synchronized (parent.getTreeLock()) {
            int nmembers = parent.getComponentCount();

            for (int i = 0; i < nmembers; i++) {
                Component m = parent.getComponent(i);
                if (m.isVisible()) {
                    Dimension d= m.getPreferredSize();
                    dim.height += (d.height + hgap);
                    if (i == 0)
                        dim.width = d.width;
                }
            }
            return dim;
        }
    }
}







