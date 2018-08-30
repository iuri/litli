--
-- drop SQL for survey package
--
-- by nstrug@arsdigita.com on 29th September 2000
--
-- $Id: survey-drop.sql,v 1.5 2013/11/06 07:33:54 gustafn Exp $

select drop_package('survey_response');
select drop_package('survey_question');
select drop_package('survey_section');
select drop_package('survey');

-- The following two views are already dropped by the drop_package
-- commands by using used for "drop function .... CASCADE';

--drop view survey_responses_latest;
--drop view survey_ques_responses_latest;

drop table survey_question_responses;
drop table survey_responses;
drop table survey_question_choices;
drop view survey_choice_id_sequence;
drop sequence survey_choice_id_seq;
drop table survey_questions;
drop table survey_sections;
drop table surveys;

-- nuke all created objects
-- need to do this before nuking the types
delete from acs_objects where object_type = 'survey_response';
delete from acs_objects where object_type = 'survey_question';
delete from acs_objects where object_type = 'survey_section';
delete from acs_objects where object_type = 'survey';

CREATE OR REPLACE FUNCTION inline_0 () RETURNS integer AS $$
BEGIN

  PERFORM acs_object_type__drop_type ('survey_response','f');
  PERFORM acs_object_type__drop_type ('survey_question','f');
  PERFORM acs_object_type__drop_type ('survey_section','f');
  PERFORM acs_object_type__drop_type ('survey','f');

  PERFORM acs_privilege__remove_child ('admin','survey_admin_survey');
  PERFORM acs_privilege__remove_child ('read','survey_take_survey');
  PERFORM acs_privilege__remove_child ('survey_admin_survey','survey_delete_question');
  PERFORM acs_privilege__remove_child ('survey_admin_survey','survey_modify_question');
  PERFORM acs_privilege__remove_child ('survey_admin_survey','survey_create_question');
  PERFORM acs_privilege__remove_child ('survey_admin_survey','survey_delete_survey');
  PERFORM acs_privilege__remove_child ('survey_admin_survey','survey_modify_survey');
  PERFORM acs_privilege__remove_child ('survey_admin_survey','survey_create_survey');
  
  PERFORM acs_privilege__drop_privilege('survey_admin_survey'); 
  PERFORM acs_privilege__drop_privilege('survey_take_survey'); 
  PERFORM acs_privilege__drop_privilege('survey_delete_question'); 
  PERFORM acs_privilege__drop_privilege('survey_modify_question'); 
  PERFORM acs_privilege__drop_privilege('survey_create_question'); 
  PERFORM acs_privilege__drop_privilege('survey_delete_survey'); 
  PERFORM acs_privilege__drop_privilege('survey_modify_survey'); 
  PERFORM acs_privilege__drop_privilege('survey_create_survey'); 

  return 0;
END;
$$ LANGUAGE plpgsql;

select inline_0 ();
drop function inline_0 ();

-- gilbertw - logical_negation is defined in utilities-create.sql in acs-kernel
-- drop function logical_negation(boolean);

\i survey-notifications-drop.sql
