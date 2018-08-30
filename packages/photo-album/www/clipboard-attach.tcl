# /packages/photo-album/www/clipboard-attach.tcl
ad_page_contract {

    Add a photo to one of your clipboards (or create a new one if either 
    asked for or none exist).  Requires registration.                                           
    
    @author Jeff Davis davis@xarg.net
    @creation-date 10/30/2002
    @cvs-id $Id: clipboard-attach.tcl,v 1.4 2014/08/07 07:59:50 gustafn Exp $
} {
    photo_id:naturalnum,notnull
    collection_id:naturalnum,notnull
}

auth::require_login

set user_id [ad_conn user_id]
set peeraddr [ad_conn peeraddr]
set context [ad_conn package_id]

if {$collection_id < 0} { 
    ad_returnredirect "clipboard-ae?photo_id=$photo_id"
    ad_script_abort
} 

# If we got collection_id 0 then we need to create a "General" clipboard 
if {$collection_id == 0} {
    set title "General"
    
    set collection_id [db_nextval acs_object_id_seq]

    if {[catch {db_exec_plsql new_collection {}} errMsg]} { 
        ad_return_error "Clipboard Insert error" "Error putting photo into clipboard (query name new_collection)<pre>$errMsg</pre>"
    }
}

if {$collection_id > 0} { 
    if {[catch {db_dml map_photo {}} errMsg]} { 
        # Check if it was a pk violation (i.e. already inserted)
        if {![string match "*pa_collection_photo_map_pk*" $errMsg]} { 
            ad_return_error "Clipboard Insert error" "Error putting photo into clipboard (query name map_photo)<pre>$errMsg</pre>"
            ad_script_abort
        }
    }
}

ad_returnredirect "photo?photo_id=$photo_id&collection_id=$collection_id"
