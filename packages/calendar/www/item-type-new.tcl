
ad_page_contract {

    Add an item type
    
    @author Ben Adida (ben@openforce.net)
    
    @creation-date Mar 16, 2002
    @cvs-id $Id: item-type-new.tcl,v 1.3.2.1 2015/09/10 08:30:15 gustafn Exp $
} {
    calendar_id:naturalnum,notnull
    type:notnull
}

# Permission check
permission::require_permission -object_id $calendar_id -privilege calendar_admin

# Add the type
calendar::item_type_new -calendar_id $calendar_id -type $type

ad_returnredirect "calendar-item-types?calendar_id=$calendar_id"



# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
