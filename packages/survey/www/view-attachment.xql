<?xml version="1.0"?>
<queryset>

<fullquery name="get_file_info">      
      <querytext>
	select r.revision_id, r.mime_type as file_type
	from cr_revisions r
	where revision_id=(
		select attachment_answer from survey_question_responses
		where question_id=:question_id
                and   response_id=:response_id
			  )
      </querytext>
</fullquery>

 
</queryset>
