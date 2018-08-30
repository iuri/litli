array set cfa $cf

set num_packages [llength $cfa(package_id)]

set read_p 0
foreach package_id $cfa(package_id) {
    set package_read_p [permission::permission_p -object_id $package_id -privilege read]
    if { $package_read_p } {
        set read_p 1
        break
    }
}
