ad_page_contract {
  @cvs-id $Id: multiple.tcl,v 1.2.28.1 2015/09/10 08:22:11 gustafn Exp $
  @datasource users multirow
  Complete list of sample users
  @column first_name First name of the user.
  @column last_name Last name of the user.
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
