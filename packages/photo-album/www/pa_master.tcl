set cmd [list ad_context_bar --]
foreach elem $context_list {
    lappend cmd $elem
}
set context_bar [eval $cmd]


