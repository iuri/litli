-- 
-- 
-- 
-- @author Victor Guerra (guerra@galileo.edu)
-- @creation-date 2005-11-10
-- @arch-tag: ced27b4e-bb86-4866-be53-916bc65de2cb
-- @cvs-id $Id: site-templates-create.sql,v 1.4 2013/11/01 21:08:29 gustafn Exp $
--

-- Creating table for site templates                                                                                                           
create table dotlrn_site_templates (
        site_template_id        integer
                                constraint dotlrn_site_templates_st_id_pk primary key,
        pretty_name             varchar(100),
        site_master             varchar(1000) not null,
        portal_theme_id         integer
                                constraint dotlrn_ste_templates_p_theme_id_fk
                                references portal_element_themes(theme_id)
);


-- Altering dotlrn communities table in order to have which
-- site template is going to be using the community

-- alter table dotlrn_communities_all add column site_template_id integer;
-- alter table dotlrn_communities_all add constraint dotlrn_c_site_template_id_fk foreign key (site_template_id) references dotlrn_site_templates(site_template_id);


-- Altering Users Profile table and dotlrn users view in order to have
-- which site teemplate is going to be using the user

-- alter table dotlrn_user_profile_rels add column site_template_id integer;
-- alter table dotlrn_user_profile_rels add constraint dotlrn_usr_prfl_rels_site_template_id_fk foreign key (site_template_id) references dotlrn_site_templates(site_template_id);

-- drop view dotlrn_users;

-- create view dotlrn_users
-- as
--     select acs_rels.rel_id,
--            dotlrn_user_profile_rels.portal_id,
--            dotlrn_user_profile_rels.theme_id,
--            dotlrn_user_profile_rels.id,
--            dotlrn_user_profile_rels.site_template_id,
--            users.user_id,
--            persons.first_names,
--            persons.last_name,
--            parties.email,
--            dotlrn_user_types.type,
--            dotlrn_user_types.pretty_name as pretty_type,
--            dotlrn_user_types.rel_type,
--            dotlrn_user_types.group_id,
--            dotlrn_user_types.segment_id
--     from dotlrn_user_profile_rels,
--          dotlrn_user_types,
--          acs_rels,
--          parties,
--          users,
--          persons
--     where dotlrn_user_profile_rels.rel_id = acs_rels.rel_id
--     and acs_rels.object_id_one = dotlrn_user_types.group_id
--     and acs_rels.object_id_two = parties.party_id
--     and parties.party_id = users.user_id
--     and users.user_id = persons.person_id;


--Creating default site templates 



--
-- procedure inline_0/0
--
CREATE OR REPLACE FUNCTION inline_0(

) RETURNS integer AS $$
DECLARE 
	v_site_template_id	dotlrn_site_templates.site_template_id%TYPE;
	v_theme_id		portal_element_themes.theme_id%TYPE;
BEGIN
        select theme_id into v_theme_id 
        from portal_element_themes 
	where name = '#new-portal.sloan_theme_name#'; 

	select nextval('t_acs_object_id_seq')
        into v_site_template_id 
        from dual;

	insert into dotlrn_site_templates
	(site_template_id, pretty_name, site_master, portal_theme_id ) 
	values 
	(v_site_template_id, '#new-portal.sloan_theme_name#','/packages/dotlrn/www/dotlrn-master', v_theme_id);
	
	return v_site_template_id;

END;
$$ LANGUAGE plpgsql;

select inline_0();

drop function inline_0();
