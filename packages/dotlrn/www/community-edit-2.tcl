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
    A preview page for editing the community's header

    @author Arjun Sanyal (arjun@openforce.net)
    @version $Id: community-edit-2.tcl,v 1.21.4.1 2015/09/11 11:40:41 gustafn Exp $
} -query {
    {header_font ""}
    {header_font_color ""}
    {header_font_size "Normal"}
    {header_img ""}
    {header_alt_text ""}
}

#
# Some general stuff
#

set user_id [ad_conn user_id]
set creation_ip [ad_conn peeraddr]
set community_id [dotlrn_community::get_community_id]
dotlrn::require_user_admin_community -user_id $user_id -community_id $community_id

set doc(title) [_ dotlrn.Preview]
set context [list \
                 [list one-community-admin [_ dotlrn.Admin]] \
                 [list community-edit [_ dotlrn.Edit_Properties]] \
                 $doc(title)]

set header_text [dotlrn_community::get_community_header_name $community_id]

# Image stuff

set tmp_filename [ns_queryget header_img.tmpfile]

#TODO - better way to get typs.
# THIS DOESN'T WORK.
set mime_type [ns_guesstype $header_img]


if {$tmp_filename eq ""} {
      set tmp_size 0
      set revision_id 0
} else {
      set tmp_size [file size $tmp_filename]
}

set title "$header_img-[db_nextval acs_object_id_seq]"

#  # strip off the C:\directories... crud and just get the file name

if {![regexp {([^/\\]+)$} $header_img match client_filename]} {
      set client_filename $header_img
}

# title of CR item.  This must be unique because all uploaded logos are stored
# in the CR root folder (-100).
set logo_name "community_logo_$community_id"

set maxFileSize [parameter::get -parameter MaximumFileSize]
if { $maxFileSize ne "" 
     && $tmp_size > 0
     && $tmp_size > $maxFileSize 
 } {
    set msg_subst_list [list system_name [ad_system_name] \
                             max_attachments_bytes [util_commify_number $maxFileSize]]
    ad_return_complaint 1 "<li>[_ dotlrn.your_icon_is_too_large $msg_subst_list]"
    ad_script_abort
}

if { $tmp_size > 0 } {
    # import the content now, so that we can spit it out in the preview
    db_transaction {

        # We will store the image in the topmost root folder
        set parent_id [db_string get_root_folder {}]

        # if this is a re-upload, pass along the item_id
        set item_id [content::item::get_id_by_name -name $logo_name -parent_id $parent_id]

	# if it's a new upload, create the item
	if { $item_id eq ""} {
	    set item_id [content::item::new -name $logo_name -parent_id $parent_id -content_type image]

        # since it's just the header logo, which can't be accessed outside of
        # the community anyway, let everyone have access to see it.  That way
        # it won't cause any trouble later on when we try to implement
        # try-before-you-buy for non-members.
        permission::grant -party_id [acs_magic_object registered_users] -object_id $item_id -privilege read
	}

	# the last param is the title of the new file in the CR.
	set revision_id [cr_import_content \
                -title $title \
                -description "group's icon" \
                -image_only \
                -item_id $item_id \
                $parent_id \
                $tmp_filename \
                $tmp_size \
                $mime_type \
                $logo_name
            ]

        content::item::set_live_revision -revision_id $revision_id

    } on_error { 
        # most likely a duplicate name, double click, etc.
        ad_return_complaint 1 "
            [_ dotlrn.lt_There_was_an_error_tr]
            <ul>
              <li>[_ dotlrn.lt_You_tried_to_upload_a]
              <li>[_ dotlrn.lt_You_double-clicked_th]
            </ul>
           <p>[_ dotlrn.lt_Here_is_the_actual_er]</p>
                <pre>
                  $errmsg
                </pre>"
        ad_script_abort
    }
} else {
    # if there was no img uploaded, use the old value of the attribute
    # which is either "" for no img ever uploaded or the current revision_id
    set revision_id [dotlrn_community::get_attribute \
        -community_id $community_id \
        -attribute_name header_logo_item_id
    ]
}

#
# Font stuff 
#

if {$header_font eq ""} {
    set header_font_text "sans-serif (None chosen)"
    set header_font_fragment ""
} else {
    set header_font_text $header_font
    # CSS requies quoting of font names with spaces
    if {![regexp "^'.*'$" $header_font]} {
        set header_font "'$header_font'"
    }
    set header_font_fragment "$header_font, "
}

set header_font_size_text $header_font_size
set style_fragment "font-family: $header_font_fragment Verdana, Arial, Helvetica, sans-serif; font-size: $header_font_size;"

if {$header_font_color eq ""} {
    set header_font_color_text "[_ dotlrn.Black_None_chosen]"
    set header_font_color "black"
} else {
    set header_font_color_text $header_font_color
}

append style_fragment " " "color: $header_font_color;"

#logo stuff
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
    
    set header_url "/resources/dotlrn/logo-$scope_name.gif"

} else {
    set item_id [content::revision::item_id -revision_id $revision_id]
    set header_url "[subsite::get_url]image/$item_id"
}


form create header_form
set yes_label "[_ dotlrn.lt_Save_and_use_this_hea]"

element create header_form no_button \
    -label "[_ dotlrn.lt_Go_back_and_try_again]" \
    -datatype text \
    -widget submit \
    -value "1"

element create header_form yes_button \
    -label "[_ dotlrn.lt_Save_and_use_this_hea]"  \
    -datatype text \
    -widget submit

element create header_form header_logo_item_id \
      -label header_logo_item_id \
      -datatype text \
      -widget hidden \
      -value $revision_id

element create header_form header_logo_alt_text \
      -label header_logo_alt_text \
      -datatype text \
      -widget hidden \
      -value $header_alt_text

element create header_form header_font \
    -label header_font \
    -datatype text \
    -widget hidden \
    -value $header_font

element create header_form header_font_size \
    -datatype text \
    -widget hidden \
    -value $header_font_size

element create header_form header_font_color \
    -datatype text \
    -widget hidden \
    -value $header_font_color

if {[form is_valid header_form]} {
    form get_values header_form \
        no_button \
        yes_button \
        header_font \
        header_font_size \
        header_font_color \
        header_logo_item_id \
        header_logo_alt_text

    if {$yes_button eq $yes_label} {

        dotlrn_community::set_attributes \
            -community_id $community_id \
            -pairs [list \
                [list header_font $header_font] \
                [list header_font_size $header_font_size] \
                [list header_font_color $header_font_color] \
                [list header_logo_item_id $header_logo_item_id] \
                [list header_logo_alt_text $header_logo_alt_text]]
 

        ad_returnredirect "one-community-admin"
    } else {
        ad_returnredirect "community-edit"
    }

    ad_script_abort

}

ad_return_template

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
