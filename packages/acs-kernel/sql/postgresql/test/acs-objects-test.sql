--
-- acs-kernel/sql/acs-objects-test.sql
--
-- PL/SQL regression tests for the acs-objects system
--
-- Note: These tests use the utPLSQL regression package available at:
-- ftp://ftp.oreilly.com/published/oreilly/oracle/utplsql/utplsql.zip
--
-- @author Richard Li (richardl@arsdigita.com)
--
-- @creation-date 19 September 2000
--
-- @cvs-id $Id: acs-objects-test.sql,v 1.3 2011/07/07 10:46:02 gustafn Exp $

-- In order for utPLSQL to work, you need to grant 
-- specific permissions to your user:
--
-- grant create public synonym to servicename;
-- grant drop public synonym to servicename;
-- grant execute on dbms_pipe to servicename;
-- grant drop any table to servicename;
-- grant create any table to servicename;

-- In order to execute the test, you need to set things up
-- in your SQL*PLUS session. First type:
-- 
--     set serveroutput on size 1000000 format wrapped
--
-- Now, if you have the UTL_FILE PL/SQL package installed, type:
--
--     exec utplsql.setdir('/web/richard/packages/acs-kernel/sql');
--
-- Otherwise, you'll have to disable autocompilation and manually
-- compile:
--
--     exec utplsql.autocompile (false);
--     @acs-objects-test
--
-- To actually execute the test, type:
--
--     exec utplsql.test('acs_object');


-- we need these here or else the PL/SQL won't compile.
-- drop table ut_acs_objects;
-- create table ut_acs_objects as select * from acs_objects;
-- create table test_objects (test_id integer primary key, data varchar2(100));

-- create or replace package ut#acs_object
-- as

--     procedure setup;

--     procedure teardown;

--     procedure new;

--     procedure delete;

--     procedure name;

--     procedure default_name;

--     procedure set_attribute;

--     procedure get_attribute;

-- end ut#acs_object;
-- /
-- show errors

-- create or replace package body ut#acs_object
-- as



--
-- procedure ut_acs_object__setup/0
--
CREATE OR REPLACE FUNCTION ut_acs_object__setup(

) RETURNS integer AS $$
DECLARE
        attr_id acs_attributes.attribute_id%TYPE;
BEGIN
        raise NOTICE 'Setting up...';

        -- create the test_object type
        PERFORM acs_object_type__create_type (
     	    'test_object',
	    'Test Object',
	    'Test Objects',
	    'acs_object',
            'test_objects',
	    'test_id',
            null,
            'f',
            null,
            null            
	);

	-- no API available for this yet
	insert into acs_object_type_tables 
               (object_type, table_name, id_column)
               values 
               ('test_object','test_objects','test_id');

	-- create the attribute
	attr_id := acs_attribute__create_attribute (
	    'test_object',
	    'data',
	    'string',
	    'Data',
	    'Mo Data',
            'test_objects',
	    'data',
            null,
            0,
            1,
            null,
            'type_specific',
            'f'
	);

        return null;

END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION ut_acs_object__teardown() RETURNS integer AS $$
BEGIN
        raise NOTICE 'Tearing down...';

	-- delete the test object
	delete from acs_attributes where object_type = 'test_object';
	delete from acs_object_type_tables where object_type = 'test_object';
	delete from acs_objects where object_type = 'test_object';

    	drop table test_objects;

 	-- clean out the test data
  	drop table ut_acs_objects;

	-- delete the object_type
	delete from acs_object_types where object_type = 'test_object';

        return null;

END;
$$ LANGUAGE plpgsql;



--
-- procedure ut_acs_object__new/0
--
CREATE OR REPLACE FUNCTION ut_acs_object__new(

) RETURNS integer AS $$
DECLARE
        result  boolean;
BEGIN
        raise NOTICE 'Testing new...';

        -- Tests just the common functionality of the API.

        if acs_object__new(-1000, 'test_object') <> -1000 then
           raise NOTICE 'Creating a new test object failed';
        end if;

	-- create a new object to delete; note that this test assumes that
	-- the .new operator works.

        if acs_object__new(-1001, 'test_object') <> -1001 then
           raise NOTICE 'Creating a new test object failed';
        end if;

        if acs_object__new(-1003, 'test_object') <> -1003 then
           raise NOTICE 'Creating a new test object failed';
        end if;

	-- create an object

	insert into ut_acs_objects
                                (object_id, object_type, creation_date, 
                                 security_inherit_p, last_modified)
                                values
                                (-1000, 'test_object', now(), 't', now());
	
	-- Verify that the API does the correct insert.

        select 't' into result 
          from ut_acs_objects uo, acs_objects o  
         where uo.object_id = o.object_id 
           and uo.object_id = -1000;

        if NOT FOUND then 
           raise NOTICE 'Comparing created data for object failed';
        end if;

        return null;
	
END;
$$ LANGUAGE plpgsql;



--
-- procedure ut_acs_object__delete/0
--
CREATE OR REPLACE FUNCTION ut_acs_object__delete(

) RETURNS integer AS $$
DECLARE
        v_rec   record;
BEGIN
        raise NOTICE 'Testing delete...';

	-- delete the row.
	PERFORM acs_object__delete(-1001);

 	-- verify object not there.

        select * into v_rec 
          from acs_objects where object_id = -1001;

        if FOUND then 
           raise NOTICE 'Delete verification failed';
        end if;

        return null;

END;
$$ LANGUAGE plpgsql; 

CREATE OR REPLACE FUNCTION ut_acs_object__name() RETURNS integer AS $$
BEGIN
	raise NOTICE 'Testing name...';

        if acs_object__name(-1001) <> 'Test Object -1000' then
           raise NOTICE 'Creating a name failed';
        end if;

        return null;

END;
$$ LANGUAGE plpgsql; 

CREATE OR REPLACE FUNCTION ut_acs_object__default_name() RETURNS integer AS $$
BEGIN
	raise NOTICE 'Testing default_name...';

        if acs_object__default_name(-1001) <> 'Test Object -1000' then
           raise NOTICE 'Creating a default name failed';
        end if;

        return null;

END;
$$ LANGUAGE plpgsql; 



--
-- procedure ut_acs_object__set_attribute/0
--
CREATE OR REPLACE FUNCTION ut_acs_object__set_attribute(

) RETURNS integer AS $$
DECLARE
        v_sql_result test_objects.data%TYPE;
BEGIN
        raise NOTICE 'Testing set_attribute';

	-- since we did not create a test object new constructor
	-- were going to insert into attributes here.
	insert into test_objects(test_id) values(-1003);

	PERFORM acs_object__set_attribute(-1003, 'data', '2702');

	-- since utassert is not powerful enough right now, we do this
	-- comparison manually
	select data into v_sql_result 
          from test_objects 
         where test_id = -1003;

	if v_sql_result = 2702 then
	    raise NOTICE 'SUCCESS: set_attribute';
        else
            raise NOTICE 'Verifying attribute data FAILED';
        end if;

	return null;

END;
$$ LANGUAGE plpgsql;



--
-- procedure ut_acs_object__get_attribute/0
--
CREATE OR REPLACE FUNCTION ut_acs_object__get_attribute(

) RETURNS integer AS $$
DECLARE
        v_attr_value varchar(4000);
BEGIN
        raise NOTICE 'Testing get_attribute';

	-- we assume that set attribute works. since im lazy
	-- im going to recycle the -1003 object.

	PERFORM acs_object__set_attribute(-1003, 'data', 'sugarwen');

	v_attr_value := acs_object__get_attribute(-1003, 'data');

	if v_attr_value = 'sugarwen' then
    	    raise NOTICE 'SUCCESS: get_attribute';
        else
            raise NOTICE 'Verifying get attribute data FAILED';
        end if;

	return null;

END;
$$ LANGUAGE plpgsql;

create table test_objects (
       test_id integer primary key, 
       data varchar(100)
);

select ut_acs_object__setup();

create table ut_acs_objects as
select * from acs_objects;

select ut_acs_object__new();
select ut_acs_object__delete();
select ut_acs_object__name();
select ut_acs_object__default_name();
select ut_acs_object__set_attribute();
select ut_acs_object__get_attribute();

select ut_acs_object__teardown();

drop function ut_acs_object__setup();
drop function ut_acs_object__teardown();
drop function ut_acs_object__new();
drop function ut_acs_object__delete();
drop function ut_acs_object__name();
drop function ut_acs_object__default_name();
drop function ut_acs_object__set_attribute();
drop function ut_acs_object__get_attribute();
