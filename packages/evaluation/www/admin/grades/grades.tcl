# /packages/evaluation/www/admin/grades/grades.tcl

ad_page_contract {
    
    List of grades and options to admin grades
    
    @author jopez@galileo.edu
    @creation-date Feb 2004
    @cvs-id $Id: grades.tcl,v 1.19.2.2 2017/02/02 14:18:02 gustafn Exp $
} -query {
    {orderby:token,optional}
    {set_grade_id_live:optional ""}
}

set context [list "[_ evaluation.Grades_]"]
set package_id [ad_conn package_id]
set simple_p [parameter::get -parameter "SimpleVersion"]
set class "list"
set aggregate ""
set bulk_actions [list "[_ evaluation.Add_assignment_type_]" [export_vars -base "grades-add-edit" { }]]

set page_title "[_ evaluation.lt_Admin_Assignment_Type]"
set return_url [ad_conn url]
set total 0
set a_label [_ evaluation.total_of_course]
set actions "<a href=[export_vars -base "grades-add-edit" { }] class=\"tlmidnav\"><img src=\"/resources/evaluation/cross.gif\" width=\"10\" height=\"9\" hspace=\"5\" vspace=\"1\" style=\"border:0px\" alt=\"\" align=\"absmiddle\">[_ evaluation.Add_assignment_type_]</a>"

if { $set_grade_id_live ne "" } {
    evaluation::set_live_grade -grade_item_id $set_grade_id_live
}

if { [lc_numeric %2.f [db_string sum_grades { *SQL* }]] > 100.00} {
    set aggregate_label "<span style=\"color: red;\">[_ evaluation.Total_d]</span>"
} else {
    set aggregate_label "[_ evaluation.Total_d]"
}

if { !$simple_p } {
    set aggregate_label ""
    set aggregate "sum"
    set total "Total"
    set a_label ""
} else {
    set class "pbs_list"
    set bulk_actions ""
}


template::list::create \
    -name grades \
    -multirow grades \
    -key grade_id \
    -actions $bulk_actions  \
    -main_class $class \
    -sub_class narrow \
    -pass_properties { return_url aggregate_label total a_label aggregate} \
    -elements {
        grade_plural_name {
            label "[_ evaluation.name]"
	    orderby_asc {grade_plural_name asc}
	    orderby_desc {grade_plural_name desc}
            link_url_eval {[export_vars -base "distribution-edit" { grade_id }]}
            link_html { title "View assignment type distribution" }
	    aggregate ""
	    aggregate_label {@aggregate_label;noquote@}
        }
        weight {
            label "[_ evaluation.lt_Weight_over_100_br__o]"
	    orderby_asc {weight asc}
	    orderby_desc {weight desc}
	    display_template { @grades.weight@% }
	    aggregate "$aggregate"
	    aggregate_label {@total;noquote@}
        }
        comments {
            label "[_ evaluation.description]"
	    orderby_asc {comments asc}
	    orderby_desc {comments desc}
	    aggregate ""
	    aggregate_label {@a_label;noquote@}
	    
        }
	edit {
	    label {}
	    sub_class narrow
	    display_template {<if $simple_p eq 1>[_ evaluation.edit]</if><else><img src="/resources/acs-subsite/Edit16.gif" width="16" height="16" style="border:0" alt=""></else>
	    } 
	    link_url_eval {[export_vars -base "grades-add-edit" { item_id grade_id }]}
	    link_html { title "[_ evaluation.lt_Edit_assignment_type_]" }
	}
        delete {
            label {}
            sub_class narrow
            display_template {@grades.delete_template;noquote@} 
            link_html { title "[_ evaluation.lt_Delete_assignment_typ]" }
        }
    }

set orderby [template::list::orderby_clause -orderby -name grades]

if {$orderby eq ""} {
    set orderby " order by grade_plural_name asc"
}


db_multirow  -extend { delete_template } grades  get_class_grades { *SQL* } {
    if { $simple_p } {
	if { $live_revision ne "" } {	
	  set total [expr {$total + $weight}]
        }
    }
    if { $live_revision eq "" } {
	set delete_template "<span style=\"font-style: italic; color: red; font-size: 9pt;\">[_ evaluation.Deleted]</span> <a href=[export_vars -base "grades" { {set_grade_id_live $item_id} }]>[_ evaluation.make_it_live]</a>"
    } elseif { $simple_p } {
	set delete_template "<a href=\"[export_vars -base "grades-delete" { grade_id return_url }]\">[_ evaluation.delete]</a>"
    } else {
	set delete_template "<a href=\"[export_vars -base "grades-delete" { grade_id return_url }]\"><img src=\"/resources/acs-subsite/Delete16.gif\" width=\"16\" height=\"16\" style=\"border:0px\" alt=\"\"></a>"
    }
}

db_1row get_total_weight { *SQL* }

set total_weight [lc_numeric %.2f $total_weight]


if { ($total_weight < 100 && $total_weight > 0) || $total_weight > 100} {
    set notice "<span style=\"font-style: italic; color: red;\">[_ evaluation.lt_The_sum_of_the_weight]</span>"
} else {
    set notice ""
}

template::head::add_css -href "/resources/evaluation/evaluation.css"
ad_return_template

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
