#/faq/www/admin/one-faq.tcl

ad_page_contract {

  View contents of one faq
    @author Elizabeth Wirth (wirth@ybos.net)
    @author Jennie Housman (jennie@ybos.net)
    @creation-date 2000-10-24
 
} {

    faq_id:naturalnum,notnull
} -properties {
    faq_name:onevalue
}

set package_id [ad_conn package_id]

set user_id [ad_conn user_id]

permission::require_permission -object_id $package_id -privilege faq_admin_faq

db_multirow faq_q_and_as faq_q_and_as_select {
    select entry_id, faq_id, question, answer, sort_key
      from  faq_q_and_as
      where faq_id = :faq_id
      order by sort_key

}

set highest_sort_key_in_list [db_string faq_maxkey_get "select max(sort_key)
	    from faq_q_and_as where faq_id=:faq_id"]

db_1row faq_name "select faq_name from faqs where faq_id=:faq_id"

set title "#faq.faq_name_Admin#"
set context [list $faq_name]

set new_faq_url [export_vars -base q-and-a-add-edit { faq_id }]

template::add_confirm_handler -CSSclass acs-confirm-delete -message [_ faq.lt_Are_you_sure_you_want_1]

ad_return_template

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
