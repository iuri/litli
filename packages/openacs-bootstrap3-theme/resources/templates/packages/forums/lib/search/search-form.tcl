# packages/forums/lib/search/search-form.tcl
#
# Form for search box
#
# @author Emmanuelle Raffenne (eraffenne@gmail.com)
# @creation-date 2007-12-23
# @cvs-id $Id: search-form.tcl,v 1.1 2016/07/08 16:13:35 gustafn Exp $

form create search -action search -has_submit 1
forums::form::search search

if { [form is_request search] && [info exists forum_id] } {
    element set_properties search forum_id -value $forum_id
}
