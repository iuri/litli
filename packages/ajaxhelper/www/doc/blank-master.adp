@doc.type;noquote@
<html<if @doc.lang@ not nil> lang="@doc.lang;noquote@"</if>>
<head>
    <title<if @doc.title_lang@ not nil and @doc.title_lang@ ne @doc.lang@> lang="@doc.title_lang;noquote@"</if>>@doc.title;noquote@</title>

<multiple name="meta">    <meta<if @meta.http_equiv@ not nil> http-equiv="@meta.http_equiv;noquote@"</if><if @meta.name@ not nil> name="@meta.name;noquote@"</if><if @meta.scheme@ not nil> scheme="@meta.scheme;noquote@"</if><if @meta.lang@ not nil and @meta.lang@ ne @doc.lang@> lang="@meta.lang;noquote@"</if> content="@meta.content@">
</multiple>
<multiple name="link">    <link rel="@link.rel;noquote@" href="@link.href;noquote@"<if @link.lang@ not nil and @link.lang@ ne @doc.lang@> lang="@link.lang;noquote@"</if><if @link.title@ not nil> title="@link.title;noquote@"</if><if @link.type@ not nil> type="@link.type;noquote@"</if><if @link.media@ not nil> media="@link.media@"</if>>
</multiple>
<multiple name="headscript">   <script type="@headscript.type;noquote@"<if @headscript.src@ not nil> src="@headscript.src;noquote@"</if><if @headscript.charset@ not nil> charset="@headscript.charset;noquote@"</if><if @headscript.defer@ not nil> defer="@headscript.defer;noquote@"</if>><if @headscript.content@ not nil>@headscript.content;noquote@</if></script>
</multiple>

<if @head@ not nil>@head;noquote@</if>
<include src="/packages/ajaxhelper/lib/ajaxhelper-template">
</head>
<body<if @body.class@ not nil> class="@body.class;noquote@"</if><if @body.id@ not nil> id="@body.id;noquote@"</if><if @event_handlers@ not nil>@event_handlers;noquote@</if>>
<list name="header">
  @header:item;noquote@
</list>
<slave>
<list name="footer">
  @footer:item;noquote@
</list>
<multiple name="body_script">    <script type="@body_script.type;noquote@"<if @body_script.src@ not nil> src="@body_script.src;noquote@"</if><if @body_script.charset@ not nil> charset="@body_script.charset;noquote@"</if><if @body_script.defer@ not nil> defer="@body_script.defer;noquote@"</if>><if @body_script.content@ not nil>@body_script.content;noquote@</if></script>
</multiple>
</body>
</html>
