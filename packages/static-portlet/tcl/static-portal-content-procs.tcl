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

ad_library {

    The procs for manipulating static portal content. This is like having
    the "bboard" included in it's own "bboard-portlet" package.

    @author arjun@openforce.net
    @cvs-id $Id: static-portal-content-procs.tcl,v 1.20.2.2 2017/06/30 17:54:02 gustafn Exp $

}

namespace eval static_portal_content {

    ad_proc -public new {
        {-package_id:required}
        {-content:required}
        {-pretty_name:required}
	{-format "text/html"}
    } {
        Calls the pl/sql to create the new content item
    } {
	# Create the content item
        set content_id [db_exec_plsql new_content_item {}]

        # Ben's style only cause he was editing here and then changed things back
        return $content_id
    }

    ad_proc -public add_to_portal {
        {-portal_id:required}
        {-package_id:required}
        {-content_id ""}
        {-template_id ""}
    } {
        This is a bit different from other add_self_to_page procs.
    } {

        if {$template_id ne ""} {
            # we got a template_id, so we know that (1) that we are
            # being called from add_applet_to_community. That means that
            # we have a static portlet copied from our template,
            # but the pointer to the _content_ of the portlet still
            # _template's content_. Therefore we need to clone the
            # _template's content_ and update the pointer
            # (2) that there's only one static portlet on the page.

            set old_element_id [portal::get_element_ids_by_ds \
                                    $template_id \
                                    [static_portlet::get_my_name]
            ]

	    set new_content_ids [list]
	    foreach oei $old_element_id {
		set old_content_id [portal::get_element_param $oei content_id]
    

		# clone the template's content
		lappend new_content_ids [static_portal_content::new \
                                    -package_id $package_id \
                                    -content [get_content -content_id $old_content_id] \
				    -format [get_content_format -content_id $old_content_id] \
				    -pretty_name [get_pretty_name -content_id $old_content_id]]

	    }

	    # update the new static portlet's params, and return
	    set new_element_ids [portal::get_element_ids_by_ds \
				     $portal_id \
				     [static_portlet::get_my_name]
				]

	    foreach nei $new_element_ids nci $new_content_ids {
		portal::set_element_param $nei "package_id" $package_id
		portal::set_element_param $nei "content_id" $nci
	    }

	    # we use the return value to create the portlet on the non-member
	    # page, which is linked to the same content as on the
	    # main comm page

	    return [lindex $new_content_ids 0]
        }

        db_transaction {
            # Generate the element, don't use add_element_parameters here,
            # since it doesn't do the right thing for multiple elements with
            # the same datasource on a page. so we just use the more low level
            # portal::add_element
            set element_id [portal::add_element \
                    -portal_id $portal_id \
                    -portlet_name [static_portlet::get_my_name] \
                    -pretty_name [get_pretty_name -content_id $content_id] \
                    -force_region [parameter::get_from_package_key \
                                       -parameter "static_portal_content_force_region" \
                                       -package_key "static-portlet"]
            ]

            portal::set_element_param $element_id package_id $package_id
            portal::set_element_param $element_id content_id $content_id
        }
	return $element_id
    }

    ad_proc -public clone {
        {-portal_id:required}
        {-package_id:required}
    } {
        A helper proc for cloning. There could be multiple static portlets
        that need to be cloned. Make a deep copy of all the static portal
        content and update the all the corresponding element's pointers
    } {
        set ds_id [portal::get_datasource_id [static_portlet::get_my_name]]

        set element_list [db_list get_element_list {}]

        foreach element_id $element_list {
            set old_content_id [db_string select_element_id {}]

            # make a new static content item from this item
            set new_content_id [new \
                -package_id $package_id \
                -content [get_content -content_id $old_content_id] \
                -pretty_name [get_pretty_name -content_id $old_content_id]
            ]

            # update the portal element's pointers
            portal::set_element_param $element_id package_id $package_id
            portal::set_element_param $element_id content_id $new_content_id
        }
    }

    ad_proc -public remove_from_portal {
        {-portal_id:required}
        {-content_id:required}
    } {
        ad_return_complaint 1 "static_portal_content::remove_from_portal not implemented"
    }

    ad_proc -public remove_all_from_portal {
        {-portal_id:required}
    } {
        db_transaction {
            # should remove all of 'em
            set element_id [portal::remove_element \
                    -portal_id $portal_id \
                    -portlet_name [static_portlet::get_my_name]
            ]
        }
    }

    ad_proc -public update {
        {-portal_id:required}
        {-content_id:required}
        {-content:required}
        {-pretty_name:required}
	{-format "text/html"}
    } {
        updates the content item
    } {
	
	db_transaction {
            # update the content item
            db_dml update_content_item {}
            
            # update the title of the portal element
            set element_id [portal::get_element_id_from_unique_param \
                -portal_id $portal_id \
                -key content_id \
                -value $content_id
            ]

            portal::set_pretty_name \
                -element_id $element_id \
                -pretty_name $pretty_name
        }
    }

    ad_proc -public delete {
        {-content_id:required}
    } {
        deletes the item
    } {

        db_dml delete_content_item {
            delete from static_portal_content where content_id = :content_id
        }
    }

    ad_proc -public get_pretty_name {
        {-content_id:required}
    } {
        Get the pretty_name of the item
    } {
        return [db_string select {}]
    }

    ad_proc -public get_content {
        {-content_id:required}
    } {
        Get the content of the item
    } {
        return [db_string get_content.select {
            select content
            from static_portal_content
            where content_id = :content_id
        }]
    }

    ad_proc -public get_package_id {
        {-content_id:required}
    } {
        Get the package_id of the item
    } {
        return [db_string get_package_id.select {}]
    }
    
    ad_proc -public get_content_format {
	{-content_id:required}
    } {
	Get the format of the content's item
    } {
	return [db_string get_content_format.select {} ]
    }
}

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
