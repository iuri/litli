# /packages/evaluation/www/admin/evaluations/grades-sheets.tcl

ad_page_contract {

	List the grades sheets for the task

    @author jopez@galileo.edu
    @creation-date May 2004
    @cvs-id $Id: grades-sheets.tcl,v 1.11.2.2 2017/02/02 14:18:02 gustafn Exp $

} -query {
	{orderby:token,optional}
	task_id:naturalnum,notnull
	return_url:localurl
} -validate {
	grades_sheets {
		if { ![db_string count_grades_sheets { *SQL* }] } {
			ad_complain "[_ evaluation.lt_There_are_no_files_as]"
		}
	}
}


set page_title "[_ evaluation.Grades_Sheets_]"
set context [list [list "[export_vars -base student-list { task_id }]" "[_ evaluation.Studen_List_]"] "[_ evaluation.Grades_Sheets_]"]

set base_url [ad_conn package_url]

template::list::create \
    -name grades_sheets \
    -multirow grades_sheets \
    -key grades_sheet_id \
    -filters { task_id {} return_url {} } \
    -orderby { default_value grades_sheet_name } \
    -elements {
        grades_sheet_name {
            label "[_ evaluation.Grades_Sheet_Name_]"
			orderby_asc {grades_sheet_name asc}
			orderby_desc {grades_sheet_name desc}
        }
        upload_date_pretty {
            label "[_ evaluation.Upload_Date_]"
			orderby_asc {upload_date_ansi asc}
			orderby_desc {upload_date_ansi desc}
        }
        upload_user {
            label "[_ evaluation.Uploaded_by_]"
			orderby_asc {upload_user asc}
			orderby_desc {upload_user desc}
        }
        view {
            label {}
            sub_class narrow
            display_template {
                <img src="/resources/acs-subsite/Zoom16.gif" width="16" height="16" alt="" style="border:0px">
            } 
            link_url_col view_url
            link_html { title "[_ evaluation.View_grades_sheet_]" }
        }
    }

set orderby [template::list::orderby_clause -orderby -name grades_sheets]

if {$orderby eq ""} {
    set orderby " order by grades_sheet_name asc"
}

db_multirow -extend { view_url upload_date_pretty } grades_sheets get_grades_sheets { *SQL* } {
    set view_url "[export_vars -base "${base_url}view/$grades_sheet_name" { revision_id }]"
    set upload_date_pretty [lc_time_fmt $upload_date_ansi "%q %r"]
}

ad_return_template

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
