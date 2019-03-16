ad_page_contract {

    Returns a JSON structure suitable for building the 
        thumbnails in the carousel.

    Requires the album_id from where we will get the photos


    @author Hamilton Chua (ham@solutiongrove.com)
    @creation-date 2007-11-25

} {
    album_id:integer,notnull
    package_id:integer,notnull
    {start ""}
    {limit ""}
}

set user_id [ad_conn user_id]
set package_url [apm_package_url_from_id $package_id]

# paging
set all_photos_in_album [pa_all_photos_in_album $album_id]
set total_photos [llength $all_photos_in_album]
set images_per_page $limit
set start_index $start
set end_index [expr $start + ($images_per_page - 1)]
set photos_on_page [lrange $all_photos_in_album $start_index $end_index]

if { [llength $photos_on_page] == 0 } {  set photos_on_page 0}

db_multirow -extend { title caption shortcaption story path fullimage_path thumb_photo_id view_image_id} photos photos_query "
      select ci.item_id as photo_id,
      i.image_id as thumb_path,
      i.height as thumb_height,
      i.width as thumb_width
    from cr_items ci,
      cr_items ci2,
      cr_child_rels ccr2,
      images i
    where ccr2.relation_tag = 'thumb'
      and ci.item_id = ccr2.parent_id
      and ccr2.child_id = ci2.item_id
      and ci2.live_revision = i.image_id
      and ci.live_revision is not null
      and ci.item_id in ([join $photos_on_page ","]) order by ci.item_id desc
"  {

    set path "${package_url}images/${thumb_path}"
    set thumb_photo_id $thumb_path

    db_0or1row "get_vw" "select
            pp.caption,
            pp.story,
            cr.title,
            i.image_id as view_image_id
        from cr_items ci,
            cr_revisions cr,
            pa_photos pp,
            cr_items ci2,
            cr_child_rels ccr2,
            images i
        where cr.revision_id = pp.pa_photo_id
            and ci.live_revision = cr.revision_id
            and ci.item_id = ccr2.parent_id
            and ccr2.child_id = ci2.item_id
            and ccr2.relation_tag = 'viewer'
            and ci2.live_revision = i.image_id
            and ci.item_id = :photo_id"

    if { ![exists_and_not_null caption] } { set caption "&nbsp;" } else { set caption [ajaxpa::json_normalize -value $caption] }
    set story [ajaxpa::json_normalize -value $story]
    set fullimage_path "${package_url}images/${view_image_id}/${title}"
    if { [string length $caption] > 10} {
        set shortcaption [string range $caption 0 11]
        append shortcaption ".."
    } else {
        set shortcaption $caption
    }
}

ad_return_template