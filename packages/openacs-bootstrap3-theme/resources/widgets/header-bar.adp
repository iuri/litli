<nav class="navbar navbar-default main-nav">
    <div class="container-fluid">
        <div class="navbar-header">
            <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1" aria-expanded="false">
                <span class="sr-only">Toggle navigation</span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
            </button>
            <a class="navbar-brand" href="/" style="padding:3px;">
                <if @subsite_logo@ defined>
                    <img src="@subsite_logo@" alt="Home">
                </if>
                <else>
                    <img src="/resources/openacs-bootstrap3-theme/images/openacs2_xs.png" alt="Home">
                </else>
            </a>
        </div>

        <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
            <div class="block-marker">Begin main navigation</div>
            <ul class="nav navbar-nav navbar-right">
                <comment> Tabbed Master Navigation </comment>
                <if @navigation:rowcount@ defined>
                    <widget src="navigation" &navigation="navigation" ds="0" >
                </if>
                <widget src="login" ds="0" >
            </ul>
        </div><!-- /.navbar-collapse -->
    </div>
</nav>
