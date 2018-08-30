
drop index dotlrn_terms_pk;

create table new_dotlrn_terms (
    term_id                     integer
                                constraint dotlrn_terms_pk
                                primary key,
    term_name                   varchar(20)
                                constraint dotlrn_t_term_name_nn
                                not null,
    term_year                   varchar(9)
                                constraint dotlrn_t_term_year_nn
                                not null,
    start_date                  date
                                default now()
                                constraint dotlrn_t_start_date_nn
                                not null,
    end_date                    date
                                default (now() + '180 days'::interval)
                                constraint dotlrn_t_end_date_nn
                                not null
);

insert into new_dotlrn_terms select * from dotlrn_terms;
alter table dotlrn_terms rename to old_dotlrn_terms;
alter table new_dotlrn_terms rename to dotlrn_terms;
drop table old_dotlrn_terms;
