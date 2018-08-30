import java.io.Serializable;

public class adUserInfo implements Serializable{
    public String user_id = null;
    public String user_name = null;
    public boolean moderator = false;

    public adUserInfo(String user_id, String user_name) {
	this.user_id = user_id;
	this.user_name = user_name;
    }

    public adUserInfo(String user_id, String user_name, boolean moderator) {
	this.user_id = user_id;
	this.user_name = user_name;
	this.moderator = moderator;
    }
}
