# /packages/news/www/preview.tcl
ad_page_contract {
    This page previews the input from item-create or admin/revision-add
    
    @author stefan@arsdigita.com
    @creation-date 2000-12-18
    @cvs-id $Id: preview.tcl,v 1.31.2.3 2016/08/11 12:52:38 gustafn Exp $
    
} {
    {item_id:naturalnum ""}
    action:notnull,trim
    publish_title:notnull,trim
    {publish_lead {}}
    {publish_body:allhtml,trim ""}
    publish_body.format:notnull
    {revision_log: ""}
    {publish_date:array ""}
    {archive_date:array ""}
    {permanent_p: "f"}
    publish_date_ansi:optional
    archive_date_ansi:optional
    imgfile:optional
    
} -errors {

    publish_title:notnull "[_ news.lt_Please_supply_the_tit]"
    publish_body:notnull "[_ news.lt_Please_supply_the_bod]"
    img_file_valid "[_ news.image_file_is_invalid]"

} -validate {

    check_revision_log -requires {action revision_log} {
	if { $action eq "News Item" && $revision_log eq ""} {
	    ad_complain "[_ news.lt_You_must_supply_a_rev]"
	    return
	}
    }

}  -properties {

    title:onevalue
    context:onevalue
    publish_title:onevalue
    publish_lead:onevalue
    publish_body:onevalue
    publish_format:onevalue
    publish_location:onevalue
    hidden_vars:onevalue
    permanent_p:onevalue
    html_p:onevalue
    news_admin_p:onevalue 
    form_action:onevalue
    image_url:onevalue
    edit_action:onevalue
}

set user_id [auth::require_login]
set package_id [ad_conn package_id]

# only people with at least write-permission beyond this point
permission::require_permission -object_id $package_id -privilege news_create

set news_admin_p [permission::permission_p -object_id $package_id -privilege news_admin]

# Template parser treats publish_body.format as an array reference
set publish_format ${publish_body.format}

if { $action eq "News Item" } {
    set title "[_ news.Preview_news_item]"
} else {
    set title "[_ news.Preview] $action"
}
set context [list $title]

# DRB: not sure about the accuracy of this comment so am leaving this.
# if we've come back from the image page, set up dates again
if {[info exists publish_date_ansi] && [info exists archive_date_ansi]} {
    set exp {([0-9]{4})-([0-9]{1,2})-([0-9]{1,2})}
    if { ![regexp $exp $publish_date_ansi match \
               publish_date(year) publish_date(month) publish_date(day)]
         || ![regexp $exp $archive_date_ansi match \
                  archive_date(year) archive_date(month) archive_date(day)] } {
        ad_return_complaint 1 "[_ news.Publish_archive_dates_incorrect]"
    }
}
# deal with Dates, granularity is 'day'

# with news_admin privilege fill in publish and archive dates
if { $news_admin_p == 1 || [parameter::get -parameter ApprovalPolicy] eq "open" } {

    if { [info exists publish_date(year)] && [info exists publish_date(month)] && [info exists publish_date(day)] } { 
	set publish_date_ansi "$publish_date(year)-$publish_date(month)-$publish_date(day)"
    } else {
	set publish_date_ansi ""
    }
    if { [info exists archive_date(year)] && [info exists archive_date(month)] && [info exists archive_date(day)] } { 
	set archive_date_ansi "$archive_date(year)-$archive_date(month)-$archive_date(day)"
    } else {
	set archive_date_ansi ""
    }

    if { ![template::util::date::validate $publish_date_ansi ""] } {
        set publish_date_pretty [lc_time_fmt $publish_date_ansi "%Q"]
    }
    if { ![template::util::date::validate $archive_date_ansi ""] } {
        set archive_date_pretty [lc_time_fmt $archive_date_ansi "%Q"]
    }

    if { [dt_interval_check $archive_date_ansi $publish_date_ansi] >= 0 } {
	ad_return_error "[_ news.Scheduling_Error]" \
            "[_ news.lt_The_archive_date_must]"
	return
    }

}

if { ${publish_body.format} eq "text/html" || ${publish_body.format} eq "text/enhanced" } {

    # close any open HTML tags in any case
    set  publish_body [util_close_html_tags $publish_body]
    
    # Note: this is the *only* check against disallowed HTML tags in the
    # news posting system.  Currently, each path for creating or revising
    # a news items passes through this preview script, so it's safe.  But if
    # in the future someone modifies the package to, say, use self-submit forms
    # the check will need to be added as a validator for each ad_form call.

    set errors [ad_html_security_check $publish_body]
    if { $errors ne "" } {
        ad_return_complaint 1 $errors
        ad_script_abort
    }
}

if { $action eq "News Item" } {

    # form variables for confirmation step

    set hidden_vars [export_vars -form {publish_title publish_lead publish_body publish_body.format \
                         publish_date_ansi archive_date_ansi html_p permanent_p imgfile}]
    set image_vars [export_vars -form {publish_title publish_lead publish_body publish_body.format \
                        publish_date_ansi archive_date_ansi html_p \
                        permanent_p action}]
    set form_action "<form method='post' action='item-create-3' enctype='multipart/form-data' class='inline-form'>"
    set edit_action "<form method='post' action='item-create' class='inline-form'>"

} else {

    # Form vars to carry through Confirmation Page
    set hidden_vars [export_vars -form {item_id revision_log publish_title publish_lead \
                         publish_body publish_body.format publish_date_ansi archive_date_ansi \
                         permanent_p html_p imgfile}]
    set image_vars [export_vars -form {publish_title publish_lead publish_body publish_body.format \
                        publish_date_ansi archive_date_ansi html_p \
                        permanent_p action item_id revision_log}]
    set form_action "<form method='post' action='admin/revision-add-3' class='inline-form'>"
    set edit_action "<form method='post' action='admin/revision-add' class='inline-form'>"
}

# creator link 
set creator_name [db_string creator {
    select first_names || ' ' || last_name 
    from   cc_users 
    where  user_id = :user_id
}]
set creator_link "<a href='/shared/community-member?user_id=$user_id'>[ns_quotehtml $creator_name]</a>"

template::head::add_style -style ".news-item-preview { color: inherit; background-color: #eeeeee; margin: 1em 4em 1em 4em; padding: 1em; }" -media screen

ad_return_template

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
