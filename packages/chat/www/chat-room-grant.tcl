ad_page_contract {
    
    @author David Dao (ddao@arsdigita.com)
    @creation-date November 16, 2000
    @cvs-id $Id: chat-room-grant.tcl,v 1.2.22.1 2016/06/20 08:40:23 gustafn Exp $
} {
    room_id:naturalnum,notnull
    pretty_name:trim,notnull
    require_privilege:trim,notnull
    assign_privilege:trim,notnull
}

permission::require_permission -object_id $room_id -privilege $require_privilege

doc_body_append "[ad_header "Grant permission on $pretty_name"]

<h2>Grant permission on $pretty_name</h2>

[list "Grant permission on $pretty_name"]

<hr>

<form method=post action=chat-room-grant-2>
[export_vars -form {room_id require_privilege assign_privilege}]
<select name=party_id>
"

db_foreach parties {
  select party_id, acs_object.name(party_id) as name
  from parties
} {
  doc_body_append "<option value=$party_id>$name</option>\n"
}

doc_body_append "
</select>

</form>

[ad_footer]
"
