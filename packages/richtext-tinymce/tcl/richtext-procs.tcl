ad_library {

    Integration of TinyMCE with the richtext widget of acs-templating.

    This script defines the following two procs:

       ::richtext-tinymce::initialize_widget
       ::richtext-tinymce::render_widgets  

    @author Gustaf Neumann
    @creation-date 1 Jan 2016
    @cvs-id $Id: richtext-procs.tcl,v 1.1.2.4 2016/11/15 10:44:15 gustafn Exp $
}

namespace eval ::richtext::tinymce {

    ad_proc initialize_widget {
        -form_id
        -text_id
        {-options {}}
    } {

        Initialize an TinyMCE richtext editor widget.
        This proc defines finally the global variable

        ::acs_blank_master(tinymce.config)

    } {
        ns_log debug "Initialize TinyMCE instance with <$options>"
        #
        # Build specific javascript configurations from widget options
        # and system parameters
        #

        #
        # Use the following default config
        #
        set tinymce_default_config {
            {mode "exact" }
            {relative_urls "false"}
            {height "450px" }
            {width "100%"}
            {plugins "style,layer,table,save,iespell,preview,media,searchreplace,print,contextmenu,paste,fullscreen,noneditable,visualchars,xhtmlxtras" }
            {browsers "msie,gecko,safari,opera" }
            {apply_source_formatting "true" }
            {paste_auto_cleanup_on_paste true}
            {paste_convert_headers_to_strong true}
            {fix_list_elements true}
            {fix_table_elements true}
            {theme "openacs"}
            {theme_openacs_toolbar_location "top" }
            {theme_openacs_toolbar_align "left" }
            {theme_openacs_statusbar_location "bottom" }
            {theme_openacs_resizing true}
            {theme_openacs_disable "styleselect"}
            {theme_openacs_buttons1_add_before "save,separator"}
            {theme_openacs_buttons2_add "separator,preview,separator,forecolor,backcolor"}
            {theme_openacs_buttons2_add_before "cut,copy,paste,pastetext,pasteword,separator,search,replace,separator"}
            {theme_openacs_buttons3_add_before "tablecontrols,separator"}
            {theme_openacs_buttons3_add "iespell,media,separator,print,separator,fullscreen"}
            {extended_valid_elements "img[id|class|style|title|lang|onmouseover|onmouseout|src|alt|name|width|height],hr[id|class|style|title],span[id|class|style|title|lang]"}
            {element_format "html"}
        }

        set config [parameter::get \
                        -package_id [apm_package_id_from_key "richtext-tinymce"] \
                        -parameter "TinyMCEDefaultConfig" \
                        -default ""]

        set configLegacy [parameter::get \
                              -package_id [apm_package_id_from_key "acs-templating"] \
                              -parameter "TinyMCEDefaultConfig" \
                              -default ""]

        set tinymce_configs_list $config
        if {$configLegacy ne ""} {
            if {$config eq ""} {
                #
                # We have no per-package config, but got a legacy
                # config.
                #
                set tinymce_configs_list $configLegacy
                ns_log warning "richtext-tinymce uses legacy parameters from acs-templating;\
                    	TinyMCEDefaultConfig should be set in the package parameters of richtext-tinycme, not in acs-templating."
            } else {
                #
                # Config for this package and legacy config in
                # acs-templating is set, ignore config from
                # acs-templating.
                #
                ns_log warning "richtext-tinymce ignores legacy parameters from acs-templating;
                    	TinyMCEDefaultConfig should be set in the package parameters of richtext-xinha, not in acs-templating;\
			when done, empty parameter setting for TinyMCEDefaultConfig in acs-templating."
            }
        }
        if {$tinymce_configs_list eq ""} {
            set tinymce_configs_list $tinymce_default_config
        }

        ns_log debug "tinymce: options $options"

        set pairslist [list]
        foreach config_pair $tinymce_configs_list {
            set config_key [lindex $config_pair 0]
            if {[dict exists $options $config_key]} {
                # override default values with individual
                # widget specification
                set config_value [dict get $options $config_key]
                dict unset options $config_key
            } else {
                set config_value [lindex $config_pair 1]
            }
            ns_log debug "tinymce: key $config_key value $config_value"
            if  {$config_value eq "true" || $config_value eq "false"} {
                lappend pairslist "${config_key}:${config_value}"
            } else {
                lappend pairslist "${config_key}:\"${config_value}\""
            }
        }

        foreach name [dict keys $options] {
            ns_log debug "tinymce: NAME $name"
            # add any additional options not specified in the
            # default config
            lappend pairslist "${name}:\"[dict get $options $name]\""
        }

        lappend pairslist "elements : \"[join $::acs_blank_master__htmlareas ","]\""

        set tinymce_configs_js [join $pairslist ","]
        set ::acs_blank_master(tinymce.config) $tinymce_configs_js

        #ns_log notice "final ::acs_blank_master(tinymce.config):\n$tinymce_configs_js"

        return ""
    }


    ad_proc render_widgets {} {

        Render the TinyMCE rich-text widgets. This function is created
        at a time when all rich-text widgets of this page are already
        initialized. The function is controlled via the global variables

           ::acs_blank_master(tinymce)
           ::acs_blank_master(tinymce.config)
           ::acs_blank_master__htmlareas

    } {
        #
        # In case no editor instances are created, or we are on a
        # mobile browser, which is not supported be the current
        # version of tinymce, nothing has to be done (i.e. the plain
        # text area will be shown).  Probably, newer versions of
        # tinymce provide some mobile support.
        #
        if {![info exists ::acs_blank_master(tinymce)] || [ad_conn mobile_p]} {
            return
        }

        # Antonio Pisano 2015-03-27: including big javascripts in head
        # is discouraged by current best practices for web.  We should
        # consider moving every inclusion like this in the body. As
        # consequences are non-trivial, just warn for now.
        #
        template::head::add_javascript \
            -src "/resources/richtext-tinymce/tinymce/jscripts/tiny_mce/tiny_mce_src.js" \
            -order tinymce0

        # get the textareas where we apply tinymce
        set tinymce_elements [list]
        foreach htmlarea_id [lsort -unique $::acs_blank_master__htmlareas] {
            lappend tinymce_elements $htmlarea_id
        }
        set tinymce_config $::acs_blank_master(tinymce.config)

        #
        # Figure out the language to use: 1st is the user language, if
        # not available then the system one, fallback to english which
        # is provided by default
        #
        set tinymce_relpath "packages/richtext-tinymce/www/resources/tinymce/jscripts/tiny_mce"
        set lang_list [list [lang::user::language] [lang::system::language]]
        set tinymce_lang "en"
        foreach elm $lang_list {
            if { [file exists $::acs::rootdir/${tinymce_relpath}/langs/${elm}.js] } {
                set tinymce_lang $elm
                break
            }
        }
        
        #
        # TODO : each element should have it's own init
        #
        template::add_script -script [subst {
            tinyMCE.init(\{language: \"$tinymce_lang\", $tinymce_config\});
        }] -section body
    }
}

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
