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

#
# /news-portlet/www/news-portlet.tcl
#
# arjun@openforce.net
#
# The logic for the news portlet
#
# $Id: news-portlet.tcl,v 1.22.2.3 2016/06/07 10:16:56 hectorr Exp $
# 

array set config $cf	
set shaded_p $config(shaded_p)
if { $config(shaded_p)=="t" } {
   return
}

set news_url [ad_conn package_url]
set comm_id [dotlrn_community::get_community_id_from_url -url $news_url]
if {$comm_id ne ""} {
    set root_id [ad_conn node_id]
    set user_id [ad_conn user_id]
    set inside_comm_p 1
} else {
    set inside_comm_p 0
}

# Should be a list already! XXX rename me!
set list_of_package_ids $config(package_id)
set one_instance_p [ad_decode [llength $list_of_package_ids] 1 1 0]

set display_item_content_p [parameter::get_from_package_key \
    -package_key news-portlet \
    -parameter display_item_content_p \
    -default 0]
set display_item_lead_p [parameter::get_from_package_key \
    -package_key news-portlet \
    -parameter display_item_lead_p \
    -default 1]
set display_subgroup_items_p [parameter::get_from_package_key \
    -package_key news-portlet \
    -parameter display_subgroup_items_p \
    -default 0]
set display_item_attribution_p [parameter::get_from_package_key \
    -package_key news-portlet \
    -parameter display_item_attribution_p \
    -default 1]



if { $inside_comm_p } {
    set package_id $config(package_id)
    set rss_exists [rss_support::subscription_exists -summary_context_id $package_id -impl_name news]
    set rss_url "[news_util_get_url $package_id]rss/rss.xml"
    set news_url [news_util_get_url $package_id]

    if { $display_subgroup_items_p } {
        db_foreach select_subgroup_package_ids {} {
            set one_instance_p 0
            lappend list_of_package_ids $package_id
        }
    }
}

set content_column ""

if { $display_item_content_p } { 
    lappend content_column publish_body publish_format
}
if { $display_item_lead_p }  {
    lappend content_column publish_lead
}

if {[llength $content_column] > 0 } {
    set content_column ,[join $content_column ,]
}

db_multirow -extend { publish_date view_url creator_url} news_items select_news_items {} {
    set publish_date [lc_time_fmt $publish_date_ansi "%q"]
    if { [info exists ipackages($package_id)] } {set url $ipackages($package_id)}
    set view_url [export_vars -base "${url}item" { item_id }]
    set creator_url ""

    # text-only body
    if {$display_item_content_p } {
        set publish_body \
            [ad_html_text_convert -from $publish_format -to text/html -- $publish_body]
    }
    if { $display_item_attribution_p } {
        set creator_url [acs_community_member_url -user_id $creation_user]
    }
}

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
