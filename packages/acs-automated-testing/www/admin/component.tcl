ad_page_contract {
  @cvs-id $Id: component.tcl,v 1.5.2.2 2016/06/09 08:19:39 gustafn Exp $
} {
  component_id:token,notnull
  package_key:nohtml
} -properties {
  title:onevalue
  context_bar:onevalue
  component_desc:onevalue
  component_file:onevalue
  component_body:onevalue
}

set title "Component $component_id ($package_key)"
set context [list $title]

set component_bodys {}
foreach component [nsv_get aa_test components] {
  if {$component_id eq [lindex $component 0] && $package_key eq [lindex $component 1]} {
    set component_desc [lindex $component 2]
    set component_file [lindex $component 3]
    set component_body [lindex $component 4]
  }
}

ad_return_template

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
