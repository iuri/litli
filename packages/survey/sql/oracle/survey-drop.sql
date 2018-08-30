--
-- drop SQL for survey package
--
-- by nstrug@arsdigita.com on 29th September 2000
--
-- $Id: survey-drop.sql,v 1.2 2002/09/16 01:04:51 daveb Exp $

@@ survey-package-drop.sql

drop view survey_ques_responses_latest;
drop table survey_question_responses cascade constraints;
drop view survey_responses_latest;
drop table survey_responses cascade constraints;
drop table survey_question_choices cascade constraints;

drop sequence survey_choice_id_sequence;
drop table survey_questions cascade constraints;
drop table survey_sections cascade constraints;
drop table surveys cascade constraints;

-- nuke all created objects
-- need to do this before nuking the types
delete from acs_objects where object_type = 'survey_response';
delete from acs_objects where object_type = 'survey_question';
delete from acs_objects where object_type = 'survey_section';
delete from acs_objects where object_type = 'survey';

begin
	acs_rel_type.drop_type('user_blob_response_rel');

	acs_object_type.drop_type ('survey_response');
	acs_object_type.drop_type ('survey_question');
	acs_object_type.drop_type ('survey_section');
	acs_object_type.drop_type ('survey');

	acs_privilege.remove_child ('admin','survey_admin_survey');
	acs_privilege.remove_child ('read','survey_take_survey');
	acs_privilege.remove_child ('survey_admin_survey','survey_delete_question');
	acs_privilege.remove_child ('survey_admin_survey','survey_modify_question');
	acs_privilege.remove_child ('survey_admin_survey','survey_create_question');
	acs_privilege.remove_child ('survey_admin_survey','survey_delete_survey');
	acs_privilege.remove_child ('survey_admin_survey','survey_modify_survey');
	acs_privilege.remove_child ('survey_admin_survey','survey_create_survey');

	acs_privilege.drop_privilege('survey_admin_survey');
	acs_privilege.drop_privilege('survey_take_survey');
	acs_privilege.drop_privilege('survey_delete_question');
	acs_privilege.drop_privilege('survey_modify_question');
	acs_privilege.drop_privilege('survey_create_question');
	acs_privilege.drop_privilege('survey_delete_survey');
	acs_privilege.drop_privilege('survey_modify_survey');
	acs_privilege.drop_privilege('survey_create_survey');


end;
/
show errors


