<!--
     Display a list of available rooms.

     @author David Dao (ddao@arsidigta.com)
     @creation-date November 13, 2000
     @cvs-id $Id: index.adp,v 1.10 2008/11/09 23:29:23 donb Exp $
-->
<master>
<property name="&doc">doc</property>

<if @warning@ not nil>
<div style="border: 1px solid red; padding: 5px; margin: 10px;">
    @warning;noquote@
</div>
</if>

<listtemplate name="rooms"></listtemplate>
