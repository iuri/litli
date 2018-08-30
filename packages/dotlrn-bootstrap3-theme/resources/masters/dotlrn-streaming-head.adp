<master src="/www/blank-master">
<if @doc@ defined><property name="&doc">doc</property></if>
<if @streaming_head@ defined><property name="streaming_head">@streaming_head;noquote@</property></if>

<div class="container-fluid">
    <!-- START HEADER -->
    <div class="row header">     
        <widget src="header-bar" ds="0" subsite_logo="@subsite_logo;noquote@">
        <widget src="search" ds="0">
        <if @context_bar@ defined and @context_bar@ ne ""> <div class="col-xs-12 context"> @context_bar;noquote@ </div> </if>
    </div>
    <!-- END HEADER -->

</div>
