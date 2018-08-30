
/**
 * This class contains very simple methods that parse out 
 * xml chat message. This class is not intend to use for
 * complicate xml.
 *
 * @author David Dao (ddao@arsdigita.com)
 * @creation-date December 6, 2000
 * @cvs-id $Id: adChatSimpleXMLParser.java,v 1.2 2006/03/14 12:16:08 emmar Exp $
 */
public class adChatSimpleXMLParser {
    public static String removeTag(String str, String tag) {
        String ret = str;
        
        int start_index = str.indexOf("<" + tag + ">");
        
        if (start_index >= 0) {
            int end_index = str.indexOf("</" + tag + ">");
            if (end_index >= 0) {

                ret = str.substring(0, start_index);
                ret = ret.concat(str.substring(end_index + 3 + tag.length(), str.length()));
            }
        }
        
        return ret;
    }

    public static String getTag(String str, String tag) {
        String ret = null;
        
        int start_index = str.indexOf("<" + tag + ">");
        
        if (start_index >= 0) {
            int end_index = str.indexOf("</" + tag + ">");
            if (end_index >= 0) {
                ret = str.substring(start_index + 2 + tag.length(), end_index);
            }
        }
        
        return ret;
    }

    public static boolean containTag(String str, String tag) {
        boolean ret = false;

        int start_index = str.indexOf("<" + tag + ">");
        if (start_index >= 0) {
            int end_index = str.indexOf("</" + tag + ">");
            if (end_index >= 0)
                ret = true;

        }
        
        return ret;
    }

}









