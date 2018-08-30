<div class="searchfield"> 
    <div class="col-xs-12 col-sm-6 col-md-3 col-sm-offset-6 col-md-offset-9 search"> 
        <form method="GET" action="/search/search" class="form-inline">       
            <div class="input-group">
                <input type="text" class="form-control" name="q" title="#search.Enter_keywords_to_search_for#" maxlength="256" placeholder="Search">              
                <if @::__csrf_token@ defined><input type="hidden" name="__csrf_token" value="@::__csrf_token;literal@"></if>
                <span class="input-group-btn">
                    <button type="submit" class="btn btn-default">Go!</button>
                </span> 
            </div>
        </form>  
    </div>
</div>

