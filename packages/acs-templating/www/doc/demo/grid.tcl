ad_page_contract {
  @cvs-id $Id: grid.tcl,v 1.2.28.1 2015/09/10 08:22:10 gustafn Exp $
} -properties {
  users:multirow
}


set query "select 
             first_name, last_name
           from
             ad_template_sample_users"


db_multirow users users_query $query




















# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
