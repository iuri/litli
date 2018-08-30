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

    Procs to manage DOTLRN Security

    @author Ben Adida (ben@openforce.net)
    @author yon (yon@openforce.net)
    @creation-date 2001-10-30
    @cvs-id $Id: dotlrn-security-procs.tcl,v 1.61.2.3 2017/02/24 12:41:25 gustafn Exp $

}

namespace eval dotlrn {

    ad_proc -public generate_key {
        {-name:required}
        {-increment:boolean}
    } {
        Generate a key from a name. Compresses all adjacent non-alphanum
        chars to a dash. Yes, this is not unique, grows rapidly, will
        need collision detection and resolution, yada yada.
    } {
        return [util_text_to_url \
                -replacement {} \
                -existing_urls { members configure spam index not-allowed clone help } \
                -no_resolve=[expr {!$increment_p}] \
                -- $name]
    }

    ad_proc -private do_abort {} {
        do an abort if security violation
    } {
        ad_returnredirect "not-allowed"
        ad_script_abort
    }

    ad_proc -public get_user_types {} {
        return the list of possible user types
    } {
        return [db_list_of_lists select_user_types {}]
    }

    ad_proc -public get_user_types_as_options {} {
        return the list of possible user types
    } {
        set unlocalized_list [db_list_of_lists select_user_types_as_options {}]

        set localized_list [list]
        foreach type_pair $unlocalized_list {
            lappend localized_list [list [lang::util::localize [lindex $type_pair 0]] [lindex $type_pair 1]]
        }

        return $localized_list
    }

    ad_proc -public user_p {
        {-user_id:required}
    } {
        check if a user is a dotLRN user
    } {
        return [db_string select_count {
            select count(*)
            from dual
            where exists (select 1
                          from dotlrn_users
                          where user_id = :user_id)
        }]
    }

    ad_proc -public user_add {
        {-type student}
        {-can_browse:boolean}
        {-id ""}
        {-user_id:required}
    } {
        Add a user as a dotLRN user
    } {
        # Check if the user is already a dotLRN user
        if {[user_p -user_id $user_id]} {
            return
        }

        # default ID to email address
        if {$id eq ""} {
            set id [party::email -party_id $user_id]
        }

        # set up extra vars
        set extra_vars [ns_set create]
        ns_set put $extra_vars user_id $user_id
        ns_set put $extra_vars id $id

        set template_id [dotlrn::get_portal_id_from_type -type user]

        db_transaction {
            set_can_browse -user_id $user_id -can_browse\=$can_browse_p

	    set portal_id [portal::create \
		    -template_id $template_id \
		    -name "[_ dotlrn.lt_Your_dotLRN_Workspace]" \
		    $user_id] 


	    ns_set put $extra_vars portal_id $portal_id

            # Add the relation (no need to feed in anything for object_id_one,
            # or two for that matter).
            set rel_id [relation_add \
                -extra_vars $extra_vars \
                -member_state approved \
                [get_rel_type_from_user_type -type $type] \
                "" \
                $user_id \
            ]
	    
            dotlrn_applet::dispatch -op AddUser -list_args [list $user_id]

            # if the user is a member of communities (from some previous
            # dotlrn relation) then we must remove them from the community and
            # re-add them so that all the portals will work properly.
            # NOTE: we cannot do this in a db_foreach beacause of the table we
            # are selecting from changes inside the loop causing all kinds of
            # dead lock issues.
            set current_memberships [db_list_of_ns_sets select_current_memberships {
                select dotlrn_member_rels_full.community_id,
                       rel_type,
                       member_state
                from dotlrn_member_rels_full, dotlrn_communities
                where user_id = :user_id
		and dotlrn_member_rels_full.community_id = dotlrn_communities.community_id
		and dotlrn_communities.parent_community_id is null
            }]
           
            # Note that remove_user will remove users from the subgroups as well as the
	    # parent community. Therefore, current_memberships only contains parent communities.

            foreach row $current_memberships {
                dotlrn_community::remove_user [ns_set get $row community_id] $user_id
                dotlrn_community::add_user \
                    -rel_type [ns_set get $row rel_type] \
                    -member_state [ns_set get $row member_state] \
                    [ns_set get $row community_id] \
                    $user_id
            }
        }
        
        # always flush when creating a new user
        util_memoize_flush "dotlrn::get_portal_id_not_cached -user_id $user_id"

	#Site Template Customization
	dotlrn::set_site_template_id -user_id $user_id \
	    -site_template_id [parameter::get -package_id [dotlrn::get_package_id] -parameter "UserDefaultSiteTemplate_p"]

        return $rel_id
    }

    ad_proc -public user_remove {
        {-user_id:required}
    } {
        Remove a user from the set of dotLRN users
    } {
        set rel_id [db_string select_rel_id {} -default ""]

        if {$rel_id ne ""} {
            relation_remove $rel_id
        }
    }

    ad_proc -public users_remove {
        {-users:required}
    } {
        Remove a set of users from dotLRN
    } {
        db_transaction {
            foreach user $users {
                user_remove -user_id $user
            }
        }
    }

    ad_proc -public remove_user_completely {
        {-user_id:required}
        {-on_fail soft_delete}
    } {
        Remove the user from ACS as well.  Chances are pretty good that
        this will fail because it's hard to chase down every piece
        of content the user has ever put into the system.  The net result is
        that there may be stray referential integrity contraints that
        will throw errors when we try to remove the user record permanently.

        @param on_fail indicates what we do if the permanent removal fails. Setting to
         <code>soft_delete</code> will result in a repeat call to <code>acs_user::delete</code>
         but this time without the <code>-permanent</code> flag.  Setting to <code>error</code>
         (or anything else) will result in re-throwing the original error.
    } {
        if {[user_p -user_id $user_id]} {
            user_remove -user_id $user_id
        }
        
        # cycle through the applets and invoke their RemoveUser procs
        foreach applet_key [dotlrn_applet::list_mounted_applets] {
            ns_log Debug "dotlrn::remove_user_completely: invoking RemoveUser for applet $applet_key"
            dotlrn_community::applet_call \
                $applet_key \
                RemoveUser \
                [list $user_id]
        }
        
        if { [catch {
            acs_user::delete -user_id $user_id -permanent
        } errMsg] } {
            ns_log Notice "dotlrn::remove_user_completely: permanent removal failed for user $user_id.  Invoking on_fail option '$on_fail'"
            if {$on_fail eq "soft_delete"} {
                acs_user::delete -user_id $user_id
            } else {
                error $errMsg
            }
        }
    }

    ad_proc -public remove_users_completely {
        {-users:required}
    } {
        Remove a set of users from the ACS
    } {
        db_transaction {
            foreach user $users {
                remove_user_completely -user_id $user
            }
        }
    }

    ad_proc -public set_can_browse {
        {-user_id ""}
        {-can_browse:boolean}
    } {
        sets whether a user can browse communities
    } {
        if {$can_browse_p} {
            permission::grant \
                -party_id $user_id \
                -object_id [dotlrn::get_package_id] \
                -privilege dotlrn_browse
        } else {
            permission::revoke \
                -party_id $user_id \
                -object_id [dotlrn::get_package_id] \
                -privilege dotlrn_browse
        }
    }

    ad_proc -public user_can_browse_p {
        {-user_id ""}
    } {
        Check is a user can browse dotLRN
    } {
        return [permission::permission_p \
            -party_id $user_id \
            -object_id [dotlrn::get_package_id] \
            -privilege dotlrn_browse \
        ]
    }

    ad_proc -public require_user_browse {
        {-user_id ""}
    } {
        Require that a user be able to browse dotLRN
    } {
        if {![user_can_browse_p -user_id $user_id]} {
            do_abort
        }
    }

    ad_proc -public user_can_read_private_data_p {
        {-user_id ""}
        {-object_id:required}
    } {
        Check if a user can read sensitive data in dotLRN
    } {
        if { [parameter::get -parameter protect_private_data_p -default 1] } {
            return [acs_privacy::user_can_read_private_data_p \
                        -user_id $user_id \
                        -object_id $object_id
                   ]
        } else {
            return 1
        }
    }

    ad_proc -public require_user_read_private_data {
        {-user_id ""}
        {-object_id:required}
    } {
        Require that a user be able to read sensitive data
    } {
        if {![user_can_read_private_data_p -user_id $user_id -object_id $object_id]} {
            do_abort
        }
    }

    ad_proc -public user_can_read_community_type_p {
        {-user_id ""}
        {-community_type:required}
    } {
        Check if a user can read a community type
    } {
        # FIXME: permission hack
        # NOT SURE HOW TO FIX THIS WITHOUT object_ids on community types
        return 1
    }

    ad_proc -public require_user_read_community_type {
        {-user_id ""}
        {-community_type:required}
    } {
        require that a user be able to read a community type
    } {
        if {![user_can_read_community_type_p -user_id $user_id -community_type $community_type]} {
            do_abort
        }
    }

    ad_proc -public user_can_read_community_p {
        {-user_id ""}
        {-community_id:required}
    } {
        Check if a user can read a community
    } {
        return [permission::permission_p \
            -party_id $user_id \
            -object_id $community_id \
            -privilege "dotlrn_view_community" \
        ]
    }

    ad_proc -public require_user_read_community {
        {-user_id ""}
        {community_id:required}
    } {
        require that a user be able to read a community
    } {
        if {![user_can_read_community_p -user_id $user_id -community_id $community_id]} {
            do_abort
        }
    }

    ad_proc -public user_is_community_member_p {
        {-user_id ""}
        {-community_id:required}
    } {
        check if a user is a member of a community
    } {
        if {$user_id eq ""} {
            set user_id [ad_conn user_id]
        }

        return [dotlrn_community::member_p $community_id $user_id]
    }

    ad_proc -public require_user_community_member {
        {-user_id ""}
        community_id
    } {
        require that a user be member of a particular community
    } {
        if {![user_is_community_member_p -user_id $user_id -community_id $community_id]} {
            do_abort
        }
    }

    ad_proc -public user_can_admin_community_p {
        {-user_id ""}
        {-community_id:required}
    } {
        check if a user can admin a community
    } {
        return [permission::permission_p -party_id $user_id -object_id $community_id -privilege dotlrn_admin_community]
    }

    ad_proc -public require_user_admin_community {
        {-user_id ""}
        {-community_id:required}
    } {
        require that user be able to admin a community
    } {
        if {![user_can_admin_community_p -user_id $user_id -community_id $community_id]} {
            do_abort
        }
    }

    ad_proc -public user_can_spam_community_p {
        {-user_id ""}
        {-community_id:required}
    } {
        check if a user can admin a community
    } {
        return [permission::permission_p -party_id $user_id -object_id $community_id -privilege dotlrn_spam_community]
    }

    ad_proc -public require_user_spam_community {
        {-user_id ""}
        {-community_id:required}
    } {
        require that user be able to spam a community
    } {
        if {![user_can_spam_community_p -user_id $user_id -community_id $community_id]} {
            do_abort
        }
    }

    ad_proc -public admin_p {
        {-user_id ""}
    } {
        check if a user is admin for dotLRN
    } {
        return [permission::permission_p -party_id $user_id -object_id [dotlrn::get_package_id] -privilege admin]
    }

    ad_proc -public require_admin {
        {-user_id ""}
    } {
        require that a user have admin privileges on all of dotlrn
    } {
        if {![admin_p -user_id $user_id]} {
            do_abort
        }
    }

}


# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
