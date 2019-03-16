ad_library {

    Library for Ajax Photo Album UI
    uses Ajax Helper package with ExtJS and the Yahoo User Interface Library.
    http://developer.yahoo.net/yui/index.html
    http://extjs.com/deploy/dev/docs/

    @author Hamilton Chua (ham@solutiongrove.com)
    @creation-date 2007-11-18

}


namespace eval ajaxpa { }

ad_proc -private ajaxpa::get_package_id  {

} {
    Return the package_id of the installed and mounted ajax photo album ui

    @author Hamilton Chua (ham@solutiongrove.com)   
    @creation-date 2007-11-18
    @return 

    @error 

} {
    return [apm_package_id_from_key "ajax-photoalbum-ui"]
}

ad_proc -private ajaxpa::get_url  {

} {
    Return the URL to the mounted ajax photo album ui instance

    @author Hamilton Chua (ham@solutiongrove.com)   
    @creation-date 2007-11-18
    @return 

    @error 

} {
    return [apm_package_url_from_id [ajaxpa::get_package_id]]
}

ad_proc -private ajaxpa::json_normalize  {
    -value
} {
    Normalizes text for use in a JSON attribute.
     - escape double quotes
     - removes line breaks

    @author Hamilton Chua (ham@solutiongrove.com)   
    @creation-date 2007-11-18
    @return 

    @error 

} {
    regsub -all {"} $value {\"} value
    regsub -all {\n} $value { } value
    return $value
}