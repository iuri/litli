<master src="/www/blank-master">
<if @doc@ defined><property name="&doc">doc</property></if>
<if @body@ defined><property name="&body">body</property></if>
<if @head@ not nil><property name="head">@head;noquote@</property></if>
<if @focus@ not nil><property name="focus">@focus;noquote@</property></if>

<if @signatory@ defined>
    <property name="signatory">@signatory;noquote@</property>
</if>
<if @focus@ defined>
    <property name="focus">@focus;literal@</property>
</if>

<div class="container-fluid">
    <!-- START HEADER -->
    <div class="row header">     
        <widget src="header-bar" ds="0" subsite_logo="@subsite_logo;noquote@">
        <widget src="search" ds="0">
        <if @context_bar@ defined and @context_bar@ ne ""> <div class="col-xs-12 context"> @context_bar;noquote@ </div> </if>
    </div>
    <!-- END HEADER -->
    
    <div class="dotlrn-navigation">
        <div class="block-marker">#dotlrn-bootstrap3-theme.begin_dotlrn_navigation#</div>
        <if @dotlrn_navbar@ not nil>@dotlrn_navbar;noquote@</if> 
        
        <if @dotlrn_subnavbar@ not nil>
            <div class="dotlrn-sub-navigation">
                <div class="block-marker">#dotlrn-bootstrap3-theme.begin_dotlrn_sub_navigation#</div>
                @dotlrn_subnavbar;noquote@
            </div>
        </if>
    </div>
  
    <if @user_messages:rowcount@ gt 0>
        <div id="alert-message">
            <multiple name="user_messages">
                <div class="alert">
                    <strong>@user_messages.message;noquote@</strong>
                </div>
            </multiple>
        </div>
    </if>
    
    <div class="block-marker">Begin main content</div>
    <div class="main-content" style="margin-bottom:100px;">
        <slave>
    </div>

    <!-- START FOOTER -->
    <div class="navbar navbar-default navbar-fixed-bottom" style="border-color:#ccc;">
        <div class="footer" style='margin-top:0;font-size:90%;color:#666;padding-top:5px;'>
            <p style="margin:0;">
              This website is maintained by the OpenACS Community. Any problems, email <a href="mailto:@signatory@">webmaster</a> or <a href="/bugtracker/openacs.org/">Submit</a> a bug report.
<br>
              (Powered by Tcl<a href="http://www.tcl.tk/"><img alt="Tcl Logo" src="/resources/openacs-bootstrap3-theme/images/plume.png" width="14" height="18"></a>, 
                Next Scripting <a href="https://next-scripting.org/"><img alt="NSF Logo" src="/resources/openacs-bootstrap3-theme/images/next-icon.png" width="14" height="8"></a>, 
                NaviServer <%= [ns_info patchlevel] %> <a href="http://sourceforge.net/projects/naviserver/"><img src="/resources/openacs-bootstrap3-theme/images/ns-icon-16.png" alt="NaviServer Logo" width="12" height="12"></a>,
                <%= [expr {[string match *.* [ns_conn peeraddr]] ? "IPv4" : "IPv6"}] %>
            </p>
        </div>
    </div>
    <!-- END FOOTER -->

</div>
