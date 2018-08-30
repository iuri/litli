# expects connections multirow
#
# Creates a customizable lists of connections
# add code here to customize the multirow

set connections_url ""

template::multirow extend connections callout fontsize

template::multirow foreach connections {
    set fontsize [expr 12+$count]
}