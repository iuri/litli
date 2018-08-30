<div class="portlet-wrapper">
  <div class="portlet-header">
    <div class="portlet-title">
      <h1>@name;noquote@</h1>
    </div>
    <if @shadeable_p;literal@ true>     
      <div class="portlet-controls">
        <a href="@configure_element_url@">
          <if @shaded_p;literal@ true>
            <img src="/resources/theme-zen/images/portlets/max.gif" alt="#theme-zen.maximize_portlet#"  width="19" height="16">
          </if>
          <else>
            <img src="/resources/theme-zen/images/portlets/min.gif" alt="#theme-zen.minimize_portlet#" width="19" height="16">
          </else>
        </a>
      </div>
    </if>
  </div>
  <div class="portlet">
    <slave>
  </div> <!-- /portlet -->
</div> <!-- /portlet-wrapper -->
