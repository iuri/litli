# Includable template pair that can be used to show the latest photo
# from a photo-album instance or from all instances on the server.

# written by Jarkko Laine (jarkko.m.laine@tut.fi)
# @author: Bart Teeuwisse (bart.teeuwisse@thecodemill.biz)
# @author: Jade Rubick (jade@rubick.com)

# Usage:
#  <include src="/packages/photo-album/www/latest-photo" url="/path/to/your/photo-album">
# or
#  <include src="/packages/photo-album/www/latest-photo" package_id="1473"> where 1473
#    is the package_id of your photo-album instance.
# or
#  <include src="/packages/photo-album/www/latest-photo" photo_id="9912"> where 9912
#    is the photo_id of a photo in one of your albums.
# or
#  <include src="/packages/photo-album/www/latest-photo" album_id="2983"> where 2983
#    is the album_id of an album in one of your packages. 
#  It is not possible to give package_id and album_id at the same time (as it would not make sense anyway).

# If neither package_id, album_id nor url is defined, the latest photo is taken from all photos
# in the system.

# Expects:
#  photo_id:optional
#  package_id:optional
#  url:optional
#  size:optional (thumb, viewer) (thumb is default)

# Use the position specified by the caller, default is left.

if {![info exists latest:position]} {
    set latest:position left
}

# If the caller specified a URL, then we gather the package_id from that URL

if {[info exists url]} {
    
    # Let's add the leading/tailing slashes so the url's will always work
    
    set url [string trim $url]
    if {[string index $url 0] ne "/" } {
        set url "/$url"
    }
    if {[string index $url end] ne "/" } {
        set url "$url/"
    }
    
    array set pa_site_node [site_node::get \
				-url $url]
    set package_id $pa_site_node(object_id)
}

# Determain the display size of the photo.

if {![info exists size]} {
    set size "thumb"
}
switch -exact $size {
    viewer {
	
	# Get the normal size photo
 
	set size_clause [db_map size_clause_normal]
    }
    default {
    
	# Grab the thumbnail
	
	set size_clause [db_map size_clause_thumb]
    }
}

# If they supplied neither url nor package_id, the latest photo
# is shuffled across all the photos in the system.

if {[info exists album_id]} {
    set photo_clause "and ci.parent_id = :album_id"
} else {
    set photo_clause ""
}

if {![info exists package_id]} {
    if {[info exists photo_id]} {
	# A photo ID was provided. Limit the query to that photo.

	set photo_clause [db_map photo_clause]
    }

    if {[catch {db_1row get_latest_photo_all {}} err_msg]} {
	ns_log error "No latest photo found: $err_msg"
	set found_p 0
    } else {
	set found_p 1
    }
} else {
    set root_folder_id [pa_get_root_folder $package_id]
    if {[catch {db_1row get_latest_photo_folder {}} err_msg]} {
	ns_log error "No latest photo found in folder $root_folder_id: $err_msg"
	set found_p 0
    } else {
	set found_p 1
    }
}

# if no url or package_id  were given, we have to find out
# which package the photo belongs to

if {![info exists package_id] 
    && ![info exists url] && $found_p == 1} {
    set url [db_string get_url ""]
}

ad_return_template
