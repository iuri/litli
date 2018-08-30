-- news upgrade script
-- @author Vinod Kurup (vinod@kurup.com)
-- @creation-date 2002-10-27

-- add procedure 'news.clone'
create or replace package news
as 
    function new (
        item_id                 in cr_items.item_id%TYPE 	  default null,
        --
        locale                  in cr_items.locale%TYPE 	  default null, 
        --
        publish_date            in cr_revisions.publish_date%TYPE default null,
        text                    in varchar2                       default null,
        nls_language            in cr_revisions.nls_language%TYPE default null,
        title                   in cr_revisions.title%TYPE 	  default null,
        mime_type               in cr_revisions.mime_type%TYPE    default 'text/plain',
        --
        package_id              in cr_news.package_id%TYPE 	  default null,        
        archive_date            in cr_news.archive_date%TYPE      default null,
        approval_user           in cr_news.approval_user%TYPE     default null,
        approval_date           in cr_news.approval_date%TYPE     default null,
        approval_ip             in cr_news.approval_ip%TYPE       default null,      
        --
        relation_tag            in cr_child_rels.relation_tag%TYPE 
                                                                  default null,
        --
        item_subtype            in acs_object_types.object_type%TYPE 
                                                                  default 'content_revision',
        content_type            in acs_object_types.object_type%TYPE 
                                                                  default 'news',
        creation_date           in acs_objects.creation_date%TYPE default sysdate,
        creation_ip             in acs_objects.creation_ip%TYPE   default null,
        creation_user           in acs_objects.creation_user%TYPE default null,
        --
        is_live_p               in varchar2                       default 'f' 
    ) return cr_news.news_id%TYPE;

    procedure delete (
        item_id in cr_items.item_id%TYPE
    );  

    procedure archive (
        item_id in cr_items.item_id%TYPE,
        archive_date in cr_news.archive_date%TYPE default sysdate       
    );  

    procedure make_permanent (
           item_id in cr_items.item_id%TYPE
    );

   
    procedure set_approve (
        revision_id      in cr_revisions.revision_id%TYPE,       
	approve_p        in varchar2 default 't',  
        publish_date     in cr_revisions.publish_date%TYPE  	default null,
        archive_date     in cr_news.archive_date%TYPE 		default null,
        approval_user    in cr_news.approval_user%TYPE 		default null,
        approval_date    in cr_news.approval_date%TYPE 		default sysdate,
        approval_ip      in cr_news.approval_ip%TYPE 		default null, 
        live_revision_p  in varchar2 default 't'
    );



    function status (
        news_id in cr_news.news_id%TYPE
    ) return varchar2;


    function name (
	news_id in cr_news.news_id%TYPE
    ) return varchar2;   


    --  
    -- API for revisions: e.g. when the news admin wants to revise a news item
    --
    function revision_new (
        item_id                 in cr_items.item_id%TYPE,       
        --
        publish_date            in cr_revisions.publish_date%TYPE    default null,
        text                    in varchar2                   default null,
        title                   in cr_revisions.title%TYPE,
        --
        -- here goes the revision log
        description             in cr_revisions.description%TYPE,
        --
        mime_type               in cr_revisions.mime_type%TYPE 	     default 'text/plain',
        package_id              in cr_news.package_id%TYPE 	     default null,        
        archive_date            in cr_news.archive_date%TYPE         default null,
        approval_user           in cr_news.approval_user%TYPE        default null,
        approval_date           in cr_news.approval_date%TYPE        default null,
        approval_ip             in cr_news.approval_ip%TYPE          default null,      
        --
        creation_date           in acs_objects.creation_date%TYPE    default sysdate,
        creation_ip             in acs_objects.creation_ip%TYPE      default null,           
        creation_user           in acs_objects.creation_user%TYPE    default null,
        --
        make_active_revision_p  in varchar2 default 'f'
    ) return cr_revisions.revision_id%TYPE;


    procedure revision_delete (
       revision_id in cr_revisions.revision_id%TYPE
    );


    procedure revision_set_active (
       revision_id in cr_revisions.revision_id%TYPE
    );

    procedure clone (
        new_package_id          in cr_news.package_id%TYPE 	  default null,
        old_package_id          in cr_news.package_id%TYPE 	  default null
    );

end news;
/
show errors



create or replace package body news
    as
    function new (
        item_id                 in cr_items.item_id%TYPE             default null,
        --
        locale                  in cr_items.locale%TYPE              default null, 
        --
        publish_date            in cr_revisions.publish_date%TYPE    default null,
        text                    in varchar2                          default null,
        nls_language            in cr_revisions.nls_language%TYPE    default null,
        title                   in cr_revisions.title%TYPE           default null,
        mime_type               in cr_revisions.mime_type%TYPE       default 
	                					     'text/plain',
        --
        package_id              in cr_news.package_id%TYPE           default null,      
        archive_date            in cr_news.archive_date%TYPE         default null,
        approval_user           in cr_news.approval_user%TYPE        default null,
        approval_date           in cr_news.approval_date%TYPE        default null,
        approval_ip             in cr_news.approval_ip%TYPE          default null,      
        --
        relation_tag            in cr_child_rels.relation_tag%TYPE   default null,
        --
        item_subtype            in acs_object_types.object_type%TYPE default 
                                                                     'content_revision',
        content_type            in acs_object_types.object_type%TYPE default 'news',
        creation_date           in acs_objects.creation_date%TYPE    default sysdate,
        creation_ip             in acs_objects.creation_ip%TYPE      default null,
        creation_user           in acs_objects.creation_user%TYPE    default null,
        --
        is_live_p               in varchar2                          default 'f'
    ) return cr_news.news_id%TYPE
    is
        v_news_id         integer;
        v_item_id         integer;
        v_id              integer;
        v_revision_id     integer;
        v_parent_id       integer;
        v_name            varchar2(200);
        v_log_string      varchar2(400);
    begin
        select content_item.get_id('news') 
        into   v_parent_id 
        from   dual;    
        --
        -- this will be used for 2xClick protection
        if item_id is null then
            select acs_object_id_seq.nextval 
            into   v_id 
            from   dual;
        else 
            v_id := item_id;
        end if; 
        --
        select 'news' || to_char(sysdate,'YYYYMMDD') || v_id 
        into   v_name 
        from   dual;    
        -- 
        v_log_string := 'initial submission'; 
        -- 
        v_item_id := content_item.new(
            item_id       => v_id,
            name          => v_name,
            parent_id     => v_parent_id,
            locale        => locale,
            item_subtype  => item_subtype,
            content_type  => content_type,
            mime_type     => mime_type,
            nls_language  => nls_language,
            relation_tag  => relation_tag,
            creation_date => creation_date,
            creation_ip   => creation_ip,
            creation_user => creation_user
        );
        v_revision_id := content_revision.new(
            title         => title,
            description   => v_log_string,
            publish_date  => publish_date,
            mime_type     => mime_type,
            nls_language  => nls_language,
            text          => text,
            item_id       => v_item_id,
            creation_date => creation_date,
            creation_ip   => creation_ip,
            creation_user => creation_user
        );
        insert into cr_news 
            (news_id, 
             package_id, 
             archive_date,
             approval_user, 
             approval_date, 
             approval_ip)
        values
            (v_revision_id, 
             package_id, 
             archive_date,
             approval_user, 
             approval_date, 
             approval_ip);
        -- make this revision live when immediately approved
        if is_live_p = 't' then
	    update 
                cr_items
            set
                live_revision = v_revision_id,
                publish_status = 'ready'
            where 
                item_id = v_item_id;
        end if;
        v_news_id := v_revision_id;
        return v_news_id;
    end new;


    -- deletes a news item along with all its revisions and possibnle attachements
    procedure delete (
        item_id in cr_items.item_id%TYPE
    ) is
    v_item_id   cr_items.item_id%TYPE;

    cursor comment_cursor IS
        select message_id 
        from   acs_messages am, acs_objects ao
	where  am.message_id = ao.object_id
        and    ao.context_id = v_item_id;

    begin
    v_item_id := news.delete.item_id;
	dbms_output.put_line('Deleting associated comments...');
	-- delete acs_messages, images, comments to news item
	for v_cm in  comment_cursor loop
	    -- images
	    delete from images
        	where image_id in (select latest_revision
                                   from cr_items 
                                   where parent_id = v_cm.message_id);
	    acs_message.delete(v_cm.message_id);
            delete from general_comments
		where comment_id = v_cm.message_id;	 
        end loop;
        delete from cr_news 
        where news_id in (select revision_id 
                          from   cr_revisions 
                          where  item_id = v_item_id);
        content_item.delete(v_item_id);
    end delete;


    -- (re)-publish a news item out of the archive by nulling the archive_date
    -- this only applies to the currently active revision
    procedure make_permanent (
        item_id in cr_items.item_id%TYPE
     )
    is
    begin
        update cr_news
        set    archive_date = null
        where  news_id = content_item.get_live_revision(news.make_permanent.item_id);
    end make_permanent;


    -- archive a news item
    -- this only applies to the currently active revision
    procedure archive (
        item_id in cr_items.item_id%TYPE,
        archive_date in cr_news.archive_date%TYPE default sysdate       
    )
    is
    begin
        update cr_news  
        set    archive_date = news.archive.archive_date
        where  news_id = content_item.get_live_revision(news.archive.item_id);
    end archive;

  
    -- approve/unapprove a specific revision
    -- approving a revision makes it also the active revision
    procedure set_approve(  
        revision_id      in cr_revisions.revision_id%TYPE,       
	approve_p        in varchar2 default 't',  
        publish_date     in cr_revisions.publish_date%TYPE default null,
        archive_date     in cr_news.archive_date%TYPE default null,
        approval_user    in cr_news.approval_user%TYPE default null,
        approval_date    in cr_news.approval_date%TYPE default sysdate,
        approval_ip      in cr_news.approval_ip%TYPE default null, 
        live_revision_p  in varchar2 default 't'
    )
    is
        v_item_id cr_items.item_id%TYPE;
    begin
        select item_id into v_item_id 
        from   cr_revisions 
        where  revision_id = news.set_approve.revision_id;
        -- unapprove an revision (does not mean to knock out active revision)
        if news.set_approve.approve_p = 'f' then
            update  cr_news 
            set     approval_date = null,
                    approval_user = null,
                    approval_ip   = null,
                    archive_date  = null
            where   news_id = news.set_approve.revision_id;
            --
            update  cr_revisions
            set     publish_date = null
            where   revision_id  = news.set_approve.revision_id;
        else
        -- approve a revision
            update  cr_revisions
            set     publish_date  = news.set_approve.publish_date
            where   revision_id   = news.set_approve.revision_id;
            --  
            update  cr_news 
            set archive_date  = news.set_approve.archive_date,
                approval_date = news.set_approve.approval_date,
                approval_user = news.set_approve.approval_user,
                approval_ip   = news.set_approve.approval_ip
            where news_id     = news.set_approve.revision_id;
            -- 
            -- cannot use content_item.set_live_revision because it sets publish_date to sysdate
            if news.set_approve.live_revision_p = 't' then
                update  cr_items
                set     live_revision = news.set_approve.revision_id,
                        publish_status = 'ready'
                where   item_id = v_item_id;
            end if;
            --
        end if;    
    end set_approve;



    -- the status function returns information on the puplish or archive status
    -- it does not make any checks on the order of publish_date and archive_date
    function status (
        news_id in cr_news.news_id%TYPE
    ) return varchar2
    is
        v_archive_date date;
        v_publish_date date;
    begin
        -- populate variables
        select archive_date into v_archive_date 
        from   cr_news 
        where  news_id = news.status.news_id;
        --
        select publish_date into v_publish_date
        from   cr_revisions
        where  revision_id = news.status.news_id;
        
        -- if publish_date is not null the item is approved, otherwise it is not
        if v_publish_date is not null then
            if v_publish_date > sysdate  then
                -- to be published (2 cases)
                -- archive date could be null if it has not been decided when to archive
                if v_archive_date is null then 
                    return 'going live in ' || 
                    round(to_char(v_publish_date - sysdate),1) || ' days';
                else 
                    return 'going live in ' || 
                    round(to_char(v_publish_date - sysdate),1) || ' days' ||
                    ', archived in ' || round(to_char(v_archive_date - sysdate),1) || ' days';
                end if;  
            else
                -- already released or even archived (3 cases)
                if v_archive_date is null then
                     return 'published, not scheduled for archive';
                else
                    if v_archive_date - sysdate > 0 then
                         return 'published, archived in ' || 
                         round(to_char(v_archive_date - sysdate),1) || ' days';
                    else 
                        return 'archived';
                    end if;
                 end if;
            end if;     
        else 
            return 'unapproved';
        end if;
    end status;


    function name (
	news_id in cr_news.news_id%TYPE
    ) return varchar2
    is
        news_title varchar2(1000);
    begin
        select title 
	into news_title
        from cr_revisions
        where revision_id = news.name.news_id;

        return news_title;
    end name;
    

    -- 
    -- API for Revision management
    -- 
    function revision_new (
        item_id                 in cr_items.item_id%TYPE,       
        --
        publish_date            in cr_revisions.publish_date%TYPE  	default null,
        text                    in varchar2                             default null,
        title                   in cr_revisions.title%TYPE,
        --
        -- here goes the revision log
        description             in cr_revisions.description%TYPE,
        --
        mime_type               in cr_revisions.mime_type%TYPE 		default 'text/plain',
        package_id              in cr_news.package_id%TYPE 		default null,        
        archive_date            in cr_news.archive_date%TYPE 		default null,
        approval_user           in cr_news.approval_user%TYPE 		default null,
        approval_date           in cr_news.approval_date%TYPE 		default null,
        approval_ip             in cr_news.approval_ip%TYPE   		default null,      
        --
        creation_date           in acs_objects.creation_date%TYPE 	default sysdate,
        creation_ip             in acs_objects.creation_ip%TYPE 	default null,           
        creation_user           in acs_objects.creation_user%TYPE 	default null,
        --
        make_active_revision_p  in varchar2 default 'f'
    ) return cr_revisions.revision_id%TYPE
    is  
        v_revision_id    integer;
    begin
        -- create revision
        v_revision_id := content_revision.new(
            title         => title,
            description   => description,
            publish_date  => publish_date,
            mime_type     => mime_type,
            text          => text,
            item_id       => item_id,
            creation_date => creation_date,
            creation_user => creation_user,
            creation_ip   => creation_ip
        );
        -- create new news entry with new revision
        insert into cr_news
            (news_id, 
             package_id,
             archive_date, 
             approval_user, 
             approval_date, 
             approval_ip)
        values
            (v_revision_id, 
             package_id,
             archive_date, 
             approval_user, 
             approval_date,
             approval_ip);
        -- make active revision if indicated
        if make_active_revision_p = 't' then
            news.revision_set_active(v_revision_id);
        end if;
        return v_revision_id;
    end revision_new;



    procedure revision_set_active   (
        revision_id in cr_revisions.revision_id%TYPE
    )
    is
        v_news_item_p char;
        -- could be used to check if really a 'news' item
    begin
        update	
            cr_items
        set
            live_revision = news.revision_set_active.revision_id,
            publish_status = 'ready'
        where
	    item_id = (select
                           item_id
                       from
                           cr_revisions
                       where
                           revision_id = news.revision_set_active.revision_id);
    end revision_set_active; 


    procedure clone   (
        new_package_id    in cr_news.package_id%TYPE    default null,
        old_package_id    in cr_news.package_id%TYPE    default null
    )
    is
      new_news_id integer;
    begin
        for one_news in (select
                            publish_date,
                            content.blob_to_string(cr.content) as text,
                            cr.nls_language,
                            cr.title as title,
                            cr.mime_type,
                            cn.package_id,
                            archive_date,
                            approval_user,
                            approval_date,
                            approval_ip,
                            ao.creation_date,
                            ao.creation_ip,
                            ao.creation_user
                        from 
                            cr_items ci, 
                            cr_revisions cr,
                            cr_news cn,
                            acs_objects ao
                        where
                            (ci.item_id = cr.item_id
                            and ci.live_revision = cr.revision_id 
                            and cr.revision_id = cn.news_id 
                            and cr.revision_id = ao.object_id)
                        or (ci.live_revision is null 
                            and ci.item_id = cr.item_id
                            and cr.revision_id = content_item.get_latest_revision(ci.item_id)
                            and cr.revision_id = cn.news_id
                            and cr.revision_id = ao.object_id))
        loop

            new_news_id := news.new(
                publish_date      => one_news.publish_date,
                text              => one_news.text,
                nls_language      => one_news.nls_language,
                title             => one_news.title,
                mime_type         => one_news.mime_type,
                package_id        => news.clone.new_package_id,
                archive_date      => one_news.archive_date,
                approval_user     => one_news.approval_user,
                approval_date     => one_news.approval_date,
                approval_ip       => one_news.approval_ip,
                creation_date     => one_news.creation_date,
                creation_ip       => one_news.creation_ip,
                creation_user     => one_news.creation_user
            );

        end loop;
    end clone;

    -- currently not used, because we want to audit revisions
    procedure revision_delete (
        revision_id in cr_revisions.revision_id%TYPE
    )
    is
    begin
    -- delete from cr_news table
        delete from cr_news
        where  news_id = news.revision_delete.revision_id;
        -- delete revision
        content_revision.delete(
            revision_id => news.revision_delete.revision_id
        );
    end revision_delete;

end news;
/
show errors
