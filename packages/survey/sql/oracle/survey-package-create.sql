-- start off with package declarations


create or replace package survey
as
    function new (
        survey_id in surveys.survey_id%TYPE default null,
        name in surveys.name%TYPE,
        description in surveys.description%TYPE,
        description_html_p in surveys.description_html_p%TYPE default 'f',
        single_response_p in surveys.single_response_p%TYPE default 'f',
        editable_p in surveys.editable_p%TYPE default 't',
        enabled_p in surveys.enabled_p%TYPE default 'f',
        single_section_p in surveys.single_section_p%TYPE default 't',
        type in surveys.type%TYPE default 'general',
        display_type in surveys.display_type%TYPE default 'list',
        package_id in surveys.package_id%TYPE,
        object_type in acs_objects.object_type%TYPE default 'survey',
        creation_date in acs_objects.creation_date%TYPE default sysdate,
        creation_user in acs_objects.creation_user%TYPE default null,
        creation_ip in acs_objects.creation_ip%TYPE default null,
        context_id in acs_objects.context_id%TYPE default null
) return acs_objects.object_id%TYPE;

    procedure remove (
        survey_id in surveys.survey_id%TYPE
    );

    function name (
        survey_id in surveys.survey_id%TYPE
    ) return varchar;

end survey;
/
show errors



-- survey_section

create or replace package survey_section
as
    function new (
	section_id in survey_sections.section_id%TYPE default null,
	survey_id in survey_sections.survey_id%TYPE default null,
	name in survey_sections.name%TYPE default null,
 	description in survey_sections.description%TYPE default null,
	description_html_p in survey_sections.description_html_p%TYPE default null,
        object_type in acs_objects.object_type%TYPE default 'survey_section',
        creation_date in acs_objects.creation_date%TYPE default sysdate,
        creation_user in acs_objects.creation_user%TYPE default null,
        creation_ip in acs_objects.creation_ip%TYPE default null,
        context_id in acs_objects.context_id%TYPE default null
    )  return acs_objects.object_id%TYPE;

    procedure remove (
	section_id in survey_sections.section_id%TYPE
    );
end survey_section;
/
show errors

--
-- constructor for a survey_question
--

create or replace package survey_question
as
    function new (
        question_id in survey_questions.question_id%TYPE default null,
        section_id in survey_questions.section_id%TYPE default null,
        sort_order in survey_questions.sort_order%TYPE default null,
        question_text in survey_questions.question_text%TYPE default null,
        abstract_data_type in survey_questions.abstract_data_type%TYPE default null,
        required_p in survey_questions.required_p%TYPE default 't',
        active_p in survey_questions.active_p%TYPE default 't',
        presentation_type in survey_questions.presentation_type%TYPE default null,
        presentation_options in survey_questions.presentation_options%TYPE default null,
        presentation_alignment in survey_questions.presentation_alignment%TYPE default 'below',
        object_type in acs_objects.object_type%TYPE default 'survey_question',
        creation_date in acs_objects.creation_date%TYPE default sysdate,
        creation_user in acs_objects.creation_user%TYPE default null,
        creation_ip in acs_objects.creation_ip%TYPE default null,
        context_id in acs_objects.context_id%TYPE default null
    ) return acs_objects.object_id%TYPE;

    procedure remove (
        question_id in survey_questions.question_id%TYPE
    );
end survey_question;
/
show errors


--
-- constructor for a survey_response
--

create or replace package survey_response
as
    function new (
        response_id in survey_responses.response_id %TYPE default null,
        survey_id in survey_responses.survey_id%TYPE default null,
        title in survey_responses.title%TYPE default null,
        notify_on_comment_p in survey_responses.notify_on_comment_p%TYPE default 'f',
        object_type in acs_objects.object_type%TYPE default 'survey_response',
        creation_date in acs_objects.creation_date%TYPE default sysdate,
        creation_user in acs_objects.creation_user%TYPE default null,
        creation_ip in acs_objects.creation_ip%TYPE default null,
        context_id in acs_objects.context_id%TYPE default null,
	initial_response_id in survey_responses.initial_response_id%TYPE default null
    ) return acs_objects.object_id%TYPE;

    function initial_response_id (
	response_id in survey_responses.response_id%TYPE
    ) return survey_responses.response_id%TYPE;

    function initial_user_id (
	response_id in survey_responses.response_id%TYPE
    ) return acs_objects.creation_user%TYPE;

    procedure remove (
        response_id in survey_responses.response_id%TYPE
    );

    procedure del (
        response_id in survey_responses.response_id%TYPE
    );

    function boolean_answer (
        answer varchar,
	question_id survey_questions.question_id%TYPE
    ) return varchar;

end survey_response;
/
show errors


-- next we define the package bodies

create or replace package body survey
as
    function new (
        survey_id in surveys.survey_id%TYPE default null,
        name in surveys.name%TYPE,
        description in surveys.description%TYPE,
        description_html_p in surveys.description_html_p%TYPE default 'f',
        single_response_p in surveys.single_response_p%TYPE default 'f',
        editable_p in surveys.editable_p%TYPE default 't',
        enabled_p in surveys.enabled_p%TYPE default 'f',
	single_section_p in surveys.single_section_p%TYPE default 't',
        type in surveys.type%TYPE default 'general',
        display_type in surveys.display_type%TYPE default 'list',
        package_id in surveys.package_id%TYPE,
        object_type in acs_objects.object_type%TYPE default 'survey',
        creation_date in acs_objects.creation_date%TYPE default sysdate,
        creation_user in acs_objects.creation_user%TYPE default null,
        creation_ip in acs_objects.creation_ip%TYPE default null,
        context_id in acs_objects.context_id%TYPE default null
    ) return acs_objects.object_id%TYPE
    is
        v_survey_id surveys.survey_id%TYPE;
    begin
        v_survey_id := acs_object.new (
            object_id => survey_id,
            object_type => object_type,
            creation_date => creation_date,
            creation_user => creation_user,
            creation_ip => creation_ip,
            context_id => context_id
        );
        insert into surveys
            (survey_id, name, description, description_html_p,
            single_response_p, editable_p, enabled_p, single_section_p, type, display_type, package_id)
            values
            (v_survey_id, new.name, new.description, new.description_html_p,
            new.single_response_p, new.editable_p, new.enabled_p, new.single_section_p, new.type, new.display_type, new.package_id);

        return v_survey_id;
    end new;

    procedure remove (
        survey_id surveys.survey_id%TYPE
    )
    is
	v_response_row survey_responses%ROWTYPE;
	v_section_row survey_sections%ROWTYPE;
    begin

	for v_response_row in (select response_id
		from survey_responses
		where survey_id=remove.survey_id
		and initial_response_id is NULL) loop
		survey_response.remove(v_response_row.response_id);
	end loop;

	for v_section_row in (select section_id
		from survey_sections
		where survey_id=remove.survey_id) loop
	survey_section.remove(v_section_row.section_id);
	end loop;
	
	delete from surveys where survey_id=remove.survey_id;
	acs_object.del(survey_id);
    end remove;

    function name (
        survey_id in surveys.survey_id%TYPE
     ) return varchar
     is
         v_name surveys.name%TYPE;
     begin
        select name
        into v_name
        from surveys
        where survey_id = name.survey_id;

        return v_name;
    end name;
end survey;
/
show errors


create or replace package body survey_section
as
    function new (
	section_id in survey_sections.section_id%TYPE default null,
	survey_id in survey_sections.survey_id%TYPE default null,
	name in survey_sections.name%TYPE default null,
 	description in survey_sections.description%TYPE default null,
	description_html_p in survey_sections.description_html_p%TYPE default null,
        object_type in acs_objects.object_type%TYPE default 'survey_section',
        creation_date in acs_objects.creation_date%TYPE default sysdate,
        creation_user in acs_objects.creation_user%TYPE default null,
        creation_ip in acs_objects.creation_ip%TYPE default null,
        context_id in acs_objects.context_id%TYPE default null

    )  return acs_objects.object_id%TYPE
    is
        v_section_id survey_sections.section_id%TYPE;
    begin
        v_section_id := acs_object.new (
            object_id => section_id,
            object_type => object_type,
            creation_date => creation_date,
            creation_user => creation_user,
            creation_ip => creation_ip,
            context_id => context_id
        );
        insert into survey_sections
            (section_id, survey_id, name, description, description_html_p)
            values
            (v_section_id, new.survey_id, new.name, new.description, new.description_html_p);

        return v_section_id;
    end new;

    procedure remove (
	section_id in survey_sections.section_id%TYPE
    ) is
	v_question_row survey_questions%ROWTYPE;
    begin
	for v_question_row in (select question_id
		from survey_questions
		where section_id=remove.section_id) loop
		survey_question.remove(v_question_row.question_id);
	end loop;
	delete from survey_sections where section_id=remove.section_id;
	acs_object.del(remove.section_id);
    end remove;
end survey_section;
/
show errors


create or replace package body survey_question
as
    function new (
        question_id in survey_questions.question_id%TYPE default null,
        section_id in survey_questions.section_id%TYPE default null,
        sort_order in survey_questions.sort_order%TYPE default null,
        question_text in survey_questions.question_text%TYPE default null,
        abstract_data_type in survey_questions.abstract_data_type%TYPE default null,
        required_p in survey_questions.required_p%TYPE default 't',
        active_p in survey_questions.active_p%TYPE default 't',
        presentation_type in survey_questions.presentation_type%TYPE default null,
        presentation_options in survey_questions.presentation_options%TYPE default null,
        presentation_alignment in survey_questions.presentation_alignment%TYPE default 'below',
        object_type in acs_objects.object_type%TYPE default 'survey_question',
        creation_date in acs_objects.creation_date%TYPE default sysdate,
        creation_user in acs_objects.creation_user%TYPE default null,
        creation_ip in acs_objects.creation_ip%TYPE default null,
        context_id in acs_objects.context_id%TYPE default null
    ) return acs_objects.object_id%TYPE
    is
        v_question_id survey_questions.question_id%TYPE;
    begin
        v_question_id := acs_object.new (
            object_id => question_id,
            object_type => object_type,
            creation_date => creation_date,
            creation_user => creation_user,
            creation_ip => creation_ip,
            context_id => section_id
        );
        insert into survey_questions
            (question_id, section_id, sort_order, question_text, abstract_data_type,
            required_p, active_p, presentation_type, presentation_options,
            presentation_alignment)
            values
            (v_question_id, new.section_id, new.sort_order, new.question_text, new.abstract_data_type,
            new.required_p, new.active_p, new.presentation_type, new.presentation_options,
            new.presentation_alignment);
        return v_question_id;
    end new;

    procedure remove (
        question_id in survey_questions.question_id%TYPE
    )
    is
    begin
	
	delete from survey_question_responses
	where question_id=remove.question_id;
	delete from survey_question_choices
	where question_id=remove.question_id;
	delete from survey_questions
            where question_id = remove.question_id;
        acs_object.del(remove.question_id);
    end remove;
end survey_question;
/
show errors


create or replace package body survey_response
as
    function new (
        response_id in survey_responses.response_id %TYPE default null,
        survey_id in survey_responses.survey_id%TYPE default null,
        title in survey_responses.title%TYPE default null,
        notify_on_comment_p in survey_responses.notify_on_comment_p%TYPE default 'f',
        object_type in acs_objects.object_type%TYPE default 'survey_response',
        creation_date in acs_objects.creation_date%TYPE default sysdate,
        creation_user in acs_objects.creation_user%TYPE default null,
        creation_ip in acs_objects.creation_ip%TYPE default null,
        context_id in acs_objects.context_id%TYPE default null,
	initial_response_id in survey_responses.initial_response_id%TYPE default null
    ) return acs_objects.object_id%TYPE
    is
        v_response_id survey_responses.response_id%TYPE;
    begin
        v_response_id := acs_object.new (
            object_id => response_id,
            object_type => object_type,
            creation_date => creation_date,
            creation_user => creation_user,
            creation_ip => creation_ip,
            context_id => context_id
        );
        insert into survey_responses (response_id, survey_id, title, notify_on_comment_p, initial_response_id)
            values
            (v_response_id, new.survey_id, new.title, new.notify_on_comment_p, new.initial_response_id);
        return v_response_id;
    end new;

    function initial_response_id (
	response_id in survey_responses.response_id%TYPE
    ) return survey_responses.response_id%TYPE
    is
        v_initial_response_id survey_responses.response_id%TYPE;
    begin
        select initial_response_id into v_initial_response_id
                  from survey_responses where
                  response_id = initial_response_id.response_id;
        if v_initial_response_id is NULL then
             v_initial_response_id := initial_response_id.response_id;
        end if;
	return v_initial_response_id;
    end initial_response_id;

    function initial_user_id (
	response_id in survey_responses.response_id%TYPE
    ) return acs_objects.creation_user%TYPE
    is
        v_user_id acs_objects.creation_user%TYPE;
    begin
	select o.creation_user into v_user_id
	from acs_objects o,
             survey_responses s
	where o.object_id = nvl(s.initial_response_id, s.response_id)
	and s.response_id=initial_user_id.response_id;
	return v_user_id;
    end initial_user_id;

    procedure remove (
        response_id in survey_responses.response_id%TYPE
    ) is
	v_response_row survey_responses%ROWTYPE;
    begin
	for v_response_row in (select response_id from survey_responses
		where initial_response_id=remove.response_id) loop
		survey_response.del(v_response_row.response_id);
	end loop;

	survey_response.del(remove.response_id);
    end remove;

    procedure del (
        response_id in survey_responses.response_id%TYPE
    )
    is
	v_question_response_row survey_question_responses%ROWTYPE;
    begin
	for v_question_response_row in (
		select item_id
	from survey_question_responses, cr_revisions
	where response_id=del.response_id
	and attachment_answer=revision_id)
	loop
		content_item.del(v_question_response_row.item_id);
	end loop;
	
	delete from survey_question_responses
	where response_id=del.response_id;
	delete from survey_responses
		where response_id=del.response_id;
	acs_object.del(del.response_id);
    end del;

    function boolean_answer (
        answer varchar,
	question_id survey_questions.question_id%TYPE
    ) return varchar
    is
	v_answer varchar(100);
	v_presentation_options survey_questions.presentation_options%TYPE;
	v_split_pos integer;
    begin
    
    if answer is NOT NULL then
        select presentation_options into v_presentation_options
	from survey_questions where question_id=boolean_answer.question_id;
	
	v_split_pos:= instr(v_presentation_options, '/');
	
	if answer = 't' then
	    v_answer:=substr(v_presentation_options, 1, v_split_pos -1 );
	end if;   
	if answer = 'f' then
	    v_answer:=substr(v_presentation_options, v_split_pos + 1 );
	end if;
	
    else
        v_answer := '';
    end if;
    return v_answer;
    end boolean_answer;

end survey_response;
/
show errors


-- these views depend on functions in this file -DaveB
-- this view contains only the most recently edited version
-- of each survey response.


create or replace view survey_responses_latest as
select sr.*, o.creation_date,
       o.creation_user,
        survey_response.initial_user_id(sr.response_id) as initial_user_id
  from survey_responses sr,
  acs_objects o,
  (select max(response_id) as response_id
          from survey_responses
         group by nvl(initial_response_id, response_id)) latest
  where nvl(sr.initial_response_id,sr.response_id) = o.object_id
  and sr.response_id= latest.response_id;

create or replace view survey_ques_responses_latest as
select qr.*
  from survey_question_responses qr, survey_responses_latest r
 where qr.response_id=r.response_id;  
