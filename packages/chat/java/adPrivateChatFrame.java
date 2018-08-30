import java.awt.*;
import java.awt.event.*;

/**
 * This frame pop up for each private chat.
 * Currently the whole frame is static in size. Later need to make it resizable.
 */
public class adPrivateChatFrame extends Frame implements ActionListener{

    private static int GAP = 5;

    private Panel p = null;

    //private TextArea text_area = null;
    private ScrollPane text_area = null;
    private Panel text_area_panel = null;
    private TextField text_field = null;
    private Button send_button = null;
    private adUserInfo sender = null;
    private adUserInfo receiver = null;
    private String room_id = null;
    private adChatClientListener listener = null;
    private int format_msg_width;
    public adPrivateChatFrame(adUserInfo sender, adUserInfo receiver, String room_id, adChatClientListener listener) {
        super("Conversar --> " + receiver.user_name);
        this.sender = sender;
        this.receiver = receiver;
        this.listener = listener;
        this.room_id = room_id;

        setSize(400, 400);
        setResizable(false);

        p = new Panel();
        p.setSize(390, 350);

        p.setLayout(null);

        Dimension size = p.getSize();

        int text_field_height = 40;
        int send_button_width = 40;

        int text_area_x = GAP;
        int text_area_y = GAP;
        int text_area_width = size.width - 2 * GAP;
        format_msg_width = text_area_width;

        int text_area_height = size.height - 3 * GAP - text_field_height;
        
        int text_field_x = GAP;
        int text_field_y = text_area_y + text_area_height + GAP;
        int text_field_width = size.width - 3 * GAP - send_button_width;
        int send_button_x = text_field_x + text_field_width + GAP;
        int send_button_y = text_field_y;
        int send_button_height = text_field_height;

        //text_area = new TextArea();
        text_area = new ScrollPane();
        text_area.setBounds(text_area_x, text_area_y, text_area_width, text_area_height);

        text_area_panel = new Panel();
        text_area_panel.setLayout(new OneColumnLayout());
        text_area.add(text_area_panel);
        text_field = new TextField(50);
        text_field.setBounds(text_field_x, text_field_y, text_field_width, text_field_height);
        text_field.addActionListener(this);

        send_button = new Button("Enviar");
        send_button.setBounds(send_button_x, send_button_y, send_button_width, send_button_height);
        send_button.addActionListener(this);

        p.add(text_area);
        p.add(text_field);
        p.add(send_button);

        add(p);
        enableEvents(AWTEvent.WINDOW_EVENT_MASK);
    }

    protected void processWindowEvent(WindowEvent e) {
        if (e.getID() == WindowEvent.WINDOW_CLOSING) {
            
            // Clear all previous messages.
            //text_area.setText("");
            dispose();
        }

    }

    private void postMessage() {
        
        if (!text_field.getText().equals("")) {
            receiveMessage(sender.user_name, text_field.getText());

            listener.postPrivateMessage(receiver.user_name, text_field.getText());

            text_field.setText("");
        }
        
    }

    public void actionPerformed(ActionEvent e) {
        Object src = e.getSource();

        if (src == text_field || src == send_button) 
            postMessage();


    }

    public void receiveMessage(String user_name, String msg) {
        if (user_name == null)
            user_name = "Unknown";

        text_area_panel.add(new adChatFormatMessage(format_msg_width, user_name, msg));
        text_area_panel.repaint();
        text_area_panel.validate();
        text_area.validate();
                            
        //text_area.append(msg);
        //text_area.append("\n");
        
    }
}







