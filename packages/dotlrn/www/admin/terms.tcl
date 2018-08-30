#
#  Copyright (C) 2001, 2002 MIT
#
#  This file is part of dotLRN.
#
#  dotLRN is free software; you can redistribute it and/or modify it under the
#  terms of the GNU General Public License as published by the Free Software
#  Foundation; either version 2 of the License, or (at your option) any later
#  version.
#
#  dotLRN is distributed in the hope that it will be useful, but WITHOUT ANY
#  WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
#  FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
#  details.
#

# dotlrn/www/admin/terms.tcl

ad_page_contract {
    @author yon (yon@openforce.net)
    @creation-date Dec 13, 2001
    @version $Id: terms.tcl,v 1.9.2.2 2017/01/26 11:46:02 gustafn Exp $
} -query {
    page:naturalnum,optional
    {orderby:token "start_date_pretty,desc"}
} -properties {
    context_bar:onevalue
    terms:multirow
}

#Pages in this directory are only runnable by dotlrn-wide admins.
dotlrn::require_admin 

set context_bar "[_ dotlrn.Terms]"

set actions [list "[_ dotlrn.New_Term]" "term-new"]

template::list::create \
    -name terms \
    -multirow terms \
    -actions $actions \
    -page_flush_p t \
    -key term_id \
    -page_size 50 \
    -page_query_name terms_pagination \
    -elements {
        term_name {
            label "[_ dotlrn.Term]"
	    orderby_asc {term_name asc}
	    orderby_desc {term_name desc}
            link_url_eval {[export_vars -base "term" { term_id }]}
        }
        start_date_pretty {
            label "[_ dotlrn.Start_Date]"
	    orderby_asc {start_date_ansi asc}
	    orderby_desc {start_date_ansi desc}
        }
        end_date_pretty {
            label "[_ dotlrn.End_Date]"
	    orderby_asc {end_date_ansi asc}
	    orderby_desc {end_date_ansi desc}
        }
        n_classes {
            label "[_ dotlrn.Classes]"
	    orderby_asc {n_classes asc}
	    orderby_desc {n_classes desc}
        }
    }

db_multirow -extend { start_date_pretty end_date_pretty } terms select_terms {} {
    set start_date_pretty [lc_time_fmt $start_date_ansi "%q"]
    set end_date_pretty [lc_time_fmt $end_date_ansi "%q"]
}

ad_return_template


# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
