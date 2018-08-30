-- 
-- 
-- 
-- @author Emmanuelle Raffenne (eraffenne@innova.uned.es)
-- @creation-date 2005-12-27
-- @cvs-id $Id: upgrade-2.2.0d1-2.2.0d2.sql,v 1.2.10.1 2017/04/21 20:45:16 gustafn Exp $
--

-- Creating table for site templates                                                                                                           
create table dotlrn_site_templates (
        site_template_id        integer
                                constraint dotlrn_site_templates_st_id_pk primary key,
        pretty_name             varchar(100),
        site_master             varchar(1000) not null,
        portal_theme_id         integer
                                constraint dotlrn_st_portal_theme_id_fk
                                references portal_element_themes(theme_id)
);


-- Altering dotlrn communities table in order to have which
-- site template is going to be using the community

alter table dotlrn_communities_all add site_template_id integer;
alter table dotlrn_communities_all add constraint dotlrn_c_site_template_id_fk foreign key (site_template_id) references dotlrn_site_templates(site_template_id);


-- Altering Users Profile table and dotlrn users view in order to have
-- which site teemplate is going to be using the user

alter table dotlrn_user_profile_rels add site_template_id integer;
alter table dotlrn_user_profile_rels add constraint dotlrn_upr_site_template_id_fk foreign key (site_template_id) references dotlrn_site_templates(site_template_id);

create or replace view dotlrn_users
as
    select acs_rels.rel_id,
           dotlrn_user_profile_rels.portal_id,
           dotlrn_user_profile_rels.theme_id,
           dotlrn_user_profile_rels.id,
           dotlrn_user_profile_rels.site_template_id,
           users.user_id,
           persons.first_names,
           persons.last_name,
           parties.email,
           dotlrn_user_types.type,
           dotlrn_user_types.pretty_name as pretty_type,
           dotlrn_user_types.rel_type,
           dotlrn_user_types.group_id,
           dotlrn_user_types.segment_id
    from dotlrn_user_profile_rels,
         dotlrn_user_types,
         acs_rels,
         parties,
         users,
         persons
    where dotlrn_user_profile_rels.rel_id = acs_rels.rel_id
    and acs_rels.object_id_one = dotlrn_user_types.group_id
    and acs_rels.object_id_two = parties.party_id
    and parties.party_id = users.user_id
    and users.user_id = persons.person_id;


--Creating default site templates 

declare 
	v_site_template_id	dotlrn_site_templates.site_template_id%TYPE;
	v_theme_id		portal_element_themes.theme_id%TYPE;
begin
	select theme_id into v_theme_id 
        from portal_element_themes 
	where name = '#new-portal.sloan_theme_name#'; 
	
	select acs_object_id_seq.nextval 
        into   v_site_template_id 
        from   dual;

	insert into dotlrn_site_templates
	(site_template_id, pretty_name, site_master, portal_theme_id ) 
	values 
	(v_site_template_id, '#new-portal.sloan_theme_name#','/packages/dotlrn/www/dotlrn-master', v_theme_id);
	

	update dotlrn_communities_all set site_template_id = v_site_template_id;
	update dotlrn_user_profile_rels set site_template_id = v_site_template_id;

	update apm_parameter_values 
        set attr_value = v_site_template_id
	where parameter_id in ( select parameter_id 
				from apm_parameters 
				where parameter_name = 'CommDefaultSiteTemplate_p' or parameter_name = 'UserDefaultSiteTemplate_p');

end;
/
show errors

-- Create auxiliary tables

create table apm_parameter_values_copy (
	value_id	        integer,	
	package_id		integer, 
	parameter_id		integer, 
	attr_value		varchar(4000)
);

insert into apm_parameter_values_copy (
	value_id,	
	package_id, 
	parameter_id, 
	attr_value 
) select * from apm_parameter_values;
