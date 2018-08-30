# /packages/evaluaiton/www/admin/grades/distribution-edit.tcl

ad_page_contract {
    Bulk edit grade's distribution

    @author jopez@galileo.edu
    @creation-date Mar 2004
    @cvs-id $Id: distribution-edit.tcl,v 1.16.2.1 2015/09/12 11:06:04 gustafn Exp $

} {
    grade_id:naturalnum,notnull
    {set_task_id_live:optional ""}
} 

set user_id [ad_conn user_id]
set simple_p [parameter::get -parameter "SimpleVersion"]

set page_title "[_ evaluation.lt_Assignment_Types_Dist]"
set context [list [list "grades" "[_ evaluation.Assignment_Types_]"] "[_ evaluation.lt_Assignment_Types_Dist]"]
set class "list"
if { $simple_p } {
    set class "pbs_list"
}

db_1row grade_info { *SQL* }

set grade_plural_name [lang::util::localize $grade_plural_name]
set grade_plural_name_up [string toupper $grade_plural_name]

if { $set_task_id_live ne "" } {
    evaluation::set_live_task -task_item_id $set_task_id_live
}

set elements [list task_name \
		  [list label "[_ evaluation.name]" \
		       display_template {<a href="../evaluations/student-list?task_id=@grades.task_id@">@grades.task_name@</a>}\
		       orderby_asc {task_name asc} \
		       orderby_desc {task_name desc}] \
		  task_weight \
		  [list label "[_ evaluation.lt_Weight_over_grade]" \
		       display_template { <div style="text-align:center"><input size=5 maxlength=6 type=text name=weights.@grades.task_id@ value=@grades.task_weight@> </div>} \
		       aggregate sum \
		       aggregate_label { [_ evaluation.total]}
		  ] \
		  relative_weight \
		  [list label "[_ evaluation.rel_weight]" \
		       display_template { <div style="text-align:center">@grades.relative_weight@</div> } \
		       aggregate sum \
		      ]\
		  requires_grade \
		  [list label "[_ evaluation.requires_grade]" \
		       display_template { [_ evaluation.Yes_] <input @grades.radio_yes_checked@ type=radio name="no_grade.@grades.task_id@" value=t> [_ evaluation.No_] <input @grades.radio_no_checked@ type=radio name="no_grade.@grades.task_id@" value=f> } \
		      ] \
		  delete \
		  [list label {} \
		       sub_class narrow \
		       display_template { @grades.delete_template;noquote@ } \
		       link_html { title "[_ evaluation.lt_Delete_assignment_typ]" } \
		      ] \
		 ]


# points \
	  [list label "Weight over Total" \
		       display_template { <input size=5 maxlength=6 type=text name=points.@grades.task_id@ value=@grades.points@> } \
		       aggregate sum \
		       aggregate_label { Total } ] 

template::list::create \
    -name grades \
    -multirow grades \
    -key task_id \
    -main_class $class \
    -sub_class narrow\
    -filters { grade_id {} } \
    -elements $elements 


set orderby [template::list::orderby_clause -orderby -name grades]

if {$orderby eq ""} {
    set orderby " order by task_name asc"
}

set return_url [export_vars -base ../grades/distribution-edit { grade_id } ]

db_multirow -extend { radio_yes_checked radio_no_checked delete_template } grades get_grade_tasks { *SQL* } {
    
    set task_weight [format  %0.2f $task_weight]
    
    if {$requires_grade_p == "t"} {
	set radio_yes_checked "checked"
	set radio_no_checked ""
    } else {
	set radio_yes_checked ""
	set radio_no_checked "checked"
    }    

    if { $live_revision eq "" } {
	set delete_template "<span style=\"font-style: italic; color: red; font-size: 9pt;\">[_ evaluation.Deleted]</span> <a href=[export_vars -base "distribution-edit" { grade_id {set_task_id_live $task_item_id} }]>[_ evaluation.make_it_live]</a>"
    } elseif { $simple_p } {
	set delete_template "<a href=\"[export_vars -base "../tasks/task-delete" { task_id grade_id return_url }]\">[_ evaluation-portlet.Delete]</a>"
    } else {
	set delete_template "<a href=\"[export_vars -base "../tasks/task-delete" { task_id grade_id return_url }]\"><img src=\"/resources/acs-subsite/Delete16.gif\" width=\"16\" height=\"16\" style=\"border:0px\" alt=\"\"></a>"
    }
    
}

template::head::add_css -href "/resources/evaluation/evaluation.css"
ad_return_template

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
