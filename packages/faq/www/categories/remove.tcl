ad_page_contract {
} {
    object_id:naturalnum,notnull
    cat:integer,notnull
}

db_dml nuke {delete from category_object_map where category_id = :cat and object_id = :object_id}

ad_returnredirect -message "removed category" [get_referrer]

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
