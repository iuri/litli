# /packages/news/www/admin/approve.tcl

ad_page_contract {

    News-admin approves a list of items for publication
    has to set the  publish_date and optionally the archive_date.

    @author Stefan Deusch (stefan@arsdigita.com)
    @creation-date 2000-12-20
    @cvs-id $Id: approve.tcl,v 1.7.4.2 2016/01/02 20:34:50 gustafn Exp $

} {
    n_items:notnull
    {revision_id: ""}
    {return_url: ""}
} -properties {
    
    items:multirow
    title:onevalue
    context:onevalue
    publish_date_select:onevalue
    archive_date_select:onevalue
    hidden_vars:onevalue
}


set title [_ news.Approve_items]
set context [list $title]


# pre-set date widgets with defaults
set active_days [parameter::get -parameter ActiveDays -default 14]
set proj_archival_date [db_string week {}]
set publish_date_select [dt_widget_datetime -default now publish_date days]
set archive_date_select [dt_widget_datetime -default $proj_archival_date archive_date days]

# produce bind_id_list     
for {set i 0} {$i < [llength $n_items]} {incr i} {
    set id_$i [lindex $n_items $i]
    lappend bind_id_list ":id_$i"
}


# get most likely revision_id if not supplied
if {$revision_id eq ""} {
    set revision_select [db_map revision_select]
} else {
    set revision_select "'$revision_id' as revision_id,"
}

db_multirow items item_list "
        select    
        item_id, 
        $revision_select
        publish_title,
        creation_date,
        item_creator
    from 
        news_items_live_or_submitted
    where 
        item_id in ([join $bind_id_list ","])"


set hidden_vars [export_vars -form {return_url}]

ad_return_template







# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
