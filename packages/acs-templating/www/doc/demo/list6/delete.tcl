# packages/notes/www/delete.tcl

ad_page_contract {

  @author rhs@mit.edu
  @creation-date 2000-10-23
  @cvs-id $Id: delete.tcl,v 1.3.2.1 2015/09/10 08:22:14 gustafn Exp $
} {
  template_demo_note_id:naturalnum,notnull,multiple
}

foreach template_demo_note_id $template_demo_note_id {
    permission::require_permission -object_id $template_demo_note_id -privilege delete

    package_exec_plsql -var_list [list [list template_demo_note_id $template_demo_note_id]] template_demo_note del
}

ad_returnredirect "./"

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
