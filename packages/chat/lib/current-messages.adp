<div id="messages">
<if @messages:rowcount@ gt 0>
<multiple name="messages">
    <p class="line">
        <span class="timestamp">@messages.creation_date@</span>
        <span class="user"> @messages.person_name@: </span> 
        <span class="message"> @messages.msg@ </span>
    </p>
</multiple>
</if>
<else>
    <p class="line">#chat.No_information_available#</p>
</else>
</div>