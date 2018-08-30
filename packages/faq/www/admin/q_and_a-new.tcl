#faq/www/admin/q_and_a-new.tcl

ad_page_contract {

    Displays a form for creating a new Q&A.

    @author Elizabeth Wirth (wirth@ybos.net)
    @author Jennie Housman (jennie@ybos.net)
    @creation-date 2000-10-24
} {

    entry_id:naturalnum,optional
    faq_id:naturalnum,notnull

}  -properties {
    context:onevalue
    entry_id:onevalue
    title:onevalue
    action:onevalue
    submit_label:onevalue
    question:onevalue
    question_q:onevalue
    answer:onevalue
    answer_q:onevalue
}

permission::require_permission -object_id [ad_conn package_id] -privilege faq_create_faq

db_1row get_name "select faq_name from faqs where faq_id=:faq_id"

set page_title [_ faq.Add_QA_for_faq_name]
set context [list [list "one-faq?faq_id=$faq_id" "$faq_name"] [_ faq.Create_new_QA]]
set title [_ faq.Create_new_QA]
set target "q_and_a-new-2"
set submit_label [_ faq.Create_QA]
set question ""
set answer ""
set insert_p "f"

if { [info exists entry_id]} {
    set insert_p "t"
}

set question_q [ns_quotehtml $question]
set answer_q [ns_quotehtml $answer]

ad_return_template 


# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
