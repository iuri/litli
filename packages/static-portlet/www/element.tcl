#
#  Copyright (C) 2001, 2002 MIT
#
#  This file is part of dotLRN.
#
#  dotLRN is free software; you can redistribute it and/or modify it under the
#  terms of the GNU General Public License as published by the Free Software
#  Foundation; either version 2 of the License, or (at your option) any later
#  version.
#
#  dotLRN is distributed in the hope that it will be useful, but WITHOUT ANY
#  WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
#  FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
#  details.
#

ad_page_contract {
    edit a static element
    
    @author arjun (arjun@openforce)
    @cvs_id $Id: element.tcl,v 1.18.2.1 2015/09/12 19:00:46 gustafn Exp $
} -query {
    {content_id:naturalnum,optional ""}
    referer:notnull
    portal_id:naturalnum,notnull
    {package_id:integer ""}
}  -properties {
    title:onevalue
}

set control_panel_text [_ "dotlrn.control_panel"]
set element_pretty_name [parameter::get -localize -parameter static_admin_portlet_element_pretty_name]
if { $content_id eq "" || [ad_form_new_p -key content_id] } {
  set title "[_ static-portlet.New] $element_pretty_name"
  set new_p 1
} else {
  set title "[_ static-portlet.Edit] $element_pretty_name"
  set new_p 0
}

set community_id $package_id
set portal_name [portal::get_name $portal_id]

if {[info exist content_id]} {
    set element_content_id $content_id
    set file_content_id $content_id
}


set type [db_string get_type { select type from dotlrn_portal_types_map where portal_id = :portal_id } -default ""]
set templates [list user dotlrn_class_instance dotlrn_club dotlrn_community]

ad_form -name static_element -form {
    element_content_id:key
    {pretty_name:text(text)     {label "[_ static-portlet.Name]"} {html {size 60}}}
    {content:richtext(richtext)     {label "[_ static-portlet.Content]"} {html {rows 15 cols 80}}}
}

if {[lsearch $templates $type] >= 0} {
    set elements [list \
		      [list {enforce_portlet:text(select)} [list label [_ static-portlet.lt_Enforce_this_applet_t]] \
			   [list help_text [_ static-portlet.lt_Enforce_True_means_th]] \
			   [list options [list [list [_ static-portlet.True] 1] [list [_ static-portlet.False_0] 0]]] \
			   [list value 0]]]    
    ad_form -extend -name static_element -form $elements
}

ad_form -extend -name static_element -form {
    {portal_id:text(hidden)     {value $portal_id}}
    {package_id:text(hidden)    {value $package_id}}
    {referer:text(hidden)       {value $referer}}
} -edit_request {
    db_1row get_content_element ""
    set content [template::util::richtext::create $body $format]
    ad_set_form_values pretty_name
} -new_data {
    db_transaction {
       
        set item_id [static_portal_content::new \
                         -package_id $package_id  \
                         -content [template::util::richtext::get_property contents $content] \
                         -format [template::util::richtext::get_property format $content] \
		         -pretty_name $pretty_name]
	
        set old_element_id [static_portal_content::add_to_portal \
				-portal_id $portal_id \
				-package_id $package_id \
				-content_id $item_id]
    }

    # support for templates & already created portals for users,
    # classes, etc. (roc)

    switch $type {
	user { 
	    set query  "select portal_id as target_portal_id from dotlrn_users" 
	    set community_id $package_id
	    set new_content_id $item_id
	}
	dotlrn_class_instance { set query "select portal_id as target_portal_id, community_id from dotlrn_class_instances_full" }
	dotlrn_club { set query "select portal_id as target_portal_id,	community_id from dotlrn_clubs_full" }
	dotlrn_community { set query "select portal_id as target_portal_id, community_id from dotlrn_communities_full" }
	default {
	    ad_returnredirect $referer
	    ad_script_abort
	}
    }

   
    db_foreach dotlrn_type_portals "$query" {

	if {$type ne "user" } {
	    # clone the template's content
	    set new_content_id [static_portal_content::new \
				    -package_id $community_id \
				    -content [template::util::richtext::get_property contents $content] \
				    -format [template::util::richtext::get_property format $content] \
                                    -pretty_name $pretty_name ]
	}
	

	set new_element_id [ static_portal_content::add_to_portal \
				 -portal_id $target_portal_id \
				 -package_id $community_id \
				 -content_id $new_content_id]
                 


	portal::set_element_param $new_element_id "package_id" $community_id
	portal::set_element_param $new_element_id "content_id" $new_content_id

	if {$enforce_portlet == 0} {
	    db_dml hide_portlet { update portal_element_map set state = 'hidden' where element_id = :new_element_id }
	}

    }

    # redirect and abort
    ad_returnredirect $referer
    ad_script_abort
} -edit_data {

    db_transaction {

        static_portal_content::update \
                -portal_id $portal_id \
                -content_id $element_content_id \
	        -pretty_name $pretty_name \
	        -content [template::util::richtext::get_property contents $content] \
		-format [template::util::richtext::get_property format $content]
    }


    switch $type {
	user { 
	    set query  "select portal_id as target_portal_id from dotlrn_users" 
            set community_id $package_id
	}
	dotlrn_class_instance { set query "select portal_id as target_portal_id, community_id from dotlrn_class_instances_full" }
	dotlrn_club { set query "select portal_id as target_portal_id,	community_id from dotlrn_clubs_full" }
	dotlrn_community { set query "select portal_id as target_portal_id, community_id from dotlrn_communities_full" }
	default {
	    ad_returnredirect $referer
	    ad_script_abort
	}
    }

    db_foreach dotlrn_type_portals "$query" {

	if { ($type ne "user") } {
	    catch {
		set element_content_id [db_string get_content_id {
		    select content_id
		    from static_portal_content
		    where package_id = :community_id
		    and pretty_name = :pretty_name
		}] 
	    } errmsg2
	}

	set no_portlet [catch {set element_id [portal::get_element_id_from_unique_param  -portal_id $target_portal_id  -key content_id  -value $element_content_id]} errmsg]

	if { $no_portlet } {

	    # if we are here, means that the portlet do not exists
	    # for given portal_id, then intead of update, we'll
	    # create it

	    if {$type ne "user" } {
		# clone the template's content
		set element_content_id [static_portal_content::new \
					    -package_id $community_id \
					    -content [template::util::richtext::get_property contents $content] \
					    -format [template::util::richtext::get_property format $content] \
                                            -pretty_name $pretty_name ]
	    }

	    set new_element_id [ static_portal_content::add_to_portal \
				     -portal_id $target_portal_id \
				     -package_id $community_id \
				     -content_id $element_content_id]

	    portal::set_element_param $new_element_id "package_id" $community_id
	    portal::set_element_param $new_element_id "content_id" $element_content_id
	    set element_id $element_content_id


	} else {
	    
	    static_portal_content::update \
		-portal_id $target_portal_id \
		-content_id $element_content_id \
		-pretty_name $pretty_name \
		-content [template::util::richtext::get_property contents $content] \
		-format [template::util::richtext::get_property format $content]
	}

	if {$enforce_portlet == 0} {
	    db_dml hide_portlet { update portal_element_map set state = 'hidden' where element_id = :element_id }
	} else {
	    db_dml hide_portlet { update portal_element_map set state = 'full' where element_id = :element_id }
	}

    }
    
    # redirect and abort
    ad_returnredirect $referer
    ad_script_abort
}



ad_form -name static_file -html {enctype multipart/form-data} -form {
    file_content_id:key
    {pretty_name:text(text)     {label "[_ static-portlet.Name]"} {html {size 60}}}
    {upload_file:file           {label "[_ static-portlet.File]"}}
    {content_format:text(select) {label "Format"} 
	{options { {"Enhanced Text" "text/enhanced"} {"Plain Text" "text/plain"} {"Fixed-width Text" "text/fixed-width"} { "HTML" "text/html"} }} 
	{value "text/plain"}}
}

if {[lsearch $templates $type] >= 0} {
    set elements [list \
		      [list {enforce_portlet:text(select)} [list label [_ static-portlet.lt_Enforce_this_applet_t]] \
			   [list help_text [_ static-portlet.lt_Enforce_True_means_th]] \
			   [list options [list [list [_ static-portlet.True] 1] [list [_ static-portlet.False_0] 0]]] \
			   [list value 0]]]    
    ad_form -extend -name static_file -form $elements
}

ad_form -extend -name static_file -form {
    {portal_id:text(hidden)     {value $portal_id}}
    {package_id:text(hidden)    {value $package_id}}
    {referer:text(hidden)       {value $referer}}
} -validate {
    {upload_file
        {$upload_file ne ""}
        "[_ static-portlet.must_specify]"
    }
} -edit_request {
    db_1row get_content_element ""
    ad_set_form_values pretty_name
} -new_data {
    set filename [template::util::file::get_property filename $upload_file]
    set tmp_filename [template::util::file::get_property tmp_filename $upload_file]
    set mime_type [template::util::file::get_property mime_type $upload_file]
    if { [string equal -length 4 "text" $mime_type] || $mime_type eq "" } {
      # it's a text file, we can do something with this
      set fd [open $tmp_filename "r"]
      set content [read $fd]
      close $fd
    } else {
      # they probably wanted to attach this file, but we can't do that.
      set content [_ static-portlet.Binary_file_uploaded]
    }

    db_transaction {
        set item_id [static_portal_content::new \
                         -package_id $package_id  \
                         -content $content \
			 -format $content_format \
		         -pretty_name $pretty_name
        ]

        static_portal_content::add_to_portal \
            -portal_id $portal_id \
            -package_id $package_id \
            -content_id $item_id

    }

    # support for templates & already created portals for users,
    # classes, etc. (roc)

    switch $type {
	user { 
	    set query  "select portal_id as target_portal_id from dotlrn_users" 
	    set community_id $package_id
	    set new_content_id $item_id
	}
	dotlrn_class_instance { set query "select portal_id as target_portal_id, community_id from dotlrn_class_instances_full" }
	dotlrn_club { set query "select portal_id as target_portal_id,	community_id from dotlrn_clubs_full" }
	dotlrn_community { set query "select portal_id as target_portal_id, community_id from dotlrn_communities_full" }
	default {
	    ad_returnredirect $referer
	    ad_script_abort
	}
    }

   
    db_foreach dotlrn_type_portals "$query" {

	if {$type ne "user" } {
	    # clone the template's content
	    set new_content_id [static_portal_content::new \
				    -package_id $community_id \
				    -content $content \
				    -format $content_format \
				    -pretty_name $pretty_name ]
	}


	set new_element_id [ static_portal_content::add_to_portal \
				 -portal_id $target_portal_id \
				 -package_id $community_id \
				 -content_id $new_content_id]

	portal::set_element_param $new_element_id "package_id" $community_id
	portal::set_element_param $new_element_id "content_id" $new_content_id

	if {$enforce_portlet == 0} {
	    db_dml hide_portlet { update portal_element_map set state = 'hidden' where element_id = :new_element_id }
	}
	
    }


    # redirect and abort
    ad_returnredirect $referer
    ad_script_abort
} -edit_data {
    set filename [template::util::file::get_property filename $upload_file]
    set tmp_filename [template::util::file::get_property tmp_filename $upload_file]
    set mime_type [template::util::file::get_property mime_type $upload_file]
    if { [string equal -length 4 "text" $mime_type] || $mime_type eq "" } {
      # it's a text file, we can do something with this
      set fd [open $tmp_filename "r"]
      set content [read $fd]
      close $fd
    } else {
      # they probably wanted to attach this file, but we can't do that.
      set content [_ static-portlet.Binary_file_uploaded]
    }
    db_transaction {
        static_portal_content::update \
                -portal_id $portal_id \
                -content_id $file_content_id \
                -pretty_name $pretty_name \
	        -content $content \
	        -format $content_format
    }

    switch $type {
	user { 
	    set query  "select portal_id as target_portal_id from dotlrn_users" 
            set community_id $package_id
	}
	dotlrn_class_instance { set query "select portal_id as target_portal_id, community_id from dotlrn_class_instances_full" }
	dotlrn_club { set query "select portal_id as target_portal_id,	community_id from dotlrn_clubs_full" }
	dotlrn_community { set query "select portal_id as target_portal_id, community_id from dotlrn_communities_full" }
	default {
	    ad_returnredirect $referer
	    ad_script_abort
	}
    }
    
    db_foreach dotlrn_type_portals "$query" {

	 if {$type ne "user" } {
	    catch {
		set file_content_id [db_string get_content_id {
		    select content_id
		    from static_portal_content
		    where package_id = :community_id
		    and pretty_name = :pretty_name
		}]
	    } errmsg2
	 }


	set no_portlet [catch {set element_id [portal::get_element_id_from_unique_param  -portal_id $target_portal_id  -key content_id  -value $file_content_id]} errmsg]

	if { $no_portlet } {

	    # if we are here, means that the portlet do not exists
	    # for given portal_id, then intead of update, we'll
	    # create it

	    if {$type ne "user" } {
		# clone the template's content
		set file_content_id [static_portal_content::new \
					    -package_id $community_id \
					    -content $content \
					    -format $content_format \
                                            -pretty_name $pretty_name ]
	    }

	    set new_element_id [ static_portal_content::add_to_portal \
				     -portal_id $target_portal_id \
				     -package_id $community_id \
				     -content_id $file_content_id]

	    portal::set_element_param $new_element_id "package_id" $community_id
	    portal::set_element_param $new_element_id "content_id" $file_content_id
	    set element_id $file_content_id


	} else {
	    
	    static_portal_content::update \
		-portal_id $target_portal_id \
		-content_id $file_content_id \
		-pretty_name $pretty_name \
		-content $content \
		-format $content_format
	}

	if {$enforce_portlet == 0} {
	    db_dml hide_portlet { update portal_element_map set state = 'hidden' where element_id = :element_id }
	} else {
	    db_dml hide_portlet { update portal_element_map set state = 'full' where element_id = :element_id }
	}

     }
    
    # redirect and abort
    ad_returnredirect $referer
    ad_script_abort
}

if { $new_p eq 0 } {
    set editing_text [_ static-portlet.lt_Editing_element_prett [list element_pretty_name $element_pretty_name pretty_name [lang::util::localize $pretty_name]]]
    set delete_text [_ static-portlet.lt_Delete_element_pretty [list element_pretty_name $element_pretty_name pretty_name [lang::util::localize $pretty_name]]]
}


# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
