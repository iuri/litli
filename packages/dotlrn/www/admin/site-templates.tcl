# 

ad_page_contract {
     
    Displays dotLRN Site templates admin page
    
    @author Victor Guerra (guerra@galileo.edu)
    @creation-date 2005-05-19
    @arch-tag: 59d729de-a526-48af-8087-f81ee8cf0fda
    @cvs-id $Id: site-templates.tcl,v 1.2.10.1 2015/09/11 11:40:52 gustafn Exp $
} {
} -properties {
    title:onevalue
    context_bar:onevalue
} -validate {
} -errors {
}

dotlrn::require_admin

set title "[_ dotlrn.Site_Templates]"
set context_bar [list $title]
set referer [ad_conn url]

set actions [list "[_ dotlrn.Site_Template_Add]" [export_vars -base "add-edit-site-template" {site_template_id referer}] "" \
		 "[_ dotlrn.Site_Template_AdminParams]" [export_vars -base "admin-params-site-templates" {{return_url $referer}}] ""]

template::list::create \
    -name site_templates \
    -multirow site_templates \
    -actions $actions \
    -key site_template_id \
    -html { width 80% } \
    -filters { site_template_id } \
    -orderby { pretty_name } \
    -no_data "[_ dotlrn.No_Site_Templates_data]" \
    -elements {
	site_template_id {
	    label "[_ dotlrn.Site_Template_ID]"
	    html { align "center" }
	    display_template {
		<a href="add-edit-site-template?site_template_id=@site_templates.site_template_id@&referer=$referer">@site_templates.site_template_id@</a>  
	    }
	}
	pretty_name {
	    label "[_ dotlrn.Site_Template_Name]"
	     html { align "center" }
	}
	portal_theme {
	    label "[_ dotlrn.Site_Template_Portal_theme]"
	    html { align "center" }
	}
	actions {
	    label "[_ dotlrn.actions]"
	    html { align "center" }
	    display_template {
	    }
	}
    } 

db_multirow -extend {actions} site_templates select_site_templates { *SQL* } {
}
# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
