ad_page_contract {
    Stops watching a particular file or all files if
    no file is specified.
   
    @param watch_file The file to stop watching.
    @author Jon Salz [jsalz@arsdigita.com]
    @creation-date 17 April 2000
    @cvs-id $Id: file-watch-cancel.tcl,v 1.5.24.3 2016/05/20 19:52:59 gustafn Exp $
} {
    {watch_file ""}
    {return_url:localurl ""}
}
apm_file_watch_cancel $watch_file

ad_returnredirect $return_url

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
