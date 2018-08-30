<master src="@dotlrn_master@">
  <if @doc_type@ not nil><property name="doc_type">@doc_type;literal@</property></if>
  <if @title@ not nil><property name="doc(title)">@title;literal@</property></if>

  <if @doc@ defined><property name="&doc">doc</property></if>

  <if @context@ not nil><property name="context">@context;literal@</property></if>
  <if @context_bar@ not nil><property name="context_bar">@context_bar;literal@</property></if>
  <if @focus@ not nil><property name="focus">@focus;literal@</property></if>
  <if @link_control_panel@ not nil><property name="link_control_panel">@link_control_panel;literal@</property></if>
  <if @hide_feedback@ not nil><property name="hide_feedback">@hide_feedback;literal@</property></if>
  <if @portal_page_p@ not nil><property name="portal_page_p">@portal_page_p;literal@</property></if>

  <slave>
