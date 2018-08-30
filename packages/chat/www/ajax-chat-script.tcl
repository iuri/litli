ad_page_contract {
  a tiny chat client

  @author Gustaf Neumann (gustaf.neumann@wu-wien.ac.at)
  @creation-date Jan 31, 2006
  @cvs-id $Id: ajax-chat-script.tcl,v 1.7 2008/11/09 23:29:23 donb Exp $
} -query {
  msg:optional
}

set html_room_url [export_vars -base "room-enter" {room_id {client html}}]

set chat_frame [ ::chat::Chat login -chat_id $room_id]

