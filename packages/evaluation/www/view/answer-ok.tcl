# /packages/evaluation/www/answer-ok.tcl

ad_page_contract {
	
    Displays a success message to the student

    @author jopez@galileo.edu
    @creation-date Oct 2004
    @cvs-id $Id: answer-ok.tcl,v 1.2.10.2 2017/02/02 14:18:02 gustafn Exp $

} -query {
	return_url:localurl,notnull
}

ad_return_template

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
