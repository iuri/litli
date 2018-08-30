# packages/photo-album/www/photos-edit.tcl

ad_page_contract {
    Bulk edit photos in a given album

    @author Jeff Davis (davis@xorch.net)
    @creation-date 7/1/2002
    @cvs-id $Id: photos-edit.tcl,v 1.9 2015/06/28 12:56:09 gustafn Exp $
} {
    album_id:naturalnum,notnull
    {page:integer,notnull "1"}
} -validate {
    valid_album -requires {album_id:integer} {
	if [string equal [pa_is_album_p $album_id] "f"] {
	    ad_complain "[_ photo-album._The_1]"
	}
    }
} -properties {
    album_id:onevalue
    title:onevalue
    description:onevalue
    story:onevalue
    context_list:onevalue
    child_photo:multirow
    page_nav:onevalue
    admin_p:onevalue
    photo_p:onevalue
    write_p:onevalue
    move_p:onevalue
    delete_p:onevalue
}

# These lines are to uncache the image in Netscape, Mozilla. 
# IE6 & Safari (mac) have a bug with the images cache
ns_set put [ns_conn outputheaders] "Expires" "-"
ns_set put [ns_conn outputheaders] "Last-Modified" "-"
ns_set put [ns_conn outputheaders] "Cache-Control" "no-cache"

set user_id [ad_conn user_id]

# check for read permission on album
permission::require_permission -object_id $album_id -privilege read

set context_list [pa_context_bar_list -final "[_ photo-album.Edit_page] $page" $album_id]


db_1row get_album_info {
select cr.title,
  cr.description,
  pa.story,
  ci.parent_id as parent_folder_id,
  decode(acs_permission.permission_p(ci.item_id, :user_id, 'admin'),'t',1,0) as admin_p,
  decode(acs_permission.permission_p(ci.item_id, :user_id, 'pa_create_photo'),'t',1,0) as photo_p,
  decode(acs_permission.permission_p(ci.item_id, :user_id, 'write'),'t',1,0) as write_p,
  decode(acs_permission.permission_p(ci.parent_id, :user_id, 'write'),'t',1,0) as folder_write_p,
  decode(acs_permission.permission_p(ci.item_id, :user_id, 'delete'),'t',1,0) as album_delete_p
from cr_items ci,
  cr_revisions cr,
  pa_albums pa
where ci.live_revision = cr.revision_id
  and ci.live_revision = pa_album_id
  and ci.item_id = :album_id
}
# to move an album need write on album and write on parent folder
set move_p [expr {$write_p  && $folder_write_p}]

# to delete an album, album must be empty, need delete on album, and write on parent folder
set has_children_p [expr {[pa_count_photos_in_album $album_id] > 0}]
set delete_p [expr {!($has_children_p) && $album_delete_p && $folder_write_p}]

set photos_on_page [pa_all_photos_on_page $album_id $page]

if {$has_children_p && [llength $photos_on_page] > 0} {
    # query gets all child photos in album
    # I query the data without an orderby in the sql to cut the querry time
    # and then sort the returned data manually while constructing the multirow datasource.
    # This goes against the theory of let oracle do the hard work, but load testing and
    # query tuning showed that the order by doubled the query time while sorting a few rows in tcl was fast

    # wtem@olywa.net, 2001-09-24


    set photo_sql "
    select  coalesce(ci.live_revision,0) as hide_p, 
      ci.item_id as photo_id,
      pp.caption,
      pp.story as photo_story,
      to_char(pp.date_taken, 'MM/DD/YYYY HH:MI') as datetaken,
      ccra.order_n as sequence,
      pp.camera_model,
      pp.focal_length, 
      pp.aperture,
      pp.exposure_time,
      pp.flash,
      it.image_id as thumb_path,
      it.height as thumb_height,
      it.width as thumb_width,
      iv.image_id as viewer_path,
      iv.height as viewer_height,
      iv.width as viewer_width,
      cr.title as photo_title,
      cr.description as photo_description
    from cr_items ci,
      cr_items cit,
      cr_child_rels ccrt,
      images it,
      cr_items civ,
      cr_child_rels ccrv,
      images iv,
      pa_photos pp,
      cr_revisions cr,
      cr_child_rels ccra
      where 
          ccrt.relation_tag = 'thumb'
      and cr.revision_id = ci.latest_revision
      and cr.item_id = ci.item_id
      and ci.item_id = ccrt.parent_id
      and ccrt.child_id = cit.item_id
      and cit.latest_revision = it.image_id
      and ccrv.relation_tag = 'viewer'
      and ci.item_id = ccrv.parent_id
      and ccrv.child_id = civ.item_id
      and civ.latest_revision = iv.image_id
      and ccra.parent_id = :album_id
      and ccra.child_id = ci.item_id
      and pp.pa_photo_id = ci.latest_revision
      and ci.item_id in ([join $photos_on_page ","])"

    db_foreach get_child_photos $photo_sql {
        set val(hide_p) $hide_p
        set val(photo_id) $photo_id
        set val(sequence) $sequence
        set val(caption) $caption
        set val(photo_story) $photo_story
        set val(photo_description) $photo_description
        set val(photo_title) $photo_title
        set val(datetaken) $datetaken
        set val(camera_model) $camera_model
        set val(focal_length) $focal_length
        set val(aperture) $aperture
        set val(flash) $flash
        set val(exposure_time) $exposure_time
        set val(thumb_path) $thumb_path
        set val(thumb_height) $thumb_height
        set val(thumb_width) $thumb_width
        set val(viewer_path) $viewer_path
        set val(viewer_height) $viewer_height
        set val(viewer_width) $viewer_width
        set val(window_height) [expr {$viewer_height + 28}]
        set val(window_width) [expr {$viewer_width + 24}]
        set child($photo_id) [array get val]
    }
    
    # if the structure of the multirow datasource ever changes, this needs to be rewritten    
    set counter 0
    foreach id $photos_on_page {
        if {[info exists child($id)]} { 
            incr counter 
            set child_photo:${counter}(rownum) $counter
            foreach {key value} $child($id) {
                set child_photo:${counter}($key) $value
            }
        }
    }

    set child_photo:rowcount $counter

    set total_pages [pa_count_pages_in_album $album_id]

    for {set i 1} {$i <= $total_pages} {incr i} {
        lappend pages $i
    }
    set page_nav [pa_pagination_bar $page $pages "[export_vars -base photos-edit {album_id}]&page="]


} else {
    # don't bother querying for children if we know they don't exist
    set child_photo:rowcount 0
    set page_nav ""
}
