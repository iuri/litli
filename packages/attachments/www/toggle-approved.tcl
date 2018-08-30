ad_page_contract {

    @author yon@openforce.net
    @creation-date 2002-08-29
    @cvs-id $Id: toggle-approved.tcl,v 1.3.2.2 2017/02/01 16:04:17 gustafn Exp $

} -query {
    {object_id:naturalnum,notnull}
    {item_id:naturalnum,notnull}
    {approved_p:boolean ""}
    {return_url:localurl,notnull}
}

attachments::toggle_approved -object_id $object_id -item_id $item_id -approved_p $approved_p

ad_returnredirect $return_url

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
