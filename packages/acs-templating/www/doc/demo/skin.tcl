ad_page_contract {
  @cvs-id $Id: skin.tcl,v 1.2.28.1 2015/09/10 08:22:12 gustafn Exp $
} {
  skin
} -properties {
  users:multirow
}

set query "select 
             first_name, last_name
           from
             ad_template_sample_users
           order by
             last_name, first_name"

db_multirow users users_query $query


# Choose a skin

switch $skin {
  plain { set file skin-plain }
  fancy { set file skin-fancy }
  default { set file /packages/acs-templating/www/doc/demo/skin-plain }
}


ad_return_template $file


# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
