# Put the current revision's attributes in a onerow datasource named "content".
# The detected content type is "content_revision".

content::get_content content_revision

if { "text/html" ne $content(mime_type) && ![ad_html_text_convertable_p -from $content(mime_type) -to text/html] } {
    # don't render its content
    cr_write_content -revision_id $content(revision_id)
    ad_script_abort
}

# Ordinary text/* mime type.
template::util::array_to_vars content

set text [cr_write_content -string -revision_id $revision_id]
if { ![string equal "text/html" $content(mime_type)] } {
    set text [ad_html_text_convert -from $content(mime_type) -to text/html -- $text]
}

set context [list $title]

ad_return_template

