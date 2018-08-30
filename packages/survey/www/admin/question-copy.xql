<?xml version="1.0"?>

<queryset>
<fullquery name="get_section_id_from_question">
<querytext>
select section_id from survey_questions
    where question_id=:question_id
</querytext>
</fullquery>
</queryset>