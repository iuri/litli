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
    Procs to manage dotLRN Applets

    @author ben@openforce.net
    @creation-date 2001-10-01
}

namespace eval dotlrn_applet {

    ad_proc -public get_url {} {
        # MAJOR FIXME NOW
        return "[dotlrn::get_url]/applets"
    }

    ad_proc -public get_applet_url {
        {-applet_key:required}
    } {
        set applets_node_id [site_node::get_node_id -url [get_url]]
        return [site_node::get_children -package_key $applet_key -node_id $applets_node_id]
    }

    ad_proc -public is_initalized {} {
        return [site_node::exists_p -url "[get_url]/"]
    }

    ad_proc -public init {} {
        site_node::new -name applets -parent_id [dotlrn::get_node_id]
    }

    ad_proc -public applet_exists_p {
        {-applet_key:required}
    } {
        check whether "applet_key" is a real dotLRN applet
    } {
        return [db_string select_applet_exists_p {}]
    }

    ad_proc -public add_applet_to_dotlrn {
        {-applet_key:required}
        {-package_key:required}
        {-active_p t}
    } {
        dotlrn-init.tcl calls AddApplet on all applets using acs_sc directly.
        The add_applet proc in the applet (e.g. dotlrn-calendar) calls this
        proc to tell dotlrn to register and/or activate itself. This _must_
        be able to be run multiple times!
    } {
        if {[get_applet_id_from_key -applet_key $applet_key] ne ""} {
            return
        }

        set applet_id [db_nextval acs_object_id_seq]
        db_dml insert {}
    }

    ad_proc -public get_applet_id_from_key {
        {-applet_key:required}
    } {
        get the id of the dotlrn applet from the applet key or the null
        string if the key dosent exist
    } {
        return [db_string select {} -default ""]
    }

    ad_proc -public mount {
        {-package_key:required}
        {-url ""}
        {-pretty_name ""}
    } {
        if {$url eq ""} {
            set url $package_key
        }

        set parent_node_id [site_node::get_node_id -url [get_url]]

        set package_id [dotlrn::mount_package \
            -parent_node_id $parent_node_id \
            -package_key $package_key \
            -url $url \
            -directory_p t \
            -pretty_name $pretty_name \
        ]

        return $package_id
    }

    ad_proc -public get_applet_url {
        {applet_key:required}
    } {
        get the applet's url
    } {
    }

    ad_proc -public list_applets {} {
        list the applet_keys for all dotlrn applets
    } {
        return [util_memoize {dotlrn_applet::list_applets_not_cached}]
    }

    ad_proc -private list_applets_not_cached {} {
        list the applet_keys for all dotlrn applets
    } {
        return [db_list select_dotlrn_applets {}]
    }

    ad_proc -public is_applet_mounted {
        {-applet_key:required}
    } {
        is the applet specified mounted
    } {
        if { [llength [site_node::get_package_url -package_key [get_package_key -applet_key $applet_key]]] > 0 } {
            return 1
        } else {
            return 0
        }
    }

    ad_proc -public list_mounted_applets {} {
        list all applets that are mounted
    } {
        set applets [list]

        foreach applet [list_applets] {
            if {[is_applet_mounted -applet_key $applet]} {
                lappend applets $applet
            }
        }

        return $applets
    }

    ad_proc -public get_package_key {
        {-applet_key:required}
    } {
        get the package key associated with the given applet
    } {
        return [util_memoize "dotlrn_applet::get_package_key_not_cached -applet_key $applet_key"]
    }

    ad_proc -private get_package_key_not_cached {
        {-applet_key:required}
    } {
        get the package key associated with the given applet
    } {
        return [db_string select_package_key_from_applet_key {} -default ""]
    }

    ad_proc -public dispatch {
        {-op:required}
        {-list_args {}}
    } {
        foreach applet [list_applets] {
            applet_call $applet $op $list_args
        }
    }

    ad_proc -public applet_call {
        applet_key
        op
        {list_args {}}
    } {
        call a particular applet op
    } {
        acs_sc::invoke -contract dotlrn_applet -operation $op -call_args $list_args -impl $applet_key
    }

}


# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
