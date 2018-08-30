#Pages in this directory are only runnable by dotlrn-wide admins.
dotlrn::require_admin 

# Used by the en_US version of the message in the adp file
set terms_url "terms"
set terms_pretty_plural [_ dotlrn.terms]
set class_instances_pretty_plural [parameter::get -localize -parameter class_instances_pretty_plural]

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
