ad_library {
    Automated tests.
    @author Mounir Lallali
    @author Gerardo Morales
    @creation-date 14 June 2005
   
}


#########################
#
# twt namespace
#
#########################

namespace eval faq_portlet::twt {}

ad_proc faq_portlet::twt::new { faq_name } {

        set response 0
	 
	set dotlrn_page_url "[site_node::get_package_url -package_key dotlrn]admin"	 
	::twt::do_request $dotlrn_page_url
	tclwebtest::link follow "Classes"	

	# Create a new FAQ		 
	tclwebtest::link follow ~u {one-community-admin$}

	tclwebtest::link follow	"New FAQ"
	tclwebtest::form find ~n "faq"
	tclwebtest::field find ~n "faq_name"
	tclwebtest::field fill "$faq_name"
	tclwebtest::form submit
	aa_log "Faq form submited"

	set response_url [tclwebtest::response url]	
	
	if {[string match "*/dotlrn/classes*/faq/admin*" $response_url] } {
		if {[catch {tclwebtest::link find "$faq_name"} errmsg] } {
			aa_error  "faq_portlet::twt::new failed $errmsg : Did't create a New Faq"
		} else {
			aa_log "New faq Created !!"
		        set response 1
		}
	} else {
		aa_error "faq_portlet::twt::new failed, bad response url : $response_url"
	}
	
	return $response
}

ad_proc faq_portlet::twt::delete { faq_name} {

        set response 0

	set dotlrn_page_url "[site_node::get_package_url -package_key dotlrn]admin"	 
	::twt::do_request $dotlrn_page_url
	
	tclwebtest::link follow "Classes"	

	# Create a new FAQ		 
	tclwebtest::link follow ~u {one-community-admin$}
	
	tclwebtest::link follow $faq_name
	tclwebtest::link follow {View All FAQs} 

	db_1row faq_id "select faq_id from faqs where faq_name=:faq_name"
	::twt::do_request [export_vars -base "faq-delete" {faq_id}]

	set response_url [tclwebtest::response url]	
	
	if { [string match "*/faq/admin/index" $response_url] } {
		if {![catch {tclwebtest::link find "$faq_name" } errmsg]} {
			aa_error "faq_portlet::twt::delete failed $errmsg : Did't delete $faq_name Faq"
		} else {
			aa_log "Faq Deleted"
		        set response 1
		}
	} else {
		aa_error "faq_portlet::twt::delete failed, bad response url : $response_url"
	}
	
	return $response
}

ad_proc faq_portlet::twt::disable_enable { faq_name option } {

        set response 0

	set dotlrn_page_url "[site_node::get_package_url -package_key dotlrn]admin"	 
	::twt::do_request $dotlrn_page_url

         tclwebtest::link follow "Classes"

        # Create a new FAQ
        tclwebtest::link follow ~u {one-community-admin$}

        tclwebtest::link follow $faq_name
        tclwebtest::link follow {View All FAQs}

	db_1row faq_id "select faq_id from faqs where faq_name=:faq_name"
        set url_option [export_vars -base "faq-$option" {faq_id}]
	::twt::do_request $url_option
			
	set response_url [tclwebtest::response url]

	if {[string match "*/dotlrn/classes*/faq/admin*" $response_url] } {
		if {! [catch {tclwebtest::link find ~u $url_option } errmsg]} {
			aa_error "faq_portlet::twt::$option failed $errmsg : Did't $option $faq_name Faq"
		} else {
			aa_log "Faq $option"
		        set response 1
		}
	} else {
		aa_error "faq_portlet::twt::$option failed. Bad  response url : $response_url "
	}
	
	return $response
}


ad_proc faq_portlet::twt::edit_faq { faq_name faq_new_name } {

        set response 0

	db_1row faq_id "select faq_id from faqs where faq_name=:faq_name"
	 
	set dotlrn_page_url "[site_node::get_package_url -package_key dotlrn]admin"	 
	::twt::do_request $dotlrn_page_url
	tclwebtest::link follow "Classes"

	tclwebtest::link follow ~u {one-community-admin$}
	tclwebtest::link follow $faq_name
	
	tclwebtest::form find ~n "faq_add_edit"
	tclwebtest::form submit				 	

	tclwebtest::form find ~n "faq_add_edit"
	tclwebtest::field find ~n "faq_name"
	tclwebtest::field fill "$faq_new_name"
	tclwebtest::form submit	
	aa_log " Faq form submited"

	set response_url [tclwebtest::response url]	
	
	if {[string match "*/faq/admin/one-faq*" $response_url] } {
		if { [catch {tclwebtest::form find ~n "faq_add_edit"} errmsg] || [catch {tclwebtest::field find ~v "$faq_new_name"} errmsg] } {
			aa_error  "faq_portlet::twt::edit_faq failed $errmsg : Did't Edit the Faq"
		} else {
		    aa_log "Faq Edited"
		    set response 1
		}
	} else {
		aa_error "faq_portlet::twt::new failed, bad response url : $response_url"
	}
	
	return $response
}

ad_proc faq_portlet::twt::new_Q_A { faq_name question answer} {

        set response 0

	set dotlrn_page_url "[site_node::get_package_url -package_key dotlrn]admin"	 
	::twt::do_request $dotlrn_page_url
	tclwebtest::link follow "Classes"
	tclwebtest::link follow ~u {one-community-admin$}
	tclwebtest::link follow $faq_name
	
	tclwebtest::link follow "Create New Q&A"
	
	tclwebtest::form find ~n "new_quest_answ"
	tclwebtest::field find ~n "question"
	tclwebtest::field fill "$question"
	tclwebtest::field find ~n "answer"
	tclwebtest::field fill "$answer"
	tclwebtest::form submit	
	aa_log " Faq Question Form submited"
	
	set response_url [tclwebtest::response url]

	if { [string match "*/faq/admin/one-faq*" $response_url] } {
		if { [catch {tclwebtest::assert text "$question"} errmsg] } { 
		    aa_error "faq_portlet::twt::new_Q_A :  failed $errmsg : Did't Create a New Question"
		} else {
			aa_log "New Faq Question Created"	
		        set response 1
		}
	} else {
		aa_error "dorlrn_faq::twt::new_Q_A failed. Bad  response url : $response_url"
	}
	
	return $response
}

ad_proc faq_portlet::twt::delete_Q_A { faq_name question} {

        set response 0

        set dotlrn_page_url "[site_node::get_package_url -package_key dotlrn]admin"
        ::twt::do_request $dotlrn_page_url
        tclwebtest::link follow "Classes"
        tclwebtest::link follow ~u {one-community-admin$}
        tclwebtest::link follow $faq_name

	tclwebtest::link follow {View All FAQs}
	tclwebtest::link follow $faq_name

        db_1row faq_id "select faq_id from faqs where faq_name=:faq_name"
	tclwebtest::link follow delete 
 
        set response_url [tclwebtest::response url]

        if { [string match "*/faq/admin/one-faq*" $response_url] } {
	    if { [catch {tclwebtest::assert text -fail "$question"} errmsg] } {
                        aa_error "faq_portlet::twt::delete_Q_A :  failed $errmsg : Did't Delete a Question"
	    } else {
                        aa_log "Faq Question Deleted"
                        set response 1
	    }
        } else {
                aa_error "dorlrn_faq::twt::delete_Q_A failed. Bad  response url : $response_url"
        }
        
	return $response
    }

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
