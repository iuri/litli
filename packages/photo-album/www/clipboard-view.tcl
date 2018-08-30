ad_page_contract {
    display the images in a given clipboard

    @author Jeff Davis (davis@xarg.net)
    @creation-date 2002-10-30
    @cvs-id $Id: clipboard-view.tcl,v 1.8 2014/08/07 07:59:50 gustafn Exp $
} { 
    collection_id:naturalnum,notnull
} -properties { 
    context:onevalue
    title:onevalue
    owner_id:onevalue
    owner_name:onevalue
    user_id:onevalue
    base_url:onevalue
    images:multirow
    shutterfly_p:onevalue
}

set user_id [ad_conn user_id]

if {![db_0or1row collection {select first_names || ' ' || last_name as owner_name, owner_id, pa_collections.title from pa_collections, cc_users where collection_id = :collection_id and owner_id = user_id}] } {
    ad_return_complaint 1 "<#_<li> invalid clipboard#>"
    ad_script_abort
} 

# Check that the user is permissioned for this collection.
permission::require_permission -party_id $user_id -object_id $collection_id -privilege read

set context [list [list clipboards Clipboards] $title]

db_multirow images get_images {
    select m.photo_id, p.image_id, p.height, p.width, p.caption, to_char(p.date_taken, 'Mon FMDD, YYYY') as taken, f.width as base_width, f.image_id as base_id, f.height as base_height
      from pa_collection_photo_map m, 
           all_photo_images p,
           all_photo_images f
 where collection_id = :collection_id
   and p.item_id = m.photo_id
   and p.relation_tag = 'thumb'
   and f.item_id = m.photo_id
   and f.relation_tag = 'base'
}

set shutterfly_p [parameter::get -parameter ShowShutterflyLinkP -default f]

set returnurl "[ad_url][ad_conn package_url]"
set base_url  "[ad_url][ad_conn package_url]images/"
