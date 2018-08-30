ad_page_contract {
  @cvs-id $Id: group.tcl,v 1.2.28.1 2015/09/10 08:22:11 gustafn Exp $
} -properties {
  users:multirow
}


set query "select 
             first_name, last_name, state
           from
             ad_template_sample_users
           order by state, last_name"


db_multirow users users_query $query

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
