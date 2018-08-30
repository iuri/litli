ad_library {
    Automated tests.

    @author Joel Aufrecht
    @creation-date 2 Nov 2003
    @cvs-id $Id: acs-messaging-procs.tcl,v 1.4.22.1 2015/09/10 08:21:32 gustafn Exp $
}

aa_register_case acs_messaging_format_as_html {
    Test acs_messaging_format_as_html proc.
} {    

    aa_run_with_teardown \
        -rollback \
        -test_code {
            # initialize random values
            set name [ad_generate_random_string]

            set formatted_name [acs_messaging_format_as_html text/html $name]
            aa_true "Name is formatted" ![string match "<pre>$name<pre>" $formatted_name]
        }
}

aa_register_case acs_messaging_message_p {
    Test message_p proc.
} {    

    aa_run_with_teardown \
        -rollback \
        -test_code {

            set message_p [acs_message_p "0"]
            aa_true "Integer is not a message_id" !$message_p

        }
}

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
