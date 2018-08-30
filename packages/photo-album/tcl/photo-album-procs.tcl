# /packages/photo-album/tcl/photo-album-procs.tcl
ad_library {
    TCL library for the photo-album system

    @author Tom Baginski (bags@arsdigita.com)
    @author Jeff Davis (davis@xorch.net)

    @creation-date December 14, 2000
    @cvs-id $Id: photo-album-procs.tcl,v 1.27 2018/05/09 15:33:33 hectorr Exp $
}

# wtem@olywa.net, 2001-09-19
# there are several procs that we may be able to replace 
# with standard cr procs now that it handles file system storage of images
# look for ### maybe redundant, replace calls?
# in front of said procs
# places to make partial changes are marked with
### probable partial change
# in front of them
# areas that have been worked on are marked
### clean
# changes that have been deferred marked
### skipped

ad_proc -public pa_get_root_folder {
    {package_id ""}
} {
    Returns the folder_id of the root folder for an instance of the photo album system.
    If no root folder exists, as when a new package instance is accessed for the first time,
    a new root folder is created automatically with appropriate permissions
    If value has be previously requested, value pulled from cache
} { 
    if {$package_id eq ""} {
	set package_id [ad_conn package_id]
    }
    return [util_memoize "pa_get_root_folder_internal $package_id"]
}

ad_proc -private pa_get_root_folder_internal {
    {package_id}
} {
    Returns the folder_id of the root folder for an instance of the photo album system.
    If no root folder exists, as when a new package instance is accessed for the first time,
    a new root folder is created automatically with appropriate permissions
} {
    set folder_id [db_string pa_root_folder "select photo_album.get_root_folder(:package_id) from dual"]

    if { $folder_id eq "" } {
	set folder_id [pa_new_root_folder $package_id]
    }
    return $folder_id
}

ad_proc -private pa_new_root_folder {
    {package_id ""}
} {
    Creates a new root folder for a package, and returns id.
    A hackish function to get around the fact that we can't run
    code automatically when a new package instance is created.

} {
    if {$package_id eq ""} {
	set package_id [ad_conn package_id]
    }

    # wtem@olywa.net, 2001-09-22
    # the PhotoDir parameter goes away with new CR storage scheme

    # wtem@olywa.net, 2001-09-22
    # original pl/sql wrapped up in function to simplify code and porting
    db_transaction {
	# create new root folder
    
	set new_folder_id [db_exec_plsql make_new_root {
	begin
	:1 := photo_album.new_root_folder(:package_id);
	end;
	}]
    
	# grant default permissions to new root folder

	# default permissions stored in package parmeter as a list of grantee privilege pairs
	# the grantee can be anything that is or returns a party_id such as an integer, a subquery,
	# or a function
	
	set perm_lst [split [parameter::get -parameter DefaultRootFolderPrivileges] " "]

	foreach {party privilege}  $perm_lst {
	    # wtem@olywa.net, 2001-10-15
	    # urgh, originally the parameter had the pl/sql embedded in it
	    set grantee_id [db_string get_grantee_id "select acs.magic_object_id('$party') from dual"]
	  
	    db_exec_plsql grant_default {
		begin
		  acs_permission.grant_permission (
	            object_id  => :new_folder_id,
	            grantee_id => :grantee_id,
	            privilege  => :privilege
		  );
		end;
	    }
	}
    }
    # since this is executed the first time a package instance is accessed,
    # make sure the upload dir exists

    ### probable partial change
    # wtem@olywa.net, 2001-09-19
    # this initializes corresponding directory structure in the file-system
    # we should be able to eliminate this now that we are using CR storage
    # pa_assert_dir -check_base_path ""
    ### clean
    return $new_folder_id
}

ad_proc -public pa_get_folder_name {
    folder_id
} {
    Returns the name of a folder. 
} {
    return [db_string folder_name "
    select content_folder.get_label(:folder_id) from dual"]
}

ad_proc -public pa_get_folder_description {
    folder_id
} {
    Returns the description of a folder. 
} {
    return [db_string folder_description "
    select description from cr_folders where folder_id = :folder_id"]
}


ad_proc pa_context_bar_list {
    {-final ""}
    item_id
} {
    Constructs the list to be fed to ad_context_bar appropriate for
    item_id.  If -final is specified, that string will be the last 
    item in the context bar.  Otherwise, the name corresponding to 
    item_id will be used.

    modified from fs_context_bar
} {
    set root_folder_id [pa_get_root_folder]

    if {$item_id == $root_folder_id} {
        if {$final ne ""} { 
            return [list $final]
        } else { 
            return {}
        }
    }

    if {$final eq ""} {
	# set start_id and final with a single trip to the database

	db_1row get_start_and_final "select parent_id as start_id,
	  content_item.get_title(item_id,'t') as final
	  from cr_items where item_id = :item_id"

	#set start_id [db_string parent_id "
	#select parent_id from cr_items where item_id = :item_id"]
	#set final [db_string title "select content_item.get_title(:item_id,'t') from dual"]

    } else {
	set start_id $item_id
    }

    if {$start_id != $root_folder_id} {
    set context_bar [db_list_of_lists context_bar "
    select decode(
             content_item.get_content_type(i.item_id),
             'content_folder',
             'index?folder_id=',
             'pa_album',             
             'album?album_id=',
             'photo?photo_id='
           ) || i.item_id,
           content_item.get_title(i.item_id,'t')
    from   cr_items i
    connect by prior i.parent_id = i.item_id
      and i.item_id != :root_folder_id
    start with item_id = :start_id
    order by level desc"]
    }
    lappend context_bar $final

    return $context_bar
}

# wtem@olywa.net, 2001-09-24
### clean
ad_proc -public pa_make_file_name {
    {-ext ""}
    id
} { 
    constructs a filename for an image based on id and extension.
} {
    if {$ext ne "" && ![regexp {^\.} $ext foo]} {
	#add back the dot
	set ext ".${ext}"
    }
    set total_file_name "${id}${ext}"

    return $total_file_name
}

### maybe redundant, replace calls?
# wtem@olywa.net, 2001-09-22
### skipped
# will handle when we get to the places where this is called
ad_proc -private pa_assert_dir {
    {-check_base_path:boolean}
    {dir_path}
} {
    Ensures that dirname exists under the PhotoDir Directory  
    If -check_base_path flag specified, proc also checks if base path exists and adds it if necessary

    Won't cause an error if the directory is already there. Better than the stardard
    mkdir because it will make all the directories leading up to dirname
    borrowed from 3.4 download code
} {  
    if { $check_base_path_p } {
	set dir_path "[acs_root_dir]/[parameter::get -parameter PhotoDir]/$dir_path"
	set needed_dir ""
    } else {
	set needed_dir "[acs_root_dir]/[parameter::get -parameter PhotoDir]"
    }
    
    set dir_list [split $dir_path /]
    
    foreach dir $dir_list {
	ns_log Debug "pa_assert_dir: Checking: $dir"
        if {$dir eq ""} {
            continue
        }
        append needed_dir "/$dir"
        if {![file exists $needed_dir]} {
	    ns_log Debug "pa_assert_dir: file mkdir $dir"
            file mkdir $needed_dir
        }
    }
}

ad_proc -public pa_is_folder_p {
    folder_id
    {package_id ""}
} {
    returns "t" if folder_id is a folder that is a child of the root folder for the package,
    else "f"
}  {
    return [pa_is_type_in_package $folder_id "content_folder" $package_id]
}

ad_proc -public pa_is_album_p {
    album_id
    {package_id ""}
} {
    returns "t" if album_id is a pa_album that is a child of the root folder for the package,
    else "f"
}  {
    return [pa_is_type_in_package $album_id "pa_album" $package_id]
}

ad_proc -public pa_is_photo_p {
    photo_id
    {package_id ""}
} {
    returns "t" if photo_id is a pa_photo that is a child of the root folder for the package,
    else "f"
}  {
    return [pa_is_type_in_package $photo_id "pa_photo" $package_id]
}

ad_proc -private pa_is_type_in_package {
    item_id
    content_type
    {package_id ""}
} {
    returns "t" if item_id is of the specified content_type and is a child of the root folder of the package,
    else returns "f"
} {
    set root_folder [pa_get_root_folder $package_id]

    # I check for the case that item is the root_folder first because
    # this happens on the index page.  Since index page accessed
    # often, and the root_folder is within the package this avoids an
    # unnecessary trip to the database on a commonly accessed page.
 
    if {$content_type eq "content_folder" && $item_id eq $root_folder} {
	return "t"
    } else {
	return [db_string check_is_type_in_package "select decode((select 1 
	from dual
	where exists (select 1 
	    from cr_items 
	    where item_id = :root_folder 
	    connect by prior parent_id = item_id 
	    start with item_id = :item_id)
	  and content_item.get_content_type(:item_id) = :content_type
	), 1, 't', 'f')
	from dual" ]
    }
}

ad_proc -public pa_grant_privilege_to_creator {
    object_id
    {user_id ""}
} {
    Grants a set of default privileges stored in parameter PrivilegeForCreator
    on object id to user_id.  If user_id is not specified, uses current user.
} {
    if {$user_id eq ""} {
	set user_id [ad_conn user_id]
    }
    set grant_list [split [parameter::get -parameter PrivilegeForCreator] ","]
    foreach privilege $grant_list {
	db_exec_plsql grant_privilege {
	    begin
	      acs_permission.grant_permission (
	        object_id  => :object_id,
	        grantee_id => :user_id,
	        privilege  => :privilege
	      );
	    end;
	}
    } 
}

ad_proc -public pa_image_width_height {
    filename
    width_var
    height_var
} {
    Uses ImageMagick program to get the width and height in pixels of filename.
    Sets height to the variable named in height_var in the calling level.
    Sets width_var to the variable named in width_var in the calling level.

    I Use ImageMagick instead of aolserver function because it can handle more than
    just gifs and jpegs.  
} {
    set identify_string [exec [parameter::get -parameter ImageMagickPath]/identify $filename]
    regexp {[ ]+([0-9]+)[x]([0-9]+)[\+]*} $identify_string x width height
    uplevel "set $width_var $width"
    uplevel "set $height_var $height"
}

ad_proc -public pa_make_new_image {
    base_image
    new_image
    geometry
} {
    Uses ImageMagick program to create a file named new_image from base_image that 
    fits within a box defined by geometry.  If geometry is just a number it will 
    be used for both width and height.

    ImageMagick will retain the aspect ratio of the base_image when creating the new_image
     
     jhead -dt is called to delete any embedded thumbnail since digital camera thumbnails
     can be quite large and imagemagick does not remove them when converting (so thumbnails
     can end up being 8k for the thumbnail + 32k for the embedded thumbnail). 

    @param base_image original image filename 
    @param new_image new image filename 
    @param geometry string as passed to convert 

} {
    # If we get an old style single number
    if {[regexp {^[0-9]+$} $geometry]} { 
        set geometry ${geometry}x${geometry}
    }
    ns_log debug "pa_make_new_image: Start convert, making $new_image geometry $geometry"
    exec [parameter::get -parameter ImageMagickPath]/convert -geometry $geometry -interlace None -sharpen 1x2 $base_image $new_image
    if {[catch {exec jhead -dt $new_image} errmsg]} { 
        ns_log Warning "pa_make_new_image: jhead failed with error - $errmsg"
    }
    ns_log debug "pa_make_new_image: Done convert for $new_image"
}

# wtem@olywa.net, 2001-09-22
# replaced pa_delete_scheduled_files with standard cr_delete_scheduled_files


ad_proc -public pa_all_photos_in_album {
    album_id
} {
    returns a list of all the photo_ids in an album sorted in ascending order
    pull value from cache if already there, caches result and returns result if not
} {
    return [util_memoize "pa_all_photos_in_album_internal $album_id"]
}

ad_proc -private pa_all_photos_in_album_internal {
    album_id
} {
    queries and returns a list of all photo_ids in album_id in ascending order 
} {
    return [db_list get_photo_ids {}]
}

ad_proc -public pa_count_photos_in_album {
    album_id
} {
    returns count of number of photos in album_id
} {  
    return [llength [pa_all_photos_in_album $album_id]]
}

ad_proc -public pa_all_photos_on_page {
    album_id 
    page
} {
    returns a list of the photo_ids on page page of album_id
    list is in ascending order
} {
    set images_per_page [parameter::get -parameter ThumbnailsPerPage]
    set start_index [expr {$images_per_page * ($page-1)}]
    set end_index [expr {$start_index + ($images_per_page - 1)}]
    return [lrange [pa_all_photos_in_album $album_id] $start_index $end_index]
}

ad_proc -public pa_count_pages_in_album {
    album_id
} {
    returns the number of pages in album_id
} {
    return [expr int(ceil([pa_count_photos_in_album $album_id] / [parameter::get -parameter ThumbnailsPerPage].0))]
}

ad_proc -public pa_page_of_photo_in_album {
    photo_id
    album_id
} {
    returns the page number of a photo in an album
    If photo is not in the album returns -1
} {
    set photo_index [lsearch [pa_all_photos_in_album $album_id] $photo_id]

    if {$photo_index == -1 } {
	return -1
    }

    return [expr int(ceil(($photo_index + 1)/ [parameter::get -parameter ThumbnailsPerPage].0))]
}

ad_proc -public pa_flush_photo_in_album_cache {
    album_id
} {
    Clears the cacheed value set by pa_all_photos_in_album for a single album
    Call proc on any page that alters the number or order of photos in an album.
} {
    util_memoize_flush "pa_all_photos_in_album_internal $album_id"
}

# pagination procs based on cms pagintion-procs.tcl
# when these procs get rolled into acs distribution, should use them directly

ad_proc -deprecated pa_pagination_paginate_query { 
    sql
    page
} {
    takes a query and returns a query that accounts for pagination
} {

    set rows_per_page [parameter::get -parameter ThumbnailsPerPage]
    set start_row [expr {$rows_per_page*($page-1) + 1}]

    set query "
      select *
      from
        (
          select 
            x.*, rownum as row_id
	  from
	    ($sql) x
        ) ordered_sql_query_with_row_id
      where
        row_id between $start_row and $start_row + $rows_per_page - 1"
    
    return $query
}

ad_proc -deprecated pa_pagination_get_total_pages {} {
    returns the total pages in a datasource defined by $sql
    The sql var must be defined at the calling level.
    Uplevel used so that any binde vars in query are defined
} {
    uplevel {
	return [db_string get_total_pages "
	select 
	ceil(count(*) / [parameter::get -parameter ThumbnailsPerPage])
	from
	($sql)
	"]
    }
}

ad_proc -private pa_pagination_ns_set_to_url_vars { 
    set_id
} {
    helper procedure - turns an ns_set into a list of url_vars
} {
    set url_vars {}
    set size [ns_set size $set_id]
    for { set i 0 } { $i < $size } { incr i } {
	set key [ns_set key $set_id $i]
	set value [ns_set get $set_id $key]
	lappend url_vars "$key=$value"
    }

    return [join $url_vars "&amp;"]
}


ad_proc -public pa_pagination_context_ids {
    curr 
    ids
    {context 4}
} { 
    set out {}
    set n_ids [llength $ids]

    # if the list is short enough just return it.
    if {$n_ids < 13} {
        set i 1
        foreach id $ids { 
            lappend out $id $i
            incr i
        }
        return $out
    }

    # what is the range about which to bracket
    set start [expr {[lsearch -exact  $ids $curr ] - $context}]
    
    if {($start + 2 * $context + 1) > $n_ids} { 
        set start [expr {$n_ids - 2 * $context - 1}]
    } 
    if {$start < 0} { 
        set start 0
    } 

    # tack on 1
    if {$start > 0} { 
        lappend out [lindex $ids 0] 1
    }

    # context
    foreach id [lrange $ids $start [expr {$start + 2 * $context}]] { 
        incr start
        lappend out $id $start
    }

    # tack on last
    if {$start < $n_ids} { 
        lappend out [lrange $ids end end] $n_ids
    }

    return $out
}


ad_proc -public pa_pagination_bar { 
    cur_id
    all_ids
    link
    {what {}}
} {
    given a current photo_id and and an ordered list of all the photo_id in an album
    creates an html fragment that allows user to navigate to any photo by number 
    next/previous
} {
    if { $cur_id eq "" || [llength $all_ids] < 2 } {
	return ""
    }

    set cur_index [lsearch -exact $all_ids $cur_id]
    set prev_id [lindex $all_ids $cur_index-1]
    set next_id [lindex $all_ids $cur_index+1]
    set photo_nav_html ""
    if {$what ne ""} { 
        set what "&nbsp;$what"
    }
    # append the 'prev' link
    append photo_nav_html "<div class=\"photo_album_nav\">\n"
    if { $prev_id ne "" } {
	append photo_nav_html [subst {
	    <div style="text-align: left; float: left; margin-right: 1em; margin-bottom: 1em">
	    <a href="[ns_quotehtml ${link}$prev_id]">&lt;&lt;&nbsp;[_ photo-album.Prev]$what</a>
	    </div>
	}]
    }
    # append the 'next' link
    if { $next_id ne "" } {
	append photo_nav_html [subst {
	    <div style="text-align: right; float: right; margin-left: 1em; margin-bottom: 1em">
	    <a href="[ns_quotehtml ${link}$next_id]">[_ photo-album.Netx]$what&nbsp;&gt;&gt;</a>
	    </div>
	}]
    }

    # append page number links for all pages except for this page
    append photo_nav_html "\t<div style=\"text-align: center\">\n"
    set i 0
    set last {}
    foreach {id i} [pa_pagination_context_ids $cur_id $all_ids 4] {
        if {$last ne "" && ($last + 1) != $i} {
            append photo_nav_html "&#8226;"
        } 
        set last $i
	if { $cur_id == $id } {
	    append photo_nav_html "\t\t<strong>$i</strong>\n"
	} else {
	    append photo_nav_html [subst {<a href="[ns_quotehtml ${link}$id]">$i</a>}]
	}
	
    }
    append photo_nav_html "\t</div>\n"

    append photo_nav_html "</div>\n"
    return $photo_nav_html
}


ad_proc -public pa_expand_archive {
    upload_file 
    tmpfile 
    {dest_dir_base "extract"} 
} { 
    Given an uploaded file in file tmpfile with original name upload_file 
    extract the archive and put in a tmp directory which is the return value 
    of the function 
} {
    set tmp_dir [file join [file dirname $tmpfile] [ns_mktemp "$dest_dir_base-XXXXXX"]]
    if {[catch { file mkdir $tmp_dir } errMsg ]} {
        ns_log Warning "pa_expand_archive: Error creating directory $tmp_dir: $errMsg"
        return -code error "pa_expand_archive: Error creating directory $tmp_dir: $errMsg"
    }

    set upload_file [string trim [string tolower $upload_file]]

    if {[regexp {(.tar.gz|.tgz)$} $upload_file]} { 
        set type tgz
    } elseif {[regexp {.tar.z$} $upload_file]} { 
        set type tgZ
    } elseif {[regexp {.tar$} $upload_file]} { 
        set type tar
    } elseif {[regexp {(.tar.bz2|.tbz2)$} $upload_file]} { 
        set type tbz2
    } elseif {[regexp {.zip$} $upload_file]} { 
        set type zip
    } else { 
        set type "Unknown type"
    }

    # DRB: on Mac OS X the "verify" option to tar appears to return the file
    # list on stderr rather than stdout, causing the catch to trigger.  Non-GNU
    # versions of tar don't understand fancy options (those starting with --)

    switch $type { 
        tar {
            set errp [ catch { exec tar -xf $tmpfile -C $tmp_dir } errMsg]
        }
        tgZ { 
            set errp [ catch { exec tar -xZf $tmpfile -C $tmp_dir } errMsg]
        }
        tgz { 
            set errp [ catch { exec tar -xzf $tmpfile -C $tmp_dir } errMsg]
        }
        tbz2 { 
            set errp [ catch { exec tar -xjf $tmpfile -C $tmp_dir } errMsg]
        }
        zip { 
            set errp [ catch { exec unzip -d $tmp_dir $tmpfile } errMsg]
        }
        default { 
            set errp 1 
            set errMsg "don't know how to extract $upload_file"
        }
    }
    
    if {$errp} { 
        file delete -force $tmp_dir
        ns_log Warning "pa_expand_archive: extract type $type failed $errMsg"
        return -code error "pa_expand_archive: extract type $type failed $errMsg"
    } 
    return $tmp_dir
}

ad_proc -public pa_walk { 
    dir
} {
    Walk starting at a given directory and return a list
    of all the plain files found
} { 
    set files [list]
    foreach f [glob -nocomplain [file join $dir *]] {
        set type [file type $f]
        switch $type { 
            directory { 
                set files [concat $files [pa_walk $f]]
            }
            file {
                lappend files $f 
            }
            default { 
                # Goofy file types -- just ignore them
            }
        }
    }
    return $files
}      

ad_proc -public  pa_file_info {
    file 
} {
    return the image information from a given file
} { 
    set info [list]
    if { [catch {set size [file size $file]} errMsg] } { 
        return -code error $errMsg
    } 
    if { [ catch {set out [exec [parameter::get -parameter ImageMagickPath]/identify -format "%w %h %m %k %q %#" $file]} errMsg]} { 
        return -code error $errMsg
    }            
    
    foreach {width height type colors quantum sha256} [split $out { }] {}
    switch $type { 
        JPG - JPEG {
            set mime image/jpeg
        } 
        GIF - GIF87 { 
            set mime image/gif
        } 
        PNG { 
            set mime image/png
        } 
        TIF - TIFF { 
            set mime image/tiff
        }
        default { 
            set mime {} 
        }
    }
    
    return [list $size $width $height $type $mime $colors $quantum [string trim $sha256]]
}           


ad_proc -public pa_insert_image { 
    name
    photo_id
    item_id
    rev_id
    user_id
    peeraddr
    context_id
    title
    description
    mime_type
    relation
    is_live
    path
    height
    width
    size
} { 
    if { [ad_conn isconnected] } {
        set package_id [ad_conn package_id]
    } else {
        set package_id ""
    }
    db_exec_plsql pa_insert_image {}
}

ad_proc -public pa_load_images {
    {-remove 0}
    {-client_name {}}
    {-strip_prefix {}}
    {-description {}}
    {-story {}}
    {-caption {}}
    {-feedback_mode 0}
    {-package_id {}}
    image_files 
    album_id 
    user_id
} { 
    load a list of files to the provided album owned by user_id

    @param remove 1 to delete the file after moving to the content repository

    @param client_name provide the name of the upload file (for individual uploads)

    @param strip_prefix the prefix to remove from the filename (for expanded archives)

    @param image_files list of files to process

    @param feedback_mode to provide much info of the loading process on a bulk upload

    @param package_id Optionally specify the package_id owning the album, if this is not called
                      from a page within the photo-album package itself.
} { 
    set new_ids [list]
    set peeraddr [ad_conn peeraddr]

    # Create the tmp dir if needed 
    if { $package_id eq "" } {
        set package_id [ad_conn package_id]
    }
    set tmp_path [parameter::get -parameter FullTempPhotoDir -package_id $package_id]
    if { ![file exists $tmp_path] } {
        ns_log Debug "pa_load_images: Making: tmp_photo_album_dir_path $tmp_path"
        file mkdir $tmp_path
    }

    # Fix upload name if missing
    foreach image_file $image_files {


        # Figure out what to call the file...
        if {$client_name eq ""} { 
            set upload_name $image_file
        } else { 
            set upload_name $client_name
        }
        if {$strip_prefix ne ""} { 
            regsub "^$strip_prefix" $upload_name {} upload_name
        }

        if {![regexp {([^/\\]+)$} $upload_name match client_filename]} {
            # couldn't find a match
            set client_filename $upload_name
        }

        if {[catch {set base_info [pa_file_info $image_file]} errMsg]} {
            ns_log Warning "pa_load_images: error parsing file data $image_file Error: $errMsg"
            error "pa_load_images: error parsing file data $image_file Error: $errMsg"
            continue
        }

        lassign $base_info base_bytes base_width base_height base_type base_mime base_colors base_quantum base_sha256
        
        # If we don't have a mime type we like we try to make a jpg or png 
        #
        if {$base_mime eq ""} { 
            set new_image [file join $tmp_path "tmp-[file rootname [file tail $image_file]]"]
            if {$base_colors ne "" && $base_colors < 257} { 
                # convert it to a png
                if {[catch {exec [parameter::get -parameter ImageMagickPath]/convert $image_file PNG:$new_image.png} errMsg]} { 
                    ns_log Warning "pa_load_images: Failed convert to PNG for $image_file (magicktype $base_type)" 
                }
                if { $remove } { 
                    file delete $image_file
                } 
                set image_file $new_image.png
                set remove 1
            } elseif {$base_colors ne "" && $base_colors > 256} { 
                # convert it to a jpg
                if {[catch {exec [parameter::get -parameter ImageMagickPath]/convert $image_file JPG:$new_image.jpg} errMsg]} { 
                    ns_log Warning "pa_load_images: failed convert to JPG for $image_file (magicktype $base_type)" 
                }
                if { $remove } { 
                    file delete $image_file
                } 
                set image_file $new_image.jpg
                set remove 1
            } else { 
                ns_log Warning "pa_load_images: is this file even an image: $image_file $base_type"
            }

            # get info again
            lassign [pa_file_info $image_file] base_bytes base_width base_height base_type base_mime base_colors base_quantum base_sha256
        }
        
        if {$base_mime eq "image/jpeg"} { 
            array set exif [pa_get_exif_data ${image_file}]
        } else { 
            array unset exif
        }

        set BaseExt [string tolower $base_type]
        
        if {$base_mime eq ""} { 
            ns_log Debug "pa_load_images: invalid image type $image_file $type even after convert!"
            continue 
        } 
          
        # Get all the IDs we will need 
        #
        foreach name [list photo_id photo_rev_id base_item_id base_rev_id thumb_item_id \
                          thumb_rev_id viewer_item_id viewer_rev_id] { 
            set $name [db_nextval "acs_object_id_seq"]
        }
        
        # Set the names we use in the content repository.
        #
        set image_name "${photo_rev_id}:$client_filename"
        set base_image_name "base_$client_filename"
        set vw_image_name "vw_$client_filename"
        set th_image_name "th_$client_filename"
        
        # Handle viewer file 
        #
        set viewer_size [parameter::get -parameter ViewerSize -package_id $package_id]
        set viewer_filename [pa_make_file_name -ext $BaseExt $viewer_rev_id]
        set full_viewer_filename [file join ${tmp_path} ${viewer_filename}]
        pa_make_new_image $image_file ${full_viewer_filename} $viewer_size
        foreach {viewer_bytes viewer_width viewer_height viewer_type viewer_mime viewer_colors viewer_quantum viewer_sha256} [pa_file_info $full_viewer_filename] {}

        # Handle thumb file 
        #
        set thumb_size [parameter::get -parameter ThumbnailSize -package_id $package_id]
        set thumb_filename [pa_make_file_name -ext $BaseExt $thumb_rev_id]
        set full_thumb_filename [file join $tmp_path $thumb_filename]
        pa_make_new_image ${full_viewer_filename} ${full_thumb_filename} $thumb_size
        foreach {thumb_bytes thumb_width thumb_height thumb_type thumb_mime thumb_colors thumb_quantum thumb_sha256} [pa_file_info $full_thumb_filename] {}

        # copy the tmp file to the cr's file-system
        set thumb_filename_relative [cr_create_content_file -move $thumb_item_id $thumb_rev_id ${full_thumb_filename}]
        set viewer_filename_relative [cr_create_content_file -move $viewer_item_id $viewer_rev_id ${full_viewer_filename}]
        if { $remove } { 
            set base_filename_relative [cr_create_content_file -move $base_item_id $base_rev_id $image_file]
        } else { 
            set base_filename_relative [cr_create_content_file $base_item_id $base_rev_id $image_file]
        }


        # Insert the mess into the DB
        #
        db_transaction {
            db_exec_plsql new_photo {
                declare 
                dummy  integer;
                begin

                dummy := pa_photo.new (
                                       name            => :image_name,
                                       parent_id       => :album_id,
                                       item_id         => :photo_id,
                                       revision_id     => :photo_rev_id,
                                       creation_date   => sysdate,
                                       creation_user   => :user_id,
                                       creation_ip     => :peeraddr,
                                       context_id      => :album_id,
                                       title           => :client_filename,
                                       description     => :description,
                                       is_live         => 't',
                                       caption         => :caption,
                                       story           => :story,
                                       user_filename   => :upload_name
                                       );
                end;
            }
            
            if {[array size exif] > 1} { 
                foreach {key value} [array get exif] { 
                    set tmp_exif_$key $value
                }

                # Check the datetime looks valid - clock scan works pretty well...
                if {[catch {clock scan $tmp_exif_DateTime}]} { 
                    set tmp_exif_DateTime {}
                }

                db_dml update_photo_data {}
            }

	    if {$feedback_mode} {
		ns_write "
                          <ul>
                            <li>Loading image <b>$client_filename</b></li>
                             <ul>
                               <li>General information:</li>
                                 <ul>
                                   <li>Base Name: $base_image_name</li>
                                   <li>Photo_id: $photo_id</li>
                                   <li>Width: $base_width</li>
                                   <li>Height: $base_height</li>
                                   <li>Size: $base_bytes bytes</li>
                                   <li>Base image name: $base_image_name</li>
                                 </ul>
                               <li>Thumbnail information:</li>
                                 <ul>
                                   <li>Thumnail name: $th_image_name</li>
                                   <li>Width: $thumb_width</li>
                                   <li>Height: $thumb_height</li>
                                   <li>Size: $thumb_bytes bytes</li>
                                 </ul>
                               <li>Photo view information:</li>
                                 <ul>
                                   <li>View name: $vw_image_name</li>
                                   <li>Width: $viewer_width</li>
                                   <li>Height: $viewer_height</li>
                                   <li>Size: $viewer_bytes bytes</li>
                                 </ul>
                             </ul>
                          </ul>"
	    }

            pa_insert_image $base_image_name $photo_id $base_item_id $base_rev_id $user_id $peeraddr $photo_id $base_image_name "original image" $base_mime "base" "t" $base_filename_relative $base_height $base_width $base_bytes 
            pa_insert_image $th_image_name $photo_id $thumb_item_id $thumb_rev_id $user_id $peeraddr $photo_id $th_image_name "thumbnail" $thumb_mime "thumb" "t" $thumb_filename_relative $thumb_height $thumb_width $thumb_bytes 
            pa_insert_image $vw_image_name $photo_id $viewer_item_id $viewer_rev_id $user_id $peeraddr $photo_id $vw_image_name "web image" $viewer_mime "viewer" "t" $viewer_filename_relative $viewer_height $viewer_width $viewer_bytes 
            
            pa_grant_privilege_to_creator $photo_id $user_id

            lappend new_ids $photo_id
        } 

    }

    return $new_ids
}


ad_proc -public pa_get_exif_data {
    file
} {
    Returns a array get list with the some of the exif data 
    or an empty string if the file is not a jpg file
    
    uses jhead

    Keys: Aperture Cameramake Cameramodel CCDWidth DateTime Exposurebias
    Exposuretime Filedate Filename Filesize Film Flashused Focallength
    Focallength35 FocusDist Jpegprocess MeteringMode Resolution
} { 
    # a map from jhead string to internal tags.
    array set map [list {File date} Filedate \
                       {File name} Filename \
                       {File size} Filesize \
                       {Camera make} Cameramake \
                       {Camera model} Cameramodel \
                       {Date/Time} DateTime \
                       {Resolution} Resolution \
                       {Flash used} Flashused \
                       {Focal length} Focallength \
                       {Focal length35} Focallength35 \
                       {CCD Width} CCDWidth \
                       {Exposure time} Exposuretime \
                       {Aperture} Aperture \
                       {Focus Dist.} FocusDist \
                       {Exposure bias} Exposurebias \
                       {Metering Mode} MeteringMode \
                       {Jpeg process} Jpegprocess \
                       {Film} Film ]

    # try to get the data.
    if {[catch {set results [exec jhead $file]} errmsg]} { 
        ns_log Warning "pa_get_exif_data: jhead failed with error - $errmsg"
        return {}
    } elseif {[string match {Not JPEG:*} $results]} { 
        return {}
    }

    # parse data
    foreach line [split $results "\n"] { 
        regexp {([^:]*):(.*)} $line match tag value
        set tag [string trim $tag]
        set value [string trim $value]
        if {[info exists map($tag)]} { 
            set out($map($tag)) $value
        }
    }
    
    # make sure we have a value for every tag 
    foreach {dummy tag} [array get map] { 
        if {![info exists out($tag)]} { 
            set out($tag) {}
        }
    }

    # fix the annoying ones...
    foreach tag [list  Exposuretime FocusDist] { 
        if {[regexp {([0-9.]+)} $out($tag) match new]} {
            set out($tag) $new
        }
    }

    foreach tag [list  DateTime Filedate] { 
        regsub {([0-9]+):([0-9][0-9]):} $out($tag) "\\1-\\2-" out($tag)
    }

    if {[regexp {.*35mm equivalent: ([0-9]+).*} $out(Focallength) match new]} {
        set out(Focallength35) $new
    } else { 
        set out(Focallength35) {}
    }
    regsub {([0-9.]+)mm.*} $out(Focallength) "\\1" out(Focallength)

    if {[string equal -nocase $out(Flashused) yes]} { 
        set out(Flashused) 1
    } else { 
        set out(Flashused) 0
    }
    
    if {$out(Cameramake) ne ""} { 
        set out(Film) Digital
    }
    
    regsub {([0-9]+).*} $out(Filesize) "\\1" out(Filesize)

    return [array get out]
}


ad_proc -public pa_clipboards_multirow { 
    -create_new:boolean
    -force_default:boolean
    user_id
    datasource
} { 
    creates a multirow datasource with the existing clipboards

    @param create_new add a "Create new folder" entry to list 
    @param force_default create the datasource with a default folder even if none exist
    @param user_id the owner id for the folders 
    @param datasource the datasource name to use.

    @author Jeff Davis davis@xarg.net
    @creation-date 2002-10-30
} {

    db_multirow $datasource clipboards {select collection_id, title, 0 as selected from pa_collections where owner_id = :user_id}

    if {[template::multirow size $datasource] > 0} {
        if {$create_new_p} { 
            template::multirow append $datasource -1 "Create a new clipboard" 0
        } 

    } else { 
        if { $force_default_p } { 
            template::multirow create $datasource collection_id title selected
            template::multirow append $datasource 0 "General" 0
        }
    }
    return [template::multirow size $datasource]
}

ad_proc pa_rotate {id rotation} {
    Rotate a pic

    @param id the photo_id to rotate
    @param rotation the number of degrees to rotate

    @author Jeff Davis davis@xarg.net
    @creation-date 2002-10-30

} {
    if {$rotation ne "" && $rotation ne "0" } { 
        set flop [list]
        set files [list]

        # get a list of files to handle sorted by size...
        db_foreach get_image_files {} {
            ns_log Debug "pa_rotate: rotate $id by $rotation [cr_fs_path] $filename $image_id $width $height"
            if {[catch {exec [parameter::get -parameter ImageMagickPath]/convert -rotate $rotation [cr_fs_path]$filename [cr_fs_path]${filename}.new } errMsg]} { 
                ns_log Warning "pa_rotate: failed rotation of image $image_id -- $errMsg"
            }
            lappend flop $image_id
            lappend files [cr_fs_path]$filename
        }

        # rename files in catch.
        if { [catch { 
            foreach fnm $files {
                file rename -force $fnm ${fnm}.old 
                file rename -force ${fnm}.new $fnm
            } } errMsg ] } { 
            # problem with the renaming.  Make an attempt to rename them back 
            catch { 
                foreach fnm $files {
                    file rename -force ${fnm}.old $fnm
                    file delete -force ${fnm}.new
                }
            } errMsg
        } else { 
            # flop images that need flopping.
            if {$rotation eq "90" || $rotation eq "270"} { 
                db_dml flop_image_size "update images set width = height, height = width where image_id in ([join $flop ,])"
            }
        }
    }
}

# JCD -- support procs for searching and such

namespace eval photo_album {}
namespace eval photo_album::photo {}
namespace eval photo_album::album {}

ad_proc -public photo_album::photo::get {
    -photo_id:required
    -array:required
    {-user_id {}}
} {
    return an array with the photo data.

    elements are: 

    photo_delete_p
    admin_p
    write_p
    album_write_p

    album_id
    caption
    description
    photo_id
    story
    title

    image_types (list of available related images "base" "viewer" "thumb")

    For each image type there is (eg viewer here):

    viewer_content
    viewer_content_length
    viewer_height

    viewer_image_id
    viewer_latest_revision
    viewer_live_revision
    viewer_name
    viewer_relation_tag
    viewer_width
} {
    upvar $array row

    if {$user_id eq ""} {
        if {[ad_conn isconnected]} { 
            set user_id [ad_conn user_id]
        } else {
            set user_id 0
        }
    }

    db_1row basic {} -column_array row

    db_foreach images {} -column_set img {
        set rel [ns_set iget $img relation_tag]
        lappend row(image_types) $rel
        for { set i 0 } { $i < [ns_set size $img] } { incr i } {
            set row(${rel}_[ns_set key $img $i]) [ns_set value $img $i]
        }
    }
}

ad_proc -public photo_album::photo::package_url {
    -photo_id
} { 
    given a photo_id (can be an item or revision_id)
    return the package_url for the corresponding photo.

    does not include the site part just the path.
} { 
    db_0or1row package_url {}

    return [site_node::get_element -node_id $node_id -element url]
}

ad_proc -public photo_album::get_package_id_from_url {
    -url
} { 
    Returns package_id of instance from URL
} {
    array set site_node [site_node::get_from_url -url $url]
    return $site_node(package_id)
}

ad_proc -public photo_album::list_albums_in_root_folder {
    -root_folder_id
} { 
    Returns a list of albums for a specific instance of photo-album
} {
    # only return albums the current user can see
    set user_id [ad_conn user_id]
    return [db_list_of_lists list_albums {} ]
}
