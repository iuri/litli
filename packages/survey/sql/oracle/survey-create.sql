-- based on student work from 6.916 in Fall 1999
-- which was in turn based on problem set 4
-- in http://photo.net/teaching/one-term-web.html
--
-- by philg@mit.edu and raj@alum.mit.edu on February 9, 2000
-- converted to ACS 4.0 by nstrug@arsdigita.com on 29th September 2000
-- modified for dotLRN/OpenACS4.5 and renamed from "simple-survey" to "survey" 
--    by dave@thedesignexperience.org on 13 July 2002
--
-- $Id: survey-create.sql,v 1.3 2003/05/17 12:28:04 jeffd Exp $

begin

	acs_privilege.create_privilege('survey_create_survey');
	acs_privilege.create_privilege('survey_modify_survey');
	acs_privilege.create_privilege('survey_delete_survey');
	acs_privilege.create_privilege('survey_create_question');
	acs_privilege.create_privilege('survey_modify_question');
	acs_privilege.create_privilege('survey_delete_question');
	acs_privilege.create_privilege('survey_take_survey');

	acs_privilege.create_privilege('survey_admin_survey');

	acs_privilege.add_child('survey_admin_survey','survey_create_survey');
	acs_privilege.add_child('survey_admin_survey','survey_modify_survey');
	acs_privilege.add_child('survey_admin_survey','survey_delete_survey');
	acs_privilege.add_child('survey_admin_survey','survey_create_question');
	acs_privilege.add_child('survey_admin_survey','survey_modify_question');
	acs_privilege.add_child('survey_admin_survey','survey_delete_question');

	acs_privilege.add_child('read','survey_take_survey');
	acs_privilege.add_child('admin','survey_admin_survey');

	acs_object_type.create_type (
		supertype => 'acs_object',
		object_type => 'survey',
		pretty_name => 'Survey',
		pretty_plural => 'Surveys',
		table_name => 'SURVEYS',
		id_column => 'SURVEY_ID',
		name_method => 'survey.name'
	);
	acs_object_type.create_type (
		supertype => 'acs_object',
		object_type => 'survey_section',
		pretty_name => 'Survey_Section',
		pretty_plural => 'Survey_Sections',
		table_name => 'SURVEY_SECTIONS',
		id_column => 'SECTION_ID'
	);

	acs_object_type.create_type (
		supertype => 'acs_object',
		object_type => 'survey_question',
		pretty_name => 'Survey Question',
		pretty_plural => 'Survey Questions',
		table_name => 'SURVEY_QUESTIONS',
		id_column => 'QUESTION_ID'
	);

	acs_object_type.create_type (
		supertype => 'acs_object',
		object_type => 'survey_response',
		pretty_name => 'Survey Response',
		pretty_plural => 'Survey Responses',
		table_name => 'SURVEY_RESPONSES',
		id_column => 'RESPONSE_ID'
	);


end;
/
show errors

create table surveys (
	survey_id		constraint surveys_survey_id_fk
				references acs_objects (object_id)
                                constraint surveys_pk
				primary key,
	name			varchar(4000)
				constraint surveys_name_nn
				not null,
	description		varchar(4000)
				constraint surveys_desc_nn
				not null,
        description_html_p      char(1)
                                constraint surveys_desc_html_p_ck
				check(description_html_p in ('t','f')),
	enabled_p               char(1)
				constraint surveys_enabled_p_ck
				check(enabled_p in ('t','f')),
	-- limit to one response per user
	single_response_p	char(1)
				constraint surveys_single_resp_p_ck
				check(single_response_p in ('t','f')),
	editable_p		char(1)
				constraint surveys_single_edit_p_ck
				check(editable_p in ('t','f')),
        single_section_p        char(1)
				constraint surveys_single_section_p_ck
				check(single_section_p in ('t','f')),
	type                    varchar(20),
        display_type            varchar(20),
        package_id              integer
                                constraint surveys_package_id_nn not null
                                constraint surveys_package_id_fk references
                                apm_packages (package_id) on delete cascade
);

create table survey_sections (
	section_id		constraint survey_sections_section_id_fk
				references acs_objects (object_id)
                                constraint survey_sections_pk
				primary key,
	survey_id		integer
				constraint survey_sections_survey_id_nn
				not null
				constraint survey_sections_survey_id_fk
				references surveys,
	name			varchar(4000)
				constraint survey_sections_name_nn
				not null,
	description		clob 
				constraint survey_sections_desc_nn
				not null,
        description_html_p      char(1)
                                constraint survey_sections_desc_html_p_ck
				check(description_html_p in ('t','f'))
);

create index survey_sections_survey_id_fk on survey_sections(survey_id);

create table survey_questions (
	question_id		constraint survey_q_question_id_fk
				references acs_objects (object_id)
				constraint survey_q_question_id_pk
				primary key,
	section_id		constraint survey_q_section_id_fk
				references survey_sections,
	sort_order		integer
				constraint survey_q_sort_order_nn
				not null,
	question_text		clob
				constraint survey_q_question_text_nn
				not null,
        abstract_data_type      varchar(30)
				constraint survey_q_abs_data_type_ck
				check (abstract_data_type in ('text', 'shorttext', 'boolean', 'number', 'integer', 'choice', 'date','blob')),
	required_p		char(1)
				constraint survey_q_required_p_ck
				check (required_p in ('t','f')),
	active_p		char(1)
				constraint survey_q_qctive_p_ck
				check (active_p in ('t','f')),
	presentation_type	varchar(20)
				constraint survey_q_pres_type_nn
				not null
				constraint survey_q_pres_type_ck
				check(presentation_type in ('textbox','textarea','select','radio', 'checkbox', 'date', 'upload_file')),
	-- for text, "small", "medium", "large" sizes
	-- for textarea, "rows=X cols=X"
	presentation_options	varchar(50),
	presentation_alignment	varchar(15)
				constraint survey_q_pres_alignment_ck
            			check(presentation_alignment in ('below','beside'))    
);

create index survey_q_sort_order on survey_questions(sort_order);
create index survey_q_active_p on survey_questions(active_p);

-- for when a question has a fixed set of responses

create sequence survey_choice_id_sequence start with 1;

create table survey_question_choices (
        choice_id       integer constraint survey_qc_choice_id_nn
                        not null
                        constraint survey_qc_choice_id_pk
                        primary key,
        question_id     constraint survey_qc_question_id_nn
                        not null
                        constraint survey_qc_question_id_fk
                        references survey_questions,
        -- human readable
        label           varchar(500) constraint survey_qc_label_nn
			not null,
        -- might be useful for averaging or whatever, generally null
        numeric_value   number,
        -- lower is earlier
        sort_order      integer
);

create index survey_q_c_question_id on survey_question_choices(question_id);
create index survey_q_c_sort_order on survey_question_choices(sort_order);

-- this records a response by one user to one survey
-- (could also be a proposal in which case we'll do funny 
--  things like let the user give it a title, send him or her
--  email if someone comments on it, etc.)
create table survey_responses (
	response_id		constraint survey_resp_response_id_fk
				references acs_objects (object_id)
				constraint survey_resp_response_id_pk
				primary key,
	initial_response_id	constraint init_resp_id_fk
				references survey_responses (response_id),
	survey_id		constraint survey_resp_survey_id_fk
				references surveys,
	title			varchar(100),
	notify_on_comment_p	char(1)
				constraint survey_resp_noton_com_p_ck
				check(notify_on_comment_p in ('t','f'))
);



-- this table stores the answers to each question for a survey
-- we want to be able to hold different data types in one long skinny table 
-- but we also may want to do averages, etc., so we can't just use CLOBs

create table survey_question_responses (
	response_id		not null references survey_responses,
	question_id		not null references survey_questions,
	-- if the user picked a canned response
	choice_id		references survey_question_choices,
	boolean_answer		char(1) check(boolean_answer in ('t','f')),
	clob_answer		clob,
	number_answer		number,
	varchar_answer		varchar(4000),
	date_answer		date,
	attachment_answer	integer
				constraint survey_q_resp_rev_id_fk
                                references cr_revisions(revision_id)
                                on delete cascade
);

create index survey_response_index on survey_question_responses (response_id, question_id);
create index survey_q_r_choice_id on survey_question_responses(choice_id);
create index survey_q_r_attachment_answer on survey_question_responses(attachment_answer);

@@ survey-package-create.sql
@@ survey-notifications-init.sql