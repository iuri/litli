<?xml version="1.0"?>
<!DOCTYPE queryset PUBLIC "-//OpenACS//DTD XQL 1.0//EN" "http://www.thecodemill.biz/repository/xql.dtd">
<!-- packages/dotlrn/www/member-email.xql -->
<!-- @author Roel Canicula (roelmc@pldtdsl.net) -->
<!-- @creation-date 2005-07-22 -->
<!-- @arch-tag: 168aeaa5-a52c-450f-9dbe-e436b14a91a7 -->
<!-- @cvs-id $Id: member-email.xql,v 1.2 2006/08/08 21:26:24 donb Exp $ -->

<queryset>
  <fullquery name="member_email">
    <querytext>
      select email_id
      from dotlrn_member_emails
      where community_id = :community_id
      and type = 'on join'
    </querytext>
  </fullquery>

  <fullquery name="new_email">
    <querytext>
      insert into
      dotlrn_member_emails
      (community_id, type, from_addr, subject, email)
      values
      (:community_id, 'on join', :from_addr, :subject, :email)
    </querytext>
  </fullquery>  

  <fullquery name="member_email_values">
    <querytext>
      select from_addr,
             subject,
             email
      from dotlrn_member_emails
      where email_id = :email_id
    </querytext>
  </fullquery>

  <fullquery name="update_email">
    <querytext>
      update dotlrn_member_emails
      set from_addr = :from_addr,
          subject = :subject,
          email = :email
      where email_id = :email_id
    </querytext>
  </fullquery>
</queryset>