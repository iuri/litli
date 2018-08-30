ad_library {
    Photo Album - Search Service Contracts

    @creation-date 2004-06-01
    @author Jeff Davis davis@xarg.net
    @cvs-id $Id: photo-album-search-procs.tcl,v 1.2 2004/07/26 13:07:42 jeffd Exp $
}

namespace eval photo_album::search {}
namespace eval photo_album::search::album {}
namespace eval photo_album::search::photo {}

ad_proc -private photo_album::search::album::datasource { album_id } {
    return the indexable content for an album.
    can index a revision_id or a cr_item.item_id for photo_album

    @param album_id the item_id or revision id to index.

    @creation-date 2004-06-01
    @author Jeff Davis davis@xarg.net
} {
    # get the best revision to show if it's an item_id otherwise assume we got a pa_album revision.
    set revision_id [db_string best_revision {select coalesce(live_revision, latest_revision) from cr_items where item_id = :album_id} -default $album_id]

    db_0or1row album_datasource {
        select r.title,
          r.title || ' ' || r.description || ' ' || a.story || ' photographer: ' || a.photographer as content,
          'text/html' as mime, 
          '' as keywords,
          'text' as storage_type
        from cr_revisions r, pa_albums a
        where r.revision_id = :revision_id 
          and a.pa_album_id = r.revision_id
    } -column_array datasource

    set datasource(object_id) $album_id

    return [array get datasource]
}

ad_proc -private  photo_album::search::album::url { album_id } {
    returns a url for a message to the search package

    @param album_id - either a revision_id or an item_id for an album

    @creation-date 2004-06-01
    @author Jeff Davis davis@xarg.net
} {
    db_0or1row package {
        SELECT n.node_id, i1.item_id
        FROM cr_items i1, cr_items i2, pa_package_root_folder_map m, site_nodes n
        WHERE m.folder_id = i2.item_id
          and i1.item_id = coalesce((select item_id from cr_revisions where revision_id = :album_id),:album_id)
          and n.object_id = m.package_id
          and i1.tree_sortkey between i2.tree_sortkey and tree_right(i2.tree_sortkey)
    }

    return "[ad_url][site_node::get_element -node_id $node_id -element url]album?album_id=$item_id"
}


ad_proc -private photo_album::search::register_implementations {} {
    Register the forum_forum and forum_message content type fts contract
} {
    db_transaction {
        photo_album::search::register_album_fts_impl
        photo_album::search::register_photo_fts_impl
    }
}



ad_proc -private photo_album::search::photo::datasource { photo_id } {
    return the indexable content for an album.
    can index a revision_id or a cr_item.item_id for photo_album

    @param photo_id the item_id or revision id to index.

    @creation-date 2004-06-01
    @author Jeff Davis davis@xarg.net
} {
    # get the item_id if we got a revision_id
    set item_id [db_string item_id {select item_id from cr_revisions where revision_id = :photo_id} -default $photo_id]

    photo_album::photo::get -photo_id $item_id -array photo

    # get the base url
    set base [photo_album::photo::package_url -photo_id $item_id]
    set full "[ad_url]$base"

    set ::lev [info level]
    namespace eval ::template { 
        variable parse_level 
        lappend parse_level $::lev
    }
    set body [template::adp_include /packages/photo-album/lib/one-photo [list &photo "photo" base $base style feed]]
    namespace eval ::template { 
        variable parse_level 
        template::util::lpop parse_level
    }


    return [list object_id $photo_id \
                title $photo(title) \
                mime "text/html" \
                keywords {} \
                storage_type text \
                content $body \
                syndication [list link "${full}photo/photo_id=$item_id" \
                                 description "$photo(description) $photo(caption)" \
                                 author $photo(username) \
                                 category photos \
                                 guid "[ad_url]/o/$item_id" \
                                 pubDate $photo(created_ansi)] \
            ]
}

ad_proc -private  photo_album::search::photo::url { photo_id } {
    returns a url for a message to the search package

    @param photo_id - either a revision_id or an item_id for an album

    @creation-date 2004-06-01
    @author Jeff Davis davis@xarg.net
} {
    db_0or1row package {
        SELECT n.node_id, i1.item_id
        FROM cr_items i1, cr_items i2, pa_package_root_folder_map m, site_nodes n
        WHERE m.folder_id = i2.item_id
          and i1.item_id = coalesce((select item_id from cr_revisions where revision_id = :photo_id),:photo_id)
          and n.object_id = m.package_id
          and i1.tree_sortkey between i2.tree_sortkey and tree_right(i2.tree_sortkey)
    }

    return "[ad_url][site_node::get_element -node_id $node_id -element url]photo?photo_id=$item_id"
}


ad_proc -private photo_album::search::unregister_implementations {} {
    db_transaction { 
        acs_sc::impl::delete -contract_name FtsContentProvider -impl_name pa_album
        acs_sc::impl::delete -contract_name FtsContentProvider -impl_name pa_photo
    }
}

ad_proc -private photo_album::search::album::register_fts_impl {} {
    set spec {
        name "pa_album"
        aliases {
            datasource photo_album::search::album::datasource
            url photo_album::search::album::url
        }
        contract_name FtsContentProvider
        owner photo-album
    }

    acs_sc::impl::new_from_spec -spec $spec
}


ad_proc -private photo_album::search::photo::register_fts_impl {} {
    set spec {
        name "pa_photo"
        aliases {
            datasource photo_album::search::photo::datasource
            url photo_album::search::photo::url
        }
        contract_name FtsContentProvider
        owner photo-album
    }

    acs_sc::impl::new_from_spec -spec $spec
}
