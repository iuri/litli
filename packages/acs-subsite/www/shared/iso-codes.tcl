ad_page_contract {
    displays the iso-codes

    @cvs-id $Id: iso-codes.tcl,v 1.3.2.2 2016/01/02 20:57:58 gustafn Exp $
} -properties {
    ccodes:multirow
}

if {![db_table_exists countries] } {
    # acs-reference countries not loaded

    ad_return_template iso-codes-no-exist
    return
}

db_multirow ccodes country_codes {
    select iso, default_name from countries order by default_name
}

ad_return_template
# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
