<if @results_paginator:rowcount@ gt 0>
  <div id="results-pages" class="@paginator_class@">
  <nav>
  <ul class="pagination">
      <if @url_previous_group@ nil>
        <li class="disabled"><a href="#" aria-label="Previous"><span aria-hidden="true">&laquo;</span></a></li>
      </if>
      <else>
        <li><a href="@url_previous_group@" title="Previous Group">&laquo;</a></li>
      </else>
      <if @url_previous@ nil>
        <li class="disabled"><a href="#" aria-label="Previous"><span aria-hidden="true">&lsaquo;</span></a></li>
      </if>
      <else>
        <li><a aria-label="Previous" href="@url_previous@" title="Previous"><span aria-hidden="true">&lsaquo;</span></a></li>
      </else>
      <multiple name="results_paginator">
        <if @results_paginator.current_p;literal@ true>
          <li class="active"><a href="#">@results_paginator.item@ <span class="sr-only">(current)</span></a></li>
        </if>
        <else>
          <li><a href="@results_paginator.link@" title="@results_paginator.item@">@results_paginator.item@</a></li>
        </else>
      </multiple>
      <if @url_next@ nil>
        <li class="disabled"><a href="#" aria-label="Next"><span aria-hidden="true">&rsaquo;</span></a></li>
      </if>
      <else>
        <li><a aria-label="Next" href="@url_next@" title="Next"><span aria-hidden="true">&rsaquo;</span></a></li>
      </else>
      <if @url_next_group@ nil>
        <li class="disabled"><a href="#" aria-label="Next"><span aria-hidden="true">&raquo;</span></a></li>
      </if>
      <else> 
        <li><a href="@url_next_group@" title="Next Group">&raquo;</a></li>
      </else>
    </ul>
  </nav>
  </div>
</if>

