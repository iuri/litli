-- 
-- 
-- 
-- @author Emmanuelle RAffenne (eraffenne@innova.uned.es)
-- @creation-date 2005-12-27
-- @cvs-id $Id: site-templates-create.sql,v 1.2 2006/08/08 21:26:21 donb Exp $
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


-- Creating default site templates 

declare 
	v_site_template_id	dotlrn_site_templates.site_template_id%TYPE;
	v_theme_id		portal_element_themes.theme_id%TYPE;
begin

        select theme_id into v_theme_id 
        from portal_element_themes 
	where name = '#new-portal.sloan_theme_name#'; 

	select acs_object_id_seq.nextval 
        into v_site_template_id 
        from dual;

	insert into dotlrn_site_templates
	(site_template_id, pretty_name, site_master, portal_theme_id ) 
	values 
	(v_site_template_id, '#new-portal.sloan_theme_name#','/packages/dotlrn/www/dotlrn-master', v_theme_id);
	
end;
/
show errors
