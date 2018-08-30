-- Store emails to be sent when user joins a community
create table dotlrn_member_emails (
        email_id	integer primary key,
        community_id    integer references dotlrn_communities_all (community_id)
                        on delete cascade,
-- Might be useful
        type            varchar2(30) default 'on join',
        from_addr       varchar2(256),
        subject         varchar2(4000),
        email           long,
        enabled_p       char(1) default 'f'
	                check (enabled_p in ('t', 'f')),
			constraint dotlrn_member_emails_un unique(community_id, type)
);

create sequence dotlrn_member_emails_seq
start with 1
increment by 1
nomaxvalue;

create trigger dotlrn_member_emails_trigger
before insert on dotlrn_member_emails
for each row
begin
	select dotlrn_member_emails_seq.nextval into :new.email_id from dual;
end;
/

