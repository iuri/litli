<if @edit_p;literal@ true>
<p><a class="button" href="@edit_url@">#chat.Edit#</a></p>
</if>

<table border="0" cellpadding="2" cellspacing="2">
    <tr class="form-element">
        <td class="form-label">#chat.Transcript_name#</td>
        <td>@transcript_name@</td>
    </tr>
    <tr class="form-element">
        <td class="form-label">#chat.Description#</td>
        <td>@description@</td>
    </tr>
</table>
     
<div id="messages">@contents;noquote@</div>
