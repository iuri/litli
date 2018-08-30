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

    Edit the properties for a community

    @author <a href="mailto:yon@openforce.net">yon@openforce.net</a>
    @creation-date 2002-05-20
    @version $Id: community-edit.tcl,v 1.17.4.1 2015/09/11 11:40:42 gustafn Exp $

} -query {
    {referer "one-community-admin"}
}

set user_id [ad_conn user_id]
set community_id [dotlrn_community::get_community_id]
dotlrn::require_user_admin_community -user_id $user_id -community_id $community_id

ad_form -name edit_community_info -form {
    
    {pretty_name:text(text)
	{label "#dotlrn.Name#"}
	{html {size 60}}
    }

    {description:text(textarea),optional
	{label "#dotlrn.Description#"}
	{html {rows 5 cols 60}}
	{help_text "[_ dotlrn.lt_do_not_use_p_tags]"}
    }	
    
    {active_start_date:date(date),to_sql(ansi),from_sql(ansi),optional
	{label "#dotlrn.Start_date#"}
    }

    {active_end_date:date(date),to_sql(ansi),from_sql(ansi),optional
	{label "#dotlrn.End_date#"}
    }

} -on_request {

    db_1row get_community_info {select pretty_name, description, active_start_date, active_end_date from dotlrn_communities_all where community_id = :community_id} 

} -on_submit {

    db_dml update_community_info {update dotlrn_communities_all
	set pretty_name = :pretty_name,
	description = :description,
	active_start_date = to_date(:active_start_date , 'YYYY-MM-DD HH24:MI:SS'),
	active_end_date = to_date(:active_end_date , 'YYYY-MM-DD HH24:MI:SS')
	where community_id = :community_id
    }

    dotlrn_community::set_community_name \
        -community_id $community_id \
        -pretty_name $pretty_name    
    
    ad_returnredirect $referer
    ad_script_abort
}

set roles [dotlrn_community::get_roles -community_id $community_id]

form create edit_community_role_names

foreach {rel_type role pretty_name pretty_plural} [eval concat $roles] {
    element create edit_community_role_names "${role}_pretty_name" \
        -label "$role [_ dotlrn.Pretty_Name]" \
        -datatype text \
        -widget text \
        -html {size 40} \
        -value [lang::util::localize $pretty_name]

    element create edit_community_role_names "${role}_pretty_plural" \
        -label "$role [_ dotlrn.Pretty_Plural]" \
        -datatype text \
        -widget text \
        -html {size 40} \
        -value [lang::util::localize $pretty_plural]
}

if {[form is_valid edit_community_role_names]} {
    set new_roles [list]

    foreach {rel_type role pretty_name pretty_plural} [eval concat $roles] {
        lappend new_roles [list \
            $rel_type \
            $role \
            [element get_value edit_community_role_names "${role}_pretty_name"] \
            [element get_value edit_community_role_names "${role}_pretty_plural"] \
        ]
    }

    dotlrn_community::set_roles_pretty_data \
        -community_id $community_id \
        -roles_data $new_roles

    ad_returnredirect $referer
    ad_script_abort
}

# set up some defaults and get attrs
set header_font [dotlrn_community::get_attribute \
    -community_id $community_id \
    -attribute_name header_font
]

set header_font_size [dotlrn_community::get_attribute \
    -community_id $community_id \
    -attribute_name header_font_size
]

set size_list [list medium small large x-large]
set pretty_size_list [list [_ dotlrn.Normal] [_ dotlrn.Small] [_ dotlrn.Large] [_ dotlrn.Extra_Large]]
set size_option_list [ad_generic_optionlist $pretty_size_list $size_list $header_font_size]

set header_font_color [dotlrn_community::get_attribute \
    -community_id $community_id \
    -attribute_name header_font_color
]

set header_alt_text [dotlrn_community::get_attribute \
    -community_id $community_id \
    -attribute_name header_logo_alt_text
]

set revision_id [dotlrn_community::get_attribute \
      -community_id $community_id \
      -attribute_name header_logo_item_id
  ]

# Default logos are served from known locations in the file system
# based on community type.

# Customized logos are stored in the public file-storage folder
# for the community.
 
if {$revision_id eq ""} {

    set comm_type [dotlrn_community::get_community_type_from_community_id $community_id]

    set temp_community_id $community_id
    while {[dotlrn_community::subcommunity_p -community_id $temp_community_id]} {
	# For a subcommunity, we use the logo of the
	# the first ancestor that is not a sub_community

	set temp_community_id [dotlrn_community::get_parent_id -community_id $temp_community_id]
	set comm_type [dotlrn_community::get_community_type_from_community_id $temp_community_id]
 
    }

    if {$comm_type eq "dotlrn_club"} {
	#community colors
	set scope_name "comm"
    } else {
	set scope_name "course"
    }
    
    set header_url ""

} else {
    set item_id [content::revision::item_id -revision_id $revision_id]
    set header_url "[subsite::get_url]image/$item_id"
}
 
set doc(title) [_ dotlrn.Edit_Properties]
set context [list [list one-community-admin [_ dotlrn.Admin]] $doc(title)]

ad_return_template








# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
