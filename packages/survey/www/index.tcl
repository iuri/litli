ad_page_contract {

    Lists all the enabled surveys
    a user is eligable to complete.

    @author  philg@mit.edu
    @author  nstrug@arsdigita.com
    @date    28th September 2000
    @cvs-id  $Id: index.tcl,v 1.4 2013/11/06 07:33:54 gustafn Exp $
} {

} -properties {
    surveys:multirow
}

set package_id [ad_conn package_id]

set user_id [auth::require_login]

set admin_p [permission::permission_p -object_id $package_id -privilege admin]

db_multirow surveys survey_select {} 


ad_return_template

