ad_page_contract {

    Given the file_id, this page will return JSON with
       all ther revisions for that file

    @author Hamilton Chua (ham@solutiongrove.com)
    @creation-date 2007-12-29

} {
    file_id:integer
    package_id:integer
}

set user_id [ad_conn user_id]
set query_name dbqd.file-storage.www.file.version_info
set counter 0
set show_versions ""
set root_folder_id [fs::get_root_folder -package_id $package_id]
set fs_url [apm_package_url_from_id $package_id]

db_1row dbqd.file-storage.www.file.file_info ""

db_multirow -unclobber -extend { icon author_link last_modified_pretty content_size_pretty version_url version_delete version_delete_url islive} version $query_name "" {

    # last modified

    set last_modified_ansi [lc_time_system_to_conn $last_modified_ansi]
    set last_modified_pretty [lc_time_fmt $last_modified_ansi "%x %X"]

    # content size 

    if {$content_size < 1024} {
        set content_size_pretty "[lc_numeric $content_size] [_ file-storage.bytes]"
    } else {
        set content_size_pretty "[lc_numeric [expr $content_size / 1024 ]] [_ file-storage.kb]"
    }

    # title

    if {[string equal $title ""]} {
        set title "[_ file-storage.untitled]"
    }

    # version url

    if {![string equal $version_id $live_revision]} {
        # set version_url "${fs_url}view/${file_url}?[export_vars {{revision_id $version_id}}]"
        set version_url [export_vars -base "${fs_url}download/$title" {version_id}]
        set islive "false"
    } else {
        # set version_url "${fs_url}view/${file_url}"
        set version_url [export_vars -base "${fs_url}download/$title" {file_id}]
        set islive "true"
    }

    # icon

    switch -- $type {
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

    incr counter
}