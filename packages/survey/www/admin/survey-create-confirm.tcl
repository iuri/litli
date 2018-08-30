if {$desc_html eq "pre"} {
    set description [ad_text_to_html $description]
} elseif {$desc_html eq "plain"} {
    set description [ns_quotehtml $description]
}

