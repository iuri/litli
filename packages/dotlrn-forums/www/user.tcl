ad_page_contract {
    
    Posting History for a User

    @author Ben Adida (ben@openforce)
    @creation-date 2002-05-29
    @version $Id: user.tcl,v 1.5.2.1 2015/09/11 11:40:57 gustafn Exp $

} {
    user_id:naturalnum,notnull
    {view "date"}
}

# choosing the view
set dimensional_list [list \
    [list \
        view "[_ dotlrn-forums.View]" date [list \
            [list date "[_ dotlrn-forums.by_Date]" {}] \
            [list forum "[_ dotlrn-forums.by_Forum]" {}] \
        ] \
    ] \
]

# provide screen_name functionality
set screen_name [db_string select_screen_name { select screen_name from users where user_id = :user_id}]
set useScreenNameP [parameter::get -parameter "UseScreenNameP" -default 0]

set query select_messages
if {$view eq "forum"} {
    set query select_messages_by_forum
}

# Select the postings
db_multirow -extend { posting_date_pretty } messages $query {} {
    set posting_date_ansi [lc_time_system_to_conn $posting_date_ansi]
    set posting_date_pretty [lc_time_fmt $posting_date_ansi "%x %X"]
}

# Get user information
acs_user::get -user_id $user_id -array user

set dimensional_chunk [ad_dimensional $dimensional_list]

set context_bar [list [_ dotlrn-forums.Posting_History]]

ad_return_template

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
