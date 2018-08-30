array set config $cf
regsub {/[^/]+$} [ad_conn url] "/xowiki/$config(page_name)" url
