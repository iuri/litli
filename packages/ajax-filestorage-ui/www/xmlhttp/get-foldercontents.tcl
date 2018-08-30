ad_page_contract {

    Given the folder_id, this page will return JSON with
        data of the contents of that folder

    @author Hamilton Chua (ham@solutiongrove.com)
    @creation-date 2007-06-03

} {
    folder_id:optional
    tag_id:integer,optional
    {sort "icon"}
    {package_id:optional}
    {dir "ASC"}
}

# who's looking

set viewing_user_id [ad_conn user_id]

regsub "treenode" $folder_id "" folder_id

# find out which file storage instance we are at
#  so that we can get a path to prefix to the files

set root_package_id [ajaxfs::get_root_folder -folder_id $folder_id]
if {[info exists package_id]} { set root_package_id $package_id }
set root_folder_id [fs::get_root_folder -package_id $root_package_id]

set folder_name [lang::util::localize [fs::get_object_name -object_id  $folder_id]]

set fs_url [apm_package_url_from_id $root_package_id]
if {![exists_and_not_null fs_url]} {  set fs_url "" }

set folder_path ""
set categories_limitation ""
if {![string equal $root_folder_id $folder_id]} {
    set folder_path [db_exec_plsql dbqd.file-storage.www.folder-chunk.get_folder_path {}]
}

set counter 0
set n_past_days 99999

# sorting **********
set orderby ""
if { [exists_and_not_null sort] } {
    if {$sort == "icon"} { 
        if { $dir == "DESC" } {
            set sort "sort_key_desc, lower(fs_objects.name)"
        } else {
            set sort "fs_objects.sort_key, lower(fs_objects.name)"
        }
    }
    if {$sort == "title"} { set sort "lower(fs_objects.title)" }
    if {$sort == "size"} { set sort "fs_objects.content_size" }
    if {$sort == "lastmodified"} { set sort "fs_objects.last_modified" }
    set orderby "order by $sort $dir"
}

if { [exists_and_not_null tag_id] } {
    set query_name "select_folder_contents"
    set query "select fs_objects.object_id,
                   fs_objects.mime_type,
                   fs_objects.name,
                   fs_objects.live_revision,
                   fs_objects.type,
                   fs_objects.pretty_type,
                   to_char(fs_objects.last_modified, 'YYYY-MM-DD HH24:MI:SS') as last_modified_ansi,
                   fs_objects.content_size,
                   fs_objects.url,
                   fs_objects.sort_key,
                   fs_objects.sort_key as sort_key_desc,
                   fs_objects.file_upload_name,
                   fs_objects.title,
                   case
                     when '$folder_path' is null
                     then fs_objects.file_upload_name
                     else '$folder_path' || '/' || fs_objects.file_upload_name
                   end as file_url,
                   case
                     when fs_objects.last_modified >= (now() - cast('$n_past_days days' as interval))
                     then 1
                     else 0
                   end as new_p
            from fs_objects
            where fs_objects.object_id in (select object_id from category_object_map where category_id=$tag_id)
            and exists (select 1
                   from acs_object_party_privilege_map m
                   where m.object_id = fs_objects.object_id
                     and m.party_id = $viewing_user_id
                     and m.privilege = 'read')
            $orderby"
} else {
    set query_name dbqd.file-storage.www.folder-chunk.select_folder_contents
    set query ""
}

db_multirow -extend { filename icon last_modified_pretty content_size_pretty download_url linkurl object_counter file_list_start file_list_end write_p delete_p admin_p tags symlink_id qtip} contents $query_name {} {

    # cleanup :
    # remove double quotes, replace with single quotes
    regsub -all {"} $title {\"} title 
    regsub -all {"} $name {\"} name
    regsub -all {"} $filename {\"} filename

    set symlink_id ""
    set qtip ${title}

    # title of the file

    if { ![exists_and_not_null title] } { set title $name }

    # content size

    if {[string equal $type "folder"]} {

        set content_size_pretty [lc_numeric $content_size]
        append content_size_pretty " [_ file-storage.items]"

    } else {

        if {$content_size < 1024} {
            set content_size_pretty "[lc_numeric $content_size] [_ file-storage.bytes]"
        } else {
            set content_size_pretty "[lc_numeric [expr $content_size / 1024 ]] [_ file-storage.kb]"
        }

    }

    # last modified

    set last_modified_pretty [lc_time_fmt $last_modified_ansi "%x %X"]

    # icon

    switch -- $type {
        folder {
            set shared_with [db_list get_share_from "select p.instance_name 
                    from cr_folders f, 
                        cr_symlinks s, 
                        cr_items i, 
                        acs_objects o, 
                        apm_packages p, 
                        site_nodes s1, 
                        site_nodes s2 
                    where o.package_id = s2.object_id 
                    and s1.node_id = s2.parent_id 
                    and s1.object_id = p.package_id 
                    and s.symlink_id = o.object_id 
                    and s.symlink_id = i.item_id
                    and s.target_id = :object_id 
                    and f.folder_id=i.parent_id"]
            if { [llength $shared_with] > 0} {
                set shareditems [join ${shared_with} "</li><li>"]
                set qtip "<div style=text-align:left>${title} is <b>shared with</b><ul><li>${shareditems}</li></ul></div>"
                set icon "<img src='/resources/ajaxhelper/icons/folder_go.png' ext:qtip='${qtip}' ext:width='100'>"
            } else {
                set qtip "${title}"
                set icon "<img src='/resources/ajaxhelper/icons/folder.png' ext:qtip='${qtip}' ext:width='200'>"
            }
        }
        symlink {
            set target_id [db_string get_target_folder "select target_id from cr_symlinks where symlink_id=:object_id"]
            set symlink_id $object_id
            set object_id $target_id
            set target_package_id [ajaxfs::get_root_folder -folder_id $target_id]
            set instance_name [db_string get_subsite_name "select instance_name from apm_packages where package_id=(select context_id from acs_objects where object_id = ${target_package_id})"]
            set qtip "<div style=text-align:left>${title} <b>shared from</b> ${instance_name}</div>"
            set icon "<img src='/resources/ajaxhelper/icons/folder_link.png' ext:qtip='$qtip' ext:width='200'>"
            set content_size_pretty ""
        }
        url {
            set qtip [db_string "getdesc" "select description from cr_extlinks where extlink_id=:object_id"]
            set icon "<img src='/resources/ajaxhelper/icons/link.png' ext:qtip='$qtip'>"
            set download_url $url
            set content_size_pretty ""
        }
        "application/pdf" {
            set icon "<img src='/resources/ajaxhelper/icons/page_white_acrobat.png'>"
        }
        "application/vnd.ms-excel" {
            set icon "<img src='/resources/ajaxhelper/icons/page_white_excel.png'>"
        }
        "application/vnd.ms-powerpoint" {
            set icon "<img src='/resources/ajaxhelper/icons/page_white_powerpoint.png'>"
        }
        "application/zip" {
            set icon "<img src='/resources/ajaxhelper/icons/page_white_compressed.png'>"
        }
        "application/msword" {
            set icon "<img src='/resources/ajaxhelper/icons/page_white_word.png'>"
        }
        "video/x-flv" {
            set icon "<img src='/resources/ajaxhelper/icons/film.png'>"
        }
        "image/jpeg" {
            set icon "<img src='/resources/ajaxhelper/icons/page_white_picture.png'>"
        }
        "image/gif" {
            set icon "<img src='/resources/ajaxhelper/icons/page_white_picture.png'>"
        }
        default {
            set icon "<img src='/resources/ajaxhelper/icons/page_white.png'>"
        }
    }

    # filename and download url

    if { $type != "folder" && $type != "symlink"} {

        if { ![exists_and_not_null download_url] } {
            set download_url "${fs_url}download/[ad_urlencode ${title}]?[export_vars {{file_id $object_id}}]"
            set linkurl "${fs_url}download/?[export_vars {{file_id $object_id}}]"
        }

        set filename $name
        if { $title == $name } { set filename " "}

    } else {

        set download_url "javascript:void(0)"
        set linkurl "javascript:void(0)"
        set filename " "
    }

    # get the tags for this fs item
    set tag_list [db_list "get_categories" "select name from category_translations where locale='en_US' and category_id in (select category_id from category_object_map where object_id=:object_id)"]
    if { [llength $tag_list] >0 } {
        regsub -all {"} [join $tag_list ","] {\"} tags
    } else {
        set tags ""
    }

    if { [permission::permission_p -party_id $viewing_user_id -object_id $object_id -privilege "write"] } { set write_p "true" } else { set write_p "false" }
    if { [permission::permission_p -party_id $viewing_user_id -object_id $object_id -privilege "delete"] } { set delete_p "true" } else { set delete_p "false" }
    if { [permission::permission_p -party_id $viewing_user_id -object_id $object_id -privilege "admin"] } { set admin_p "true" } else { set admin_p "false" }


    incr counter

}
