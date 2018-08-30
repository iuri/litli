#/faq/www/admin/one-question.tcl

ad_page_contract {

  View contents of one Q&A
    @author Elizabeth Wirth (wirth@ybos.net)
    @author Jennie Housman (jennie@ybos.net)
    @author Nima Mazloumi (nima.mazloumi@gx.de)
    @creation-date 2000-10-24
 
} {

    entry_id:naturalnum,notnull
} -properties {
    entry_id:onevalue
}

set package_id [ad_conn package_id]

set user_id [ad_conn user_id]

permission::require_permission -object_id $package_id -privilege faq_admin_faq

db_1row q_and_a_info "select question, answer, a.faq_id, f.faq_name  
      from faq_q_and_as a, faqs f 
      where entry_id = :entry_id
      and a.faq_id = f.faq_id"

set context [list [list "one-faq?faq_id=$faq_id" "$faq_name"] "[_ faq.One_Question]"]

set edit_url [export_vars -base q-and-a-add-edit { entry_id faq_id }]
set delete_url [export_vars -base q_and_a-delete { entry_id faq_id }]
set create_url [export_vars -base q-and-a-add-edit { faq_id } ]

ad_return_template

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
