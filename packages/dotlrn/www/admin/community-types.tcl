# packages/dotlrn/www/admin/community-types.tcl

ad_page_contract {
    
    List community types
    
    @author Roel Canicula (roelmc@aristoi.biz)
    @creation-date 2004-06-26
    @arch-tag: e635f9de-cfd5-4900-a38d-2ac21b8b06cf
    @cvs-id $Id: community-types.tcl,v 1.3.2.1 2015/09/11 11:40:51 gustafn Exp $
} {
    
} -properties {
    title:onevalue
    context_bar:onevalue
    community_types:multirow
} -validate {
} -errors {
}

set title  "[_ dotlrn.Community_Types]"
set context_bar [list $title]

template::list::create -name community_types -multirow community_types -no_data { "\#dotlrn.no_community_types\#" } -elements {
    type {
        label "\#dotlrn.Community_Type\#"
	display_template {
	    <a href="@community_types.edit_url@">@community_types.community_type@</a>
	}
    }
    pretty_name {
        label "\#dotlrn.Pretty_Name\#"
    }
    description {
        label "\#dotlrn.Description\#"
    }
}

db_multirow -extend { 
    edit_url 
} community_types select_community_types { *SQL* } {
    set edit_url [export_vars -base community-type {community_type}]
}


# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
