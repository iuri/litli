<%

    #
    #  Copyright (C) 2001, 2002 MIT
    #
    #  This file is part of dotLRN.
    #
    #  dotLRN is free software; you can redistribute it and/or modify it under the
    #  terms of the GNU General Public License as published by the Free Software
    #  Foundation; either version 2 of the License, or (at your option) any later
    #  version.
    #
    #  dotLRN is distributed in the hope that it will be useful, but WITHOUT ANY
    #  WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
    #  FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
    #  details.
    #

%>

<if @shaded_p;literal@ false>
      <if @faqs:rowcount@ eq 1>
       <a href="@faq_url@one-faq?faq_id=@faq_id@">@faq_name@</a>
       <ul>
        <multiple name="questions">
         <li><a href="@faq_url@one-question?entry_id=@questions.entry_id@">@questions.question;noquote@</a></li>
        </multiple>
       </ul>
      </if>
      <else>
       <listtemplate name="faqs"></listtemplate>
      </else>
</if>
<else>
    #new-portal.when_portlet_shaded#
</else>