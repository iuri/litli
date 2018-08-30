ad_page_contract {
  This is the top level master template.  It allows the basic parts of an XHTML 
  document to be set through convenient data structures without introducing 
  anything site specific.

  You should NEVER need to modify this file.  
  
  Most of the time your pages or master templates should not directly set this
  file in their <master> tag.  They should instead use site-master with 
  provides a set of standard OpenACS content.  Only pages which need to return
  raw HTML should use this template directly.

  When using this template directly you MUST supply the following variables:

  @property doc(title)        The document title, ie. <title /> tag.
  @property doc(title_lang)   The language of the document title, if different
                              from the document language.

  The document output can be customised by supplying the following variables:

  @property doc(type)         The declared xml DOCTYPE.
  @property doc(charset)      The document character set.
  @property body(id)          The id attribute of the body tag.
  @property body(class)       The class of the body tag.

  ad_conn -set language       Must be used to override the document language
                              if necessary.

  To add a CSS or Javascripts to the <head> section of the document you can 
  call the corresponding template::head::add_* functions within your page.

  @see template::head::add_css
  @see template::head::add_javascript

  More generally, meta, link and script tags can be added to the <head> section
  of the document by calling their template::head::add_* function within your
  page.

  @see template::head::add_meta
  @see template::head::add_link
  @see template::head::add_script

  Javascript event handlers, such as onload, an be added to the <body> tag by 
  calling template::add_body_handler within your page.

  @see template::add_body_handler

  Finally, for more advanced functionality see the documentation for 
  template::add_body_script, template::add_header and template::add_footer.

  @see template::add_body_script
  @see template::add_header
  @see template::add_footer
 
  @author Kevin Scaldeferri (kevin@arsdigita.com)
          Lee Denison (lee@xarg.co.uk)
  @creation-date 14 Sept 2000

  $Id: blank-master.tcl,v 1.5 2014/10/27 16:40:53 victorg Exp $
}

if {![info exists doc(type)]} { 
    set doc(type) {<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">}
}

if {![info exists doc(title)]} {
    set doc(title) "[ad_conn instance_name]"
    ns_log warning "[ad_conn url] has no doc(title) set."
}
if {![info exists doc(charset)]} {
    set doc(charset) [ns_config ns/parameters OutputCharset [ad_conn charset]]
}

# The document language is always set from [ad_conn lang] which by default 
# returns the language setting for the current user.  This is probably
# not a bad guess, but the rest of OpenACS must override this setting when
# appropriate and set the lang attribxute of tags which differ from the language
# of the page.  Otherwise we are lying to the browser.
set doc(lang) [ad_conn language]

# AG: Markup in <title> tags doesn't render well.
set doc(title) [ns_striphtml $doc(title)]

# Generate the <meta /> tag multirow
variable ::template::head::metas
template::multirow create meta name content http_equiv scheme lang
template::multirow append meta \
    "" \
    "text/html; charset=$doc(charset)" \
    "content-type"

if {[array exists metas]} {
    foreach name [array names metas] {
        foreach {http_equiv name scheme content lang} $metas($name) {
            template::multirow append meta \
                $name \
                $content \
                $http_equiv \
                $scheme \
                $lang
        }
    }
  unset metas
}

# Generate the <link /> tag multirow
variable ::template::head::links
template::multirow create link rel type href title lang media
if {[array exists links]} {
    foreach name [array names links] {
        foreach {rel href type media title lang} $links($name) {
            template::multirow append link \
                $rel \
                $type \
                $href \
                $title \
                $lang \
                $media
        }
    }
  unset links
}

# Generate the head <script /> tag multirow
variable ::template::head::scripts
template::multirow create headscript type src charset defer content order
if {[array exists scripts]} {
    foreach name [array names scripts] {
        foreach {type src charset defer content order} $scripts($name) {
            template::multirow append headscript \
                $type \
                $src \
                $charset \
                $defer \
                $content \
                $order
        }
    }
    template::multirow sort headscript order
  unset scripts
}

# Generate the body <script /> tag multirow
variable ::template::body_scripts
template::multirow create body_script type src charset defer content
if {[info exists body_scripts]} {
    foreach {type src charset script defer} $body_scripts {
        template::multirow append body_script \
            $type \
            $src \
            $charset \
            $defer \
            $content
    }
  unset body_scripts
}

# Concatenate the javascript event handlers for the body tag
variable ::template::body_handlers
if {[array exists body_handlers]} {
    set names [array names body_handlers]

    foreach name $names {
        set event [lindex [split $name ","] 0]

        foreach javascript $body_handlers($name) {
            lappend body_handlers($event) "[string trimright $javascript "; "];"
        }

        unset body_handlers($name)
     }
}

# Now create the event handlers string
foreach {event script} [array get body_handlers] {
    append event_handlers " ${event}=\"$script\""
}
 
# Generate the body headers
variable ::template::headers
set header ""
if {[info exists headers]} {
    foreach header_list $headers {
    set type [lindex $header_list 0]
    set src [lindex $header_list 1]
    set params [lindex $header_list 2]
        if {$type eq "literal"} {
            append header $src
        } elseif {$type eq "include"} {
        set adp_html  [template::adp_include $src $params]
        if {$adp_html ne ""} {
        append header $adp_html
        }
        }
    }
  unset headers
}

# Generate the body footers
variable ::template::footers
set footer ""
if {[info exists footers]} {
    foreach footer_list $footers {
    set type [lindex $footer_list 0]
    set src [lindex $footer_list 1]
    set params [lindex $footer_list 2]
        if {$type eq "literal"} {
            append footer $src
        } else {
        set adp_html  [template::adp_include $src $params]
        if {$adp_html ne ""} {
        lappend footer
        }
        }
    }
  unset footers
}
