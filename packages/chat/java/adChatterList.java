import java.awt.*;
import java.awt.event.*;
import java.util.*;

class adUserInfoExt extends adUserInfo {

    public boolean ignore = false;

    public adUserInfoExt(String user_id, String user_name) {
        super(user_id, user_name);
    }

}
class adChatterListLayout implements LayoutManager {
    public void addLayoutComponent(String name, Component comp) {}

    public void removeLayoutComponent(Component comp) {}

    public Dimension preferredLayoutSize(Container parent) {
        synchronized (parent.getTreeLock()) {

            Component[] c = parent.getComponents();

            if (c == null)
                return new Dimension();

            Dimension d = null;
            // Only have one component.
            for (int i = 0; i < c.length; i++) {
                d = c[i].getSize();

            }

            return d;
      
        }
    }

    public Dimension minimumLayoutSize(Container parent) {
        return preferredLayoutSize(parent);
    }

    public void layoutContainer(Container parent) {}

}

class adChatterScrollPane extends ScrollPane {
    private Image offscr_image = null;

    private adChatterList chatter_list = null;
    public adChatterScrollPane() {
        chatter_list = new adChatterList(null);
        chatter_list.setBounds(0, 0, 100, 390);
        add(chatter_list);

    }

    public void addChatter(String name) {
        chatter_list.addChatter(new adUserInfoExt("1", name));
        chatter_list.repaint();
        chatter_list.invalidate();
    }

    public void paint(Graphics g) {
        if (offscr_image == null) 
            offscr_image = createImage(getSize().width, getSize().height);

        Graphics offscr_graphics = offscr_image.getGraphics();
        offscr_graphics.clearRect(0, 0, getSize().width, getSize().height);
        System.out.println(this + "paint()");
        super.paint(offscr_graphics);
        
        g.drawImage(offscr_image, 0, 0, this);

    }

    public void update(Graphics g) {
        paint(g);
    }

}
public class adChatterList extends Container 
    implements MouseListener, AdjustmentListener {
    /**
     * Icon dimension
     */
    private final static int ICON_WIDTH  = 32;
    private final static int ICON_HEIGHT = 32;

    private final static int GAP_H = 2; // Space in pixels between icon and text
    private final static int GAP_V = 2; // Gap between two name labels

    private final static int INSET_X = 2;
    private final static int INSET_Y = 2;

    private final static int SCROLLBAR_WIDTH = 20;
    private int select_index = -1;

    Image icon = null;

    private Image ignore_icon = null;
    private Vector user_list = null;
    private Image offscr_image = null;
    private Dimension d = null;

    private int width = 0;
    private int height = 0;

    private Scrollbar v_scrollbar = null;
    private Scrollbar h_scrollbar = null;
    private int num_of_displays = -1;
    private int start_idx = 0;

    public adChatterList(Image icon) {
        user_list = new Vector();
        this.icon = icon;
        //icon = getToolkit().getImage("fish2.gif");
        //ignore_icon = getToolkit().getImage("ignore.gif");
        addMouseListener(this);

        v_scrollbar = new Scrollbar(Scrollbar.VERTICAL);
        h_scrollbar = new Scrollbar(Scrollbar.HORIZONTAL);

        v_scrollbar.setVisible(false);
        v_scrollbar.addAdjustmentListener(this);
        setLayout(null);

        add(v_scrollbar);

    }

    public adUserInfo getSelectedItem() {
        if (select_index < 0 || select_index > user_list.size())
            return null;

        return (adUserInfo) user_list.elementAt(select_index);
    }

    private void initialize() {
        d = getSize();
        
        v_scrollbar.setBounds(d.width - SCROLLBAR_WIDTH, 0, SCROLLBAR_WIDTH, d.height);

        num_of_displays = d.height / (ICON_HEIGHT + 2 * INSET_Y + GAP_V);
        v_scrollbar.setVisibleAmount(num_of_displays);

        System.out.println("Num of display=" + num_of_displays);
    }
    public void addChatter(adUserInfo user_info) {

        if (d == null)
            initialize();

        user_list.addElement(user_info);

        if (user_list.size() > num_of_displays) {
            v_scrollbar.setVisible(true);
            v_scrollbar.setMaximum(user_list.size());
        } else
            v_scrollbar.setVisible(false);


        repaint();
    }

    public void removeChatter(adUserInfo user_info) {
        // Need to optimized this method.
        
        // first look through the whole list for the same user id.
        for (int i = 0; i < user_list.size(); i++) {
            adUserInfo obj = (adUserInfo) user_list.elementAt(i);
            if (obj.user_id.equals(user_info.user_id)) {
                user_list.removeElement(obj);
                return;
            }
        }
            
        return;
    }

    public void paint(Graphics g) {

        if (d == null)
            initialize();

        g.setColor(getBackground());
        g.fillRect(0, 0, getSize().width, getSize().height);
        /**
         * Draw border around the component
         */
        g.setColor(Color.gray);
        g.draw3DRect(0, 0, d.width - 1, d.height - 1, false);
        g.draw3DRect(1, 1, d.width - 2, d.height - 2, false);

        /**
         * End drawing border
         */

        int x = 2;
        int y = 2;

        
        for (int i = start_idx; (i < user_list.size()) && (i < start_idx + num_of_displays); i++) {
            if (select_index == i) {
                g.setColor(Color.blue);
                g.fillRect(x, y, d.width, ICON_HEIGHT + 2 * INSET_Y);
                g.setColor(Color.white);
            } else {
                /*AGUSTIN*/
                g.setColor(Color.white);
                g.fillRect(x, y, d.width, ICON_HEIGHT + 2 * INSET_Y);
                g.setColor(Color.black);
            }
            adUserInfoExt user_info = (adUserInfoExt) user_list.elementAt(i);
            g.drawImage(icon, x + INSET_X, y + INSET_Y, ICON_WIDTH, ICON_HEIGHT, this);
            if (user_info.ignore) {
                g.setColor(Color.red);
                g.drawLine(x + INSET_X, y + INSET_Y, x + INSET_X + ICON_WIDTH, y + INSET_Y + ICON_HEIGHT);
                g.drawLine(x + INSET_X + ICON_WIDTH, y + INSET_Y, x + INSET_X, y + INSET_Y + ICON_HEIGHT);
            }
            //g.drawImage(ignore_icon, x + INSET_X, y + INSET_Y, ICON_WIDTH, ICON_HEIGHT, this);
            g.drawString(user_info.user_name, x + INSET_X + ICON_WIDTH + GAP_H, y + 20);
            y += (ICON_HEIGHT + 2 * INSET_Y + GAP_V);
        }
        super.paint(g);

    }
    public Dimension getPreferredSize() {
        return getSize();
    }
    
    public void update(Graphics g) {
        System.out.println(this + "update()");
        paint(g);
    }
    public void mouseClicked(MouseEvent e) {

    }

    public void mouseEntered(MouseEvent e) {
    }

    public void mouseExited(MouseEvent e) {
    }

    public void mousePressed(MouseEvent e) {
      Point pt = e.getPoint();
      select_index = pt.y / (ICON_HEIGHT + 2 * INSET_Y + GAP_V);
      repaint();
    }

    public void mouseReleased(MouseEvent e) {
    }

    public void adjustmentValueChanged(AdjustmentEvent e) {
        start_idx = e.getValue();
        repaint();
    }
    public static void main(String args[]) {
        Frame f = new Frame();

        //final adChatterScrollPane sp = new adChatterScrollPane();
        final adChatterList sp = new adChatterList(null);
        sp.setBounds(15, 50, 200, 390);
        Button add = new Button("add");
        add.setBounds(320, 60, 50, 30);
        add.addActionListener(new ActionListener() {
                private int count = 0;
                public void actionPerformed(ActionEvent e) {
                    sp.addChatter(new adUserInfo("1", "David" + (count++)));
                }
            });

        f.setLayout(null);
        f.add(sp);
        f.add(add);
        f.setSize(570, 400);

        f.addWindowListener(new WindowAdapter() {
                public void windowClosing(WindowEvent e) {
                    System.exit(0);
                }
            });

        f.show();
        
    }
}








