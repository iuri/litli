<master src="/www/site-compat">
  <if @context@ not nil><property name="context">@context;literal@</property></if>
    <else><if @context_bar@ not nil><property name="context_bar">@context_bar;literal@</property></if></else>
  <if @focus@ not nil><property name="focus">@focus;literal@</property></if>
  <if @doc_type@ not nil><property name="doc_type">@doc_type;literal@</property></if>
  <if @title@ not nil><property name="doc(title)">@title;literal@</property></if>

<div id="pre-page-body">
</div>

<div id="page-body">

  <if @title@ not nil>
    <h1 class="page-title">@title;noquote@</h1>
  </if>

  <div id="pre-navbar" class="header" style="clear: both;"></div>
  <if @navbar@ not nil><div id="navbarx">@navbar;noquote@</div></if>
  <div style="clear: both;"></div>

  <div id="main-container">

  <slave>

  <div style="clear: both;"></div>
  </div><!-- main-container -->

</div><!-- page-body -->

<div class="footer">
  <a href="http://www.dotlrn.org">.LRN Home</a> |
  <a href="http://www.openacs.org/projects/dotlrn">.LRN Project Central</a>
</div>
