ad_library {

    CKEditor 4 integration with the richtext widget of acs-templating.

    This script defines the following two procs:

       ::richtext-ckeditor4::initialize_widget
       ::richtext-ckeditor4::render_widgets    
    
    @author Gustaf Neumann
    @creation-date 1 Jan 2016
    @cvs-id $Id: richtext-procs.tcl,v 1.1.2.16 2017/07/29 08:41:42 gustafn Exp $
}

namespace eval ::richtext::ckeditor4 {

    set version 4.7.1
    set ck_package standard
    
    ad_proc initialize_widget {
        -form_id
        -text_id
        {-options {}}
    } {
        
        Initialize an CKEditor richtext editor widget.
        
    } {
        ns_log debug "initialize CKEditor instance with <$options>"

        # allow per default all classes, unless the user has specified
        # it differently
        if {![dict exists $options extraAllowedContent]} {
            dict set options extraAllowedContent {*(*)}
        }
        
        # The richtext widget might be specified by "options {editor
        # ckeditor4}" or via the package parameter "RichTextEditor" of
        # acs-templating.
        #
        # The following options handled by the CKEditor integration
        # can be specified in the widget spec of the richtext widget:
        #
        #      plugins skin customConfig spellcheck
        #
        set ckOptionsList {}
        
        if {![dict exists $options spellcheck]} {
            dict set options spellcheck [parameter::get \
                                             -package_id [apm_package_id_from_key "richtext-ckeditor4"] \
                                             -parameter "SCAYT" \
                                             -default "false"]
        }

        # For the native spellchecker, one has to hold "ctrl" or "cmd"
        # with the right click.
        
        lappend ckOptionsList \
            "language: '[lang::conn::language]'" \
            "disableNativeSpellChecker: false" \
            "scayt_autoStartup: [dict get $options spellcheck]"

        if {[dict exists $options plugins]} {
            lappend ckOptionsList "extraPlugins: '[dict get $options plugins]'"
        }
        if {[dict exists $options skin]} {
            lappend ckOptionsList "skin: '[dict get $options skin]'"
        }
        if {[dict exists $options customConfig]} {
            lappend ckOptionsList "customConfig: '[dict get $options customConfig]'"
        }
        if {[dict exists $options extraAllowedContent]} {
            lappend ckOptionsList "extraAllowedContent: '[dict get $options extraAllowedContent]'"
        }

        set ckOptions [join $ckOptionsList ", "]
        
        #
        # Add the configuration via body script
        #
        template::add_script -section body -script [subst {
            CKEDITOR.replace( '$text_id', {$ckOptions} );
        }]

        #
        # Load the editor and everything necessary to the current page.
        #
        ::richtext::ckeditor4::add_editor
        
        #
        # do we need render_widgets?
        #
        return ""
    }


    ad_proc render_widgets {} {

        Render the ckeditor4 rich-text widgets. This function is created
        at a time when all rich-text widgets of this page are already
        initialized. The function is controlled via the global variables

           ::acs_blank_master(ckeditor4)
           ::acs_blank_master__htmlareas
        
    } {
        #
        # In case no ckeditor4 instances are created, nothing has to be
        # done.
        #
        if {![info exists ::acs_blank_master(ckeditor4)]} {
            return
        }
        #
        # Since "template::head::add_javascript -src ..." prevents
        # loading the same resource multiple times, we can perform the
        # load in the per-widget initialization and we are done here.
        #
    }

    ad_proc ::richtext::ckeditor4::version_info {
        {-ck_package ""}
        {-version ""}
    } {

        Get information about available version(s) of CKEditor, either
        from the local file system, or from CDN.
        
    } {
        #
        # If no version or ck editor package are specified, use the
        # namespaced variables as default.
        #
        if {$version eq ""} {
            set version ${::richtext::ckeditor4::version}
        }
        if {$ck_package eq ""} {
            set ck_package ${::richtext::ckeditor4::ck_package}
        }

        set suffix $version/$ck_package/ckeditor.js
        set resources $::acs::rootdir/packages/richtext-ckeditor4/www/resources
        
        if {[file exists $resources/$suffix]} {
            lappend result file $resources/$suffix
            lappend result resources /resources/richtext-ckeditor4/$suffix
        }
        lappend result cdn "//cdn.ckeditor.com/$suffix"

        return $result
    }
    
    ad_proc ::richtext::ckeditor4::add_editor {
        {-ck_package ""}
        {-version ""}
    } {

        Add the necessary JavaScript and other files to the current
        page. The naming is modeled after "add_script", "add_css",
        ... but is intended to care about everything necessary,
        including the content security policies. Similar naming
        conventions should be used for other editors as well.

        This function can be as well used from other packages, such
        e.g. from the xowiki form-fields, which provide a much higher
        customization.
        
    } {
        set version_info [::richtext::ckeditor4::version_info \
                              -ck_package $ck_package \
                              -version $version]

        if {[dict exists $version_info resources]} {
            template::head::add_javascript -src [dict get $version_info resources]
        } else {
            template::head::add_javascript -src [dict get $version_info cdn]
            security::csp::require script-src cdn.ckeditor.com
            security::csp::require style-src cdn.ckeditor.com
            security::csp::require img-src cdn.ckeditor.com
        }

        #
        # add required general directives for content security policies
        #
        security::csp::require script-src 'unsafe-eval'
        security::csp::require -force script-src 'unsafe-inline'
    }
    
    ad_proc ::richtext::ckeditor4::download {
        {-ck_package ""}
        {-version ""}
    } {
        
        Download the CKeditor package in the specified version and put
        it into a directory structure similar to the CDN structure to
        allow installation of multiple versions. When the local
        structure is available, it will be used by initialize_widget.

        Notice, that for this automated download, the "unzip" program
        must be installed and $::acs::rootdir/packages/www must be
        writable by the web server.
        
    } {
        #
        # If no version or ck editor package are specified, use the
        # namespaced variables as default.
        #
        if {$version eq ""} {
            set version ${::richtext::ckeditor4::version}
        }
        if {$ck_package eq ""} {
            set ck_package ${::richtext::ckeditor4::ck_package}
        }

        set download_url http://download.cksource.com/CKEditor/CKEditor/CKEditor%20${version}/ckeditor_${version}_${ck_package}.zip
        set resources $::acs::rootdir/packages/richtext-ckeditor4/www/resources

        #
        # Do we have unzip installed?
        #
        set unzip [::util::which unzip]
        if {$unzip eq ""} {
            error "can't install CKeditor locally; no unzip program found on PATH" 
        }
        
        #
        # Do we have a writable output directory under resources?
        #
        if {![file isdirectory $resources/$version]} {
            file mkdir $resources/$version
        }
        if {![file writable $resources/$version]} {
            error "directory $resources/$version is not writable"
        }

        #
        # So far, everything is fine, download the editor package
        #
        set result [util::http::get -url $download_url -spool]
        #ns_log notice "GOT $result"
        if {[dict get $result status] == 200} {
            #
            # The Download was successful, unzip it and let the
            # directory structure look similar as on the CDN.
            #
            set fn [dict get $result file]
            set output [exec $unzip -o $fn -d $resources/$version]
            file rename -- $resources/$version/ckeditor $resources/$version/$ck_package
        } else {
            error "download of $download_url failed, HTTP status: [dict get $result status]"
        }
    }

}

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
