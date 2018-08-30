# /packages/calendar/www/cal-item.tcl

ad_page_contract {
    
    Output an item as ics for Outlook
    
    @author Ben Adida (ben@openforce.net)
    @creation-date May 28, 2002
    @cvs-id $Id: cal-item-outlook.tcl,v 1.5.2.1 2015/09/10 08:30:15 gustafn Exp $
} {
    cal_item_id:naturalnum,notnull
}

ad_returnredirect "ics/${cal_item_id}.ics"

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
