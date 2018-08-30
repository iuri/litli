ad_page_contract { 
    return x-editlocal or the code for the compiled function

    @author Jeff Davis <davis@xarg.net>
    @creation-date 2005-02-02
    @cvs-id $Id: search.tcl,v 1.4.2.2 2015/09/18 07:42:33 gustafn Exp $
} {
    request:integer,notnull
    expression:notnull
}

ds_require_permission [ad_conn package_id] "admin"

set context [list [list request-info?request=$request "request $request"] search]

if {![ns_cache get ds_page_bits $request pages]} {
    set gone_p 1
} else {
    set gone_p 0

    multirow create matches page excerpt file_links size 

    foreach page $pages {
        if {![info exists matched($page)]
            && [ns_cache get ds_page_bits $request:$page content]} {
            if {[regexp -indices $expression $content offset]} {
                set file_links "<a href=\"send?fname=[ns_urlencode $page]\" title=\"edit\">e</a>"
                append file_links " <a href=\"send?code=[ns_urlencode $page]\" title=\"compiled code\">c</a>"
                append file_links " <a href=\"send?output=$request:[ns_urlencode $page]\" title=\"output\">o</a>"
                set size [string length $content]
                set highlight "...[ns_quotehtml [string trimleft [string range $content [expr {[lindex $offset 0] - 50}] [expr {[lindex $offset 0] - 1}]]]]<b>[ns_quotehtml [string range $content [lindex $offset 0] [lindex $offset 1]]]</b>[ns_quotehtml [string trimright [string range $content [expr {[lindex $offset 1] + 1}] [expr {[lindex $offset 1] + 50}]]]]..."

                multirow append matches $page $highlight $file_links $size
            } 
            set matched($page) 1
        }
    }
}

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
