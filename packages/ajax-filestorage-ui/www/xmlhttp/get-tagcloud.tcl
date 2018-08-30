ad_page_contract {

    Generate a tagcloud

    @author Hamilton Chua (ham@solutiongrove.com)
    @creation-date 2007-07-15

} {
    package_id:integer
}

# create a tagcloud from a given category_tree
set locale "en_US"

# use the same tree_id as the bookmarks
# set tree_id [connections::category_tree_id]
set tree_id [parameter::get -parameter "CategoryTreeId"]

set node_id [site_node::get_node_id_from_object_id -object_id $package_id]

# determine if we are in an extranet or a dotfolio
set ancestor_subsite_id [site_node::closest_ancestor_package \
                 -node_id $node_id \
                 -package_key acs-subsite \
                 -include_self]

if { ![exists_and_not_null user_id] } {
  set user_id [ad_conn user_id]
}

set limit_clause "and m.object_id in (select object_id from acs_objects where package_id = $package_id)"

db_multirow -extend { url } connections connections [subst {
select c.category_id, t.name, count(*) as count, o.creation_user
from categories c, category_translations t, category_object_map m, acs_objects o
where c.category_id = t.category_id
and c.tree_id = :tree_id
and t.locale = :locale
and c.category_id = m.category_id
and c.category_id = o.object_id
$limit_clause
group by t.name, o.creation_date, o.creation_user, c.category_id
order by t.name}] { 
    set url "javascript:void(0)"
}
