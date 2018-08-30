/*
    Ajax File Storage 1.0
    @author Hamilton Chua (ham@solutiongrove.com)
    @creation-date 2007-11-18

*/

Ext.namespace('fsCore');
Ext.namespace('ajaxfs');
Ext.BLANK_IMAGE_URL = '/resources/ajaxhelper/ext2/resources/images/default/s.gif';

/******** File Storage Core Functions ***********/

fsCore = function(package_id,xmlhttpurl) {

    this.package_id=package_id;
    this.xmlhttpurl=xmlhttpurl;

}

fsCore.prototype = {

    // the tree loader used to fill up the folder panel

    createTreeLoader : function() {
        var treeloader = new Ext.tree.TreeLoader({ 
            dataUrl:this.xmlhttpurl+'load-treenodes',
            baseParams: { package_id:this.package_id }
        })
        return treeloader
    },

    // the httpproxy that fetches the content of a folder
    
    createFilePanelProxy : function() {
        var proxy = new Ext.data.HttpProxy( {
            url : this.xmlhttpurl+ 'get-foldercontents'
        } )
        return proxy
    },

    // do a form submit for a given action
    formSubmit : function(action, extform, waitmsg, params, reset, success, failure, scope) {

        switch(action) {
            case 'createurl':
                var url = this.xmlhttpurl+"add-url"
            break;
        }

        if (url) {
            extform.submit({
                url:url,
                waitMsg:waitmsg,
                params:params,
                scope:scope,
                success:success,
                failure:failure
            })
        }
    },

    // executes the action thru an ajax call

    doAction : function(action,successFn, failureFn, callbackFn, paramsObj, scope) {

        var url = null;

        switch(action) {
            case 'checknotif':
                url = this.xmlhttpurl+"notif_p";
            break;
            case 'addfolder':
                url = this.xmlhttpurl+"add-blankfolder";
            break;
            case 'delete':
                url = this.xmlhttpurl+"delete-fsitem";
            break;
            case 'delete-revision':
                url = this.xmlhttpurl+"delete-fileversion"
            break;
            case 'move':
                url = this.xmlhttpurl+"move-fsitem";
            break;
            case 'rename':
                url = this.xmlhttpurl+"rename-fsitem";
            break;
            case 'tag':
                url = this.xmlhttpurl+"add-tag";
            break;
            case 'sharefolder':
                url = this.xmlhttpurl+"share-folder";
            break;
        }

        if(url) {

            var config = {
                url:url,
                success: successFn,
                failure: failureFn,
                params: paramsObj
            }
    
            if(callbackFn) { config.callback = callbackFn }
            if(successFn) { config.success = successFn }
            if(failureFn) { config.failure = failureFn }
            if(scope) { config.scope = scope }
    
            Ext.Ajax.request(config)

        }

    }

}

/********** AJAXFS Class *************************/

ajaxfs = function(configObj) {

    // ******** configObj ***********

    // ajaxFs expects a config object that may have the following properites
    // - configObj.package_id : the package_id of the current ajaxFs Instance
    // - configObj.initOpenFolder : if this value is not null, it should contain the folder id to open when object is instantiated
    // - configObj.layoutdiv : the div container where we put the layout, if none is provided then document.body is used
    // - configObj.xmlhttpurl : just in case ajaxfs is mounted elsewhere other than /ajaxfs
    // - configObj.createUrl : do we show the createurl button in the toolbar
    // - configObj.sharefolders : do we implement folder sharing

    // ******** properties *********

    // holds an object with configruation settings for this instance
    //  of ajaxfs, this variable is set only if configObj exists and is passed
    this.config = null;

    // url of xmlhttp files from ajaxfs, defaults to /ajaxfs/xmlhttp
    this.xmlhttpurl = '/ajaxfs/xmlhttp/';

    // do we or do we not allow creating url's in fs, defaults to true
    this.create_url_p = true;

    // do we support folder sharing
    this.share_folders_p = true;

    // holds a reference to the layout for the center page
    this.layout = null;
    
    // reference to the tree editor for the treepanel
    this.te = null;

    // holds the id of the currently selected node in the tree
    this.currentfolder = null;

    // currently selected tag
    this.currenttag = null;

    // reference to messagebox
    this.msgbox = Ext.MessageBox;

    // create upload dialog
    this.upldWindow = null;

    // tagdialog
    this.tagWindow = null;

    // create url window
    this.createurlWindow = null;

    // share folder window
    this.sharefolderWindow = null;

    // revisions window
    this.revisionsWindow = null;

    // reference to contextmenu
    this.contextmenu = null;

    // reference to an instance of the swfuploader
    //  used for ajaxfs
    this.swfu = null;

    // variable to store target folder when it is being shared
    this.target_folder_id = null;

    // variable to store combo
    this.communityCombo = null;


    //********* initialize *********

    this.initObj = function() {

        // check if ExtJs is loaded before anything else

        if (typeof(Ext.DomHelper) != "undefined") {

            // ExtJs is loaded
            // process configObj
            if (configObj) { 

                this.config = configObj;
                if(this.config.xmlhttpurl) { this.xmlhttpurl = this.config.xmlhttpurl }
                if(this.config.create_url == 0) { this.create_url_p = false }
                if(this.config.share_folders == 0) { this.share_folders_p = false }
                if(this.config.views_p == 0) {
                    this.views_p = false
                } else {
                    this.views_p = true
                }

                // generic listener to check if 
                // the connection has returned a login form
                // in which case we need to redirect the user 
                //  to a login form
                // this listener is activated only if the fs instance
                //  is not a public instance

                if(!this.config.ispublic) {
                    Ext.Ajax.on("requestcomplete", this.isSessionExpired, this);
                }

                // instantiate the core object that allows us to work with the back-end
                this.fsCore = new fsCore(this.config.package_id,this.xmlhttpurl);
    
                // initialize tooltips
                Ext.QuickTips.init();
    
                // setup the layout and panels
                this.initLayout();

            }

        }

    }

    Ext.onReady(this.initObj,this,true);

}

ajaxfs.prototype = {

    // check if login has expired

    isSessionExpired : function(conn,response,options) {

        // check if we are still logged in
        if ( readCookie("ad_session_id") == null ) {
            Ext.get(document.body).mask(acs_lang_text.sessionexpired || "Your session has expired. You need to login again. <br>You will be redirected to a login page shortly");
            var params = '';
            if(this.currentfolder != null) {
                var params = "?folder_id="+this.currentfolder;
            }
            window.location="/register/?return_url="+this.config.package_url+params;
        }

    },

    // recursive expand in case folder id is not on the first level
    asyncExpand : function(x) {
        var treepanel = this.layout.findById('treepanel');
        var node = treepanel.getNodeById(this.config.initOpenFolder);
        if(!node) {
            var x = x+1;
            var nextnodeid = this.config.pathToFolder[x];
            var nextnode = treepanel.getNodeById(nextnodeid);
            nextnode.on("expand",this.asyncExpand.createDelegate(this,[x]), this, {single:true});
            nextnode.expand(true);
        } else {
            node.select()
            node.fireEvent("click",node);
        }
    },

    // if we get an initOpenFolder config,
    //  expand the provided initOpenFolder id
    selectInitFolder : function() {
        var treepanel = this.layout.findById('treepanel');
        if(this.config.initOpenFolder) {
            var initNode = treepanel.getNodeById(this.config.initOpenFolder);
            if(initNode) { 
                initNode.expand();
                initNode.fireEvent("click",initNode) 
            } else {
                // recursively expand based on the list of folder_ids in pathToFolder
                var x = 1;
                var nextnode = treepanel.getNodeById(this.config.pathToFolder[x]);
                nextnode.on("expand",this.asyncExpand.createDelegate(this,[x]), this, {single:true});
                nextnode.expand(true);
            }
         } else {
            treepanel.fireEvent("click",treepanel.getRootNode());
         }
    },

    // creates the main layout for ajaxfs

    initLayout : function() {

        /*  Load the UI in document.body if a layoutdiv is not provided */

        var layoutitems = [this.createLeft(),this.createRight()]

        if (this.config != null && this.config.layoutdiv) {

            Ext.get(this.config.layoutdiv).setHeight(400,false);
            Ext.get(this.config.layoutdiv).update(" ");

            this.layout = new Ext.Panel({
                id:"fs-ui",
                layout:'border',
                applyTo:this.config.layoutdiv,
                tbar:this.createToolbar(),
                items: layoutitems
            })

        } else {

            this.layout = new Ext.Viewport({
                id:"fs-ui",
                layout:'border',
                tbar:this.createToolbar(),
                items: layoutitems
            });

        }

    },

    // create a tools menu that has the same items as the context menu
    createToolsMenu : function() {

        var beforeshow = function() {

            var gridpanel = this.layout.findById('filepanel');
            var treepanel = this.layout.findById('treepanel');

            // allow use of this tool on the treepanel folders
            // we want it to work on the tree if there are no files selected

            if (gridpanel.getSelectionModel().getCount() == 0) {

                // start by enabling all the tools menu items

                for(var x=0; x<menu.items.items.length;x++) {
                    menu.items.items[x].enable();
                }

                // selectively disable

                Ext.getCmp('mnOpen').setText(acs_lang_text.open || 'Open');
                Ext.getCmp('mnOpen').disable();
                Ext.getCmp('mnTag').disable();
                Ext.getCmp('mnProp').disable();
                Ext.getCmp('mnArch').disable();
                Ext.getCmp('mnShare').disable();

                //check if the user is subscribed to this folder

                var success = function(o) {
                    if(parseInt(o.responseText)) {
                        Ext.getCmp('mnNotif').setText(acs_lang_text.unsubscribe_notification || 'Unsubscribe');
                    } else {
                        Ext.getCmp('mnNotif').setText(acs_lang_text.request_notification || 'Request Notification');
                    }
                } 

                var failure = function(response) {
                    // presume user is not subscribed
                    Ext.getCmp('mnNotif').setText(acs_lang_text.request_notification || 'Request Notification');
                }

                this.fsCore.doAction('checknotif',success, failure, null,{ object_id:treepanel.getSelectionModel().getSelectedNode().attributes["id"] });

                Ext.getCmp('mnNotif').enable();

            } else {

                if (gridpanel.getSelectionModel().getCount() == 1) {
    
                    var selectedRow = gridpanel.getSelectionModel().getSelections();

                    for(var x=0; x<menu.items.items.length;x++) {
                        menu.items.items[x].enable();
                    }

                    Ext.getCmp('mnNotif').setText(acs_lang_text.request_notification || 'Request Notification');

                    switch (selectedRow[0].get("type"))  {
                        case "folder":

                            Ext.getCmp('mnOpen').setText(acs_lang_text.open || 'Open');
                            Ext.getCmp('mnTag').disable();
                            Ext.getCmp('mnPerms').disable();

                            var success = function(o) {
                                if(parseInt(o.responseText)) {
                                    Ext.getCmp('mnNotif').setText(acs_lang_text.unsubscribe_notification ||'Unsubscribe');
                                } else {
                                    Ext.getCmp('mnNotif').setText(acs_lang_text.request_notification ||'Request Notification');
                                }
                            }

                            var failure = function(response) {
                                // presume user is not subscribed
                                Ext.getCmp('mnNotif').setText(acs_lang_text.request_notification || 'Request Notification');
                            }

                            this.fsCore.doAction('checknotif',success, failure, null,{ object_id:treepanel.getSelectionModel().getSelectedNode().attributes["id"] });
                            Ext.getCmp('mnNotif').enable();
                            if(this.share_folders_p) { Ext.getCmp('mnShare').enable() }
                            break;
                        case "symlink":
                            Ext.getCmp('mnOpen').setText(acs_lang_text.open || 'Open');
                            Ext.getCmp('mnTag').disable();
                            Ext.getCmp('mnRename').disable();
                            Ext.getCmp('mnProp').disable();
                            Ext.getCmp('mnNotif').disable();
                            break;
                        case "url" :
                            Ext.getCmp('mnOpen').setText(acs_lang_text.open || 'Open');
                            Ext.getCmp('mnProp').disable();
                            Ext.getCmp('mnArch').disable();
                            Ext.getCmp('mnShare').disable();
                            Ext.getCmp('mnNotif').disable();
                            break;
                        default :
                            Ext.getCmp('mnOpen').setText(acs_lang_text.download || 'Download');
                            Ext.getCmp('mnArch').disable();
                            Ext.getCmp('mnShare').disable();
                            Ext.getCmp('mnNotif').disable();
                            break;
                    }
    
                    // always disable if shared folders are not supported
                    if(!this.share_folders_p) {
                        Ext.getCmp('mnShare').disable();
                    }
    
                } else {
    
                    for(var x=0; x<menu.items.items.length;x++) {
                        menu.items.items[x].disable();
                    }
    
                }

            }

            // always disable views if views package is not installed

            if(!this.views_p) {
                Ext.getCmp('mnView').disable();
            }

        }

        var itemclick = function(item,e) {

            var gridpanel = this.layout.findById('filepanel');

            if(gridpanel.getSelectionModel().getCount() == 1) {

                // panel is the filegrid
                var panel = this.layout.findById('filepanel');
                var recordid = panel.getSelectionModel().getSelected().get("id");
    
                for (var x=0; x<panel.store.data.items.length; x++) {
                    if (panel.store.data.items[x].id == recordid) { var i = x; break }
                }

            } else {

                // panel is the tree
                var panel = this.layout.findById('treepanel');
                var recordid = panel.getSelectionModel().getSelectedNode().attributes["id"];
                var i = recordid;

            }


            switch (item.getId())  {
                case "mnOpen":
                    this.openItem(panel, i);
                    break;
                case "mnTag":
                    this.tagFsitem(panel, i);
                    break;
                case "mnView":
                    this.redirectViews(panel, i);
                    break;
                case "mnRename":
                    this.renameItem(panel,i);
                    break;
                case "mnCopyLink":
                    this.copyLink(panel,i);
                    break;
                case "mnPerms":
                    this.redirectPerms(panel, i);
                    break;
                case "mnProp":
                    this.showRevisions(panel, i);
                    break;
                case "mnArch":
                    this.downloadArchive(recordid);
                    break;
                case "mnShare":
                    this.showShareOptions(panel, i);
                    break;
                case "mnNotif":
                    this.redirectNotifs(panel, i);
                    break;
            }

        }

        var menu = new Ext.menu.Menu({
            id: 'toolsmenu',
            shadow:false,
            items: [
                new Ext.menu.Item({ id:'mnOpen',text: acs_lang_text.open || 'Open',icon: '/resources/ajaxhelper/icons/page_white.png'}),
                new Ext.menu.Item({ id:'mnTag', text: acs_lang_text.tag || 'Tag', icon: '/resources/ajaxhelper/icons/tag_blue.png' }),
                new Ext.menu.Item({ id:'mnView', text: acs_lang_text.views || 'Views', icon: '/resources/ajaxhelper/icons/camera.png' }),
                new Ext.menu.Item({ id:'mnRename', text: acs_lang_text.rename || 'Rename', icon: '/resources/ajaxhelper/icons/page_edit.png' }), 
                new Ext.menu.Item({ id:'mnCopyLink', text: acs_lang_text.linkaddress || 'Copy Link Address', icon: '/resources/ajaxhelper/icons/page_copy.png' }), 
                new Ext.menu.Item({ id:'mnPerms', text: acs_lang_text.permissions || 'Permissions', icon: '/resources/ajaxhelper/icons/group_key.png' }), 
                new Ext.menu.Item({ id:'mnProp', text: acs_lang_text.properties || 'Properties', icon: '/resources/ajaxhelper/icons/page_edit.png' }), 
                new Ext.menu.Item({ id:'mnArch', text: acs_lang_text.download_archive || 'Download archive', icon: '/resources/ajaxhelper/icons/arrow_down.png' }),
                new Ext.menu.Item({ id:'mnShare', text: acs_lang_text.sharefolder || 'Share Folder', icon: '/resources/ajaxhelper/icons/group_link.png' }),
                new Ext.menu.Item({ id:'mnNotif', text: acs_lang_text.request_notification || 'Request Notification', icon: '/resources/ajaxhelper/icons/email.png' }) ],
            listeners:{
                'beforeshow':{
                    scope:this,
                    fn:beforeshow
                }, 'itemclick':{
                    scope:this,
                    fn:itemclick
                }
            }
        })

        var tbutton = {
            id:'btnToolsMenu',
            text:'Tools',
            iconCls:'toolsmenu',
            menu: menu
        };

        return tbutton;
    },

    // create the toolbar for this instance of ajaxfs

    createToolbar : function() {
        var toolbar = [
            ' ',
            {id:'btnNewFolder',text: acs_lang_text.newfolder || 'New Folder', tooltip: acs_lang_text.newfolder || 'New Folder', icon: '/resources/ajaxhelper/icons/folder_add.png', cls : 'x-btn-text-icon', scope:this,handler: this.addFolder},
            {id:'btnUploadFile', text: acs_lang_text.uploadfile || 'Upload Files', tooltip: acs_lang_text.uploadfile || 'Upload Files', icon: '/resources/ajaxhelper/icons/page_add.png', cls : 'x-btn-text-icon', scope:this, handler: this.addFile}
        ];
        if(this.create_url_p) {
            toolbar.push({id:'btnCreateUrl',text: acs_lang_text.createurl || 'Create Url',tooltip: acs_lang_text.createurl || 'Create Url', icon: '/resources/ajaxhelper/icons/page_link.png', cls : 'x-btn-text-icon', scope:this, handler: this.addUrl});
        }
        toolbar.push({id:'btnDelete',text: acs_lang_text.deletefs || 'Delete', tooltip: acs_lang_text.deletefs || 'Delete', icon: '/resources/ajaxhelper/icons/delete.png', cls : 'x-btn-text-icon', scope:this, handler: this.delItem });
        toolbar.push(this.createToolsMenu());
        toolbar.push('->');
        toolbar.push({tooltip: 'This may take a few minutes if you have a lot of files', text: acs_lang_text.download_archive || 'Download Archive', icon: '/resources/ajaxhelper/icons/arrow_down.png', cls : 'x-btn-text-icon', scope:this, handler: function() { this.downloadArchive(rootnode.id) } });
        return toolbar;
    },

    // check permissions of the given tree node and enable/disable toolbars as needed
    
    resetToolbar : function(node) {
        if(node.attributes.attributes["write_p"]) {
            Ext.getCmp('btnNewFolder').show();
            Ext.getCmp('btnUploadFile').show();
            if(this.create_url_p) {
                Ext.getCmp('btnCreateUrl').show();
            }
            //btnToolsMenu elements
            Ext.getCmp('mnRename').show();
        } else {
            Ext.getCmp('btnNewFolder').hide();
            Ext.getCmp('btnUploadFile').hide();
            Ext.getCmp('btnCreateUrl').hide();
            //btnToolsMenu elements
            Ext.getCmp('mnRename').hide();
        }
              
        if(node.attributes.attributes["delete_p"]) {
            Ext.getCmp('btnDelete').show();
        } else {
            Ext.getCmp('btnDelete').hide();
        }

        if(node.attributes.attributes["admin_p"]) {
            Ext.getCmp('mnPerms').show();
            Ext.getCmp('mnProp').show();
        } else {
            Ext.getCmp('mnPerms').hide();
            Ext.getCmp('mnProp').hide();
        }
    },
 
    // creates the left panel as an accordion, top panel has the folders, bottom panel has the tags

    createLeft : function() {
        var panel = new Ext.Panel ({
            id:'leftpanel',
            region:'west',
            collapsible:true,
            collapseMode: 'mini',
            titlebar:false,
            layout:'accordion',
            split:true,
            width:300,
            items:[this.createTreePanel(),this.createTagPanel()]
        });
        return  panel;
    },

    // creates the right panel which lists the files inside a folder

    createTreePanel : function() {

        // build the tree

        var rootnode = new Ext.tree.AsyncTreeNode({
            text: this.config.treerootnode.text,
            draggable:false,
            id:this.config.treerootnode.id,
            singeClickExpand: true,
            expanded:true,
            attributes: this.config.treerootnode.attributes
        });

        var loader = this.fsCore.createTreeLoader();

        var treepanel = new Ext.tree.TreePanel({
            id:'treepanel',
            title:acs_lang_text.folders || 'Folders',
            autoScroll:true,
            animate:true,
            enableDrag:false,
            enableDrop:true,
            loadMask:true,
            loader: loader,
            root: rootnode,
            ddAppendOnly: true,
            containerScroll: true,
            dropConfig: {
                dropAllowed: true,
                ddGroup:'fileDD',
                onNodeOver : function(treenode,source,e,data) {

                    // DO NOT ALLOW DROP TO CURRENT FOLDER
                    // check if the id of target node to be dropped
                    //  is the same as the currently selected tree node
                    if (treenode.node.id == treenode.node.ownerTree.getSelectionModel().getSelectedNode().id) {
                        return false;
                    }

                    // DO NOT ALLOW TO DROP A FOLDER TO ITSELF IN THE TREE
                    // check if the id of any of the nodes to be dropped
                    // is the same as the id on the tree
                    if(source.dragData.selections) {
                        for (var x=0; x<source.dragData.selections.length; x++) {
                            if (treenode.node.id == source.dragData.selections[x].data.id) {
                                return false;
                            }
                        }
                    }
                    return "x-dd-drop-ok";

                }, onNodeDrop : function(treenode,source,e,data) {

                    // we dropped a row from the grid
                    var filepanel=this.layout.findById("filepanel");
                    var folder_target_id = treenode.node.id;

                    var file_ids = [];
                    for(var x=0;x<data.selections.length;x++) {
                        file_ids[x] = data.selections[x].data.id;
                    }

                    var err_msg_txt = acs_lang_text.an_error_occurred || "An error occurred";
                    var err_msg_txt2 = acs_lang_text.reverted || "Your changes have been reverted";

                    var moveSuccess = function(response) {
                        var resultObj = Ext.decode(response.responseText);
                        if (resultObj.success) {
                            var dm = filepanel.store;
                            var selectedRows = filepanel.getSelectionModel().getSelections();
                            var hasfolder = false;
                            // remove folder/file from right panel
                            //  remove folder if it exists on the tree
                            for(var x=0; x<selectedRows.length; x++) {
                                dm.remove(selectedRows[x]);
                                //  and set the current parent's loaded property to false
                                if (selectedRows[x].data.type == "folder") {
                                    hasfolder = true;
                                    if(treenode.node.ownerTree.getNodeById(selectedRows[x].data.id)) {
                                        var oldparent = treenode.node.ownerTree.getNodeById(selectedRows[x].data.id).parentNode;
                                        oldparent.loaded = false;
                                        oldparent.removeChild(treenode.node.ownerTree.getNodeById(selectedRows[x].data.id));
                                    }
                                }
                            }

                            // if a folder is moved to the root, we need to select it
                            //  because the entire tree needs to be reloaded
                            if (hasfolder) {
                                var treeroot = treenode.node.ownerTree.getRootNode();
                                if (treeroot.id == treenode.node.id) {
                                    treeroot.fireEvent("click",treeroot)
                                }
                                treenode.node.loaded=false;
                                treenode.node.expand();
                            }

                        } else {
                            Ext.Msg.alert(acs_lang_text.error || "Error",err_msg_txt+"<br>"+err_msg_txt2);
                        }
                    }

                    var failure=function(response) {
                        var resultObj = Ext.decode(response.responseText);
                        var msg = "";
                        if(resultObj.error) { msg = resultObj.error }
                        // ajax failed, revert value
                        Ext.Msg.alert(acs_lang_text.error || "Error",err_msg_txt+"<br>"+msg+"<br>"+err_msg_txt2);
                    }

                    this.fsCore.doAction('move',moveSuccess, failure, null,{ folder_target_id:folder_target_id,file_ids:file_ids });

                    return true;

                }.createDelegate(this)
            }
        });

        // ** allow renaming folders on tree **

        this.enableTreeFolderRename(treepanel);

        // ** listeners **

        rootnode.on("expand",this.selectInitFolder,this,{single:true});

        treepanel.on("click",this.loadFoldercontents,this);

        return treepanel;
    },

    // enable renaming of tree folder
    enableTreeFolderRename : function(treepanel) {

        // ** create editor ***

        this.te = new Ext.tree.TreeEditor(treepanel, {
            allowBlank:false,
            blankText: acs_lang_text.folder_name_required || 'A folder name is required',
            ignoreNoChange:true
        });

        // ** listeners **
        
        // check if user has premission to rename
        // permissions are checked again on the server when request is submitted
        this.te.on("beforestartedit", function(node,el,oldname) {
            if (node.editNode.attributes.attributes.write_p == "t") {
                return true;
            } else {
                Ext.Msg.alert(acs_lang_text.permission_denied || "Permission Denied", acs_lang_text.permission_denied || "Sorry, you do not have permission to rename this folder");
                return false;
            }
        }, this, true);

        // reject if the folder name is already being used by a sibling 
        this.te.on("beforecomplete",function(node,newval,oldval) {
            var parent = node.editNode.parentNode;
            if(parent) {
                var children = parent.childNodes;
                for(x=0;x<children.length;x++) {
                    if (children[x].text == newval && children[x].id != node.editNode.id) {
                        Ext.Msg.alert(acs_lang_text.duplicate_name || "Duplicate Name", acs_lang_text.duplicate_name_error || "Please enter a different name. The name you entered is already being used.");
                        return false;
                    }
                }
            }
            return true;
        }, this, true);

        // send the update to server and validate
        this.te.on("complete", function(node,newval,oldval) {
        
            var err_msg_txt = acs_lang_text.an_error_occurred || "An error occurred";
            var err_msg_txt2 = acs_lang_text.reverted || "Your changes have been reverted";

            var success = function(response) {
                var resultObj = Ext.decode(response.responseText);
                if (!resultObj.success) {
                    Ext.Msg.alert(acs_lang_text.error || "Error",err_msg_txt+": <br><br><font color='red'>"+resultObj.error+"</font><br><br>"+err_msg_txt2);
                    node.editNode.setText(oldval);
                }
            }

            var failure = function() {
                // ajax failed, revert value
                Ext.Msg.alert(acs_lang_text.error || "Error",err_msg_txt+"<br>"+err_msg_txt2);
                node.editNode.setText(oldval);
            }

            this.fsCore.doAction('rename',success, failure, null,{ newname:newval, object_id:node.editNode.id, type:"folder" });

        }, this, true);

    },

    // creates the right panel which lists the files inside a folder

    createTagPanel : function() {

        var panel = new Ext.Panel({
            id:'tagcloudpanel',
            title:'Tags',
            frame:false,
            loadMask:true,
            autoScroll:true,
            autoLoad:{url:this.xmlhttpurl+'get-tagcloud',params:{package_id:this.config.package_id}}
        });

        var listenTagClick = function() {

            var ajaxfsObj = this;
            var currenttag = ajaxfsObj.currenttag;

            panel.body.on("click",function(obj,el) {
                if(el.tagName == "A") {
                    if (currenttag != null) { Ext.get(currenttag).setStyle('font-weight','normal') }
                    Ext.get(el).setStyle('font-weight','bold');
                    currenttag = el.id;
                    this.loadTaggedFiles(el.id);
                }
            },this);

        }

        panel.on("render", listenTagClick,this);

        return  panel;
    },

    // loads the objects associated with a tag
    loadTaggedFiles : function (tagid) {

        this.layout.findById("treepanel").getSelectionModel().clearSelections();
        var id = tagid.substring(3,tagid.length);
        this.layout.findById("filepanel").store.baseParams['tag_id'] = id;
        this.layout.findById("filepanel").store.load();
        this.layout.findById("filepanel").store.baseParams['tag_id'] = '';

    },


    // creates the right panel which lists the files inside a folder

    createRight : function() {

        var renderfilename = function(value,p,record) {
            p.attr = "ext:qtip='"+record.get("qtip")+"'";
            return value;
        }

        var cols = [{header: "", width: 30,sortable: true, dataIndex: 'icon'},
                    {header: acs_lang_text.filename || "Filename", id:'filename', sortable: true, dataIndex: 'title', renderer:renderfilename},
                    {header: acs_lang_text.size || "Size", sortable: true, dataIndex: 'size'},
                    {header: acs_lang_text.lastmodified || "Last Modified", sortable: true, dataIndex: 'lastmodified'}];

        var reader = new Ext.data.JsonReader(
                    {totalProperty: 'total', root: 'foldercontents', id: 'id'}, [
                    {name:'id', type: 'int'},
                    {name:'qtip'},
                    {name:'icon'},
                    {name:'title'},
                    {name:'filename'},
                    {name:'type'},
                    {name:'tags'},
                    {name:'url'},
                    {name:'linkurl'},
                    {name:'write_p'},
                    {name:'symlink_id'},
                    {name:'size'},
                    {name:'lastmodified'},
                    {name:'write_p'},
                    {name:'admin_p'}] );

        var proxy = this.fsCore.createFilePanelProxy();

        var colModel = new Ext.grid.ColumnModel(cols);

        var dataModel = new Ext.data.Store({proxy: proxy, reader: reader, remoteSort: true});

        var gridpanel = new Ext.grid.GridPanel( {
            store: dataModel,
            cm: colModel,
            id:'filepanel',
            ddGroup:'fileDD',
            region:'center',
            split:true,
            autoScroll:true,
            autoExpandColumn:'filename',
            enableDragDrop:true,
            width:250,
            loadMask:true,
            frame:false,
            viewConfig: { 
                forceFit: false,
                enableRowBody:true,
                showPreview:true,
                deferEmptyText: true,
                emptyText: 'This folder is empty',
                getRowClass: function(record,rowIndex,p,ds) {
                    var xf = Ext.util.Format;
                    if (record.data.tags!= "") {
                        p.body = "<div id='tagscontainer"+record.data.id+"' style='padding-left:35px;color:blue'>Tags: " + xf.ellipsis(xf.stripTags(record.data.tags), 200) + "</div>";
                    } else {
                        p.body = "<div id='tagscontainer"+record.data.id+"' style='padding-left:35px;color:blue'></div>";
                    }
                    return 'x-grid3-row-expanded';
                }
            }
        });

        // listeners

        gridpanel.on("rowdblclick",this.openItem,this,true);

        gridpanel.on("rowcontextmenu",this.showRowContext,this,true);

        return  gridpanel;
    },

    // generate the contextbar for the file panel
    showRowContext : function(grid,i,e) {

        e.stopEvent();

        var treepanel = this.layout.findById('treepanel');
        var rootnode = this.config.treerootnode;
        var dm = grid.store;
        var record = dm.getAt(i);
        var object_type = record.get("type");
        var recordid = record.get("id");
        var openitem_txt;
        
        switch (object_type ) {
            case "folder" :
                openitem_txt = "Open";
                break;
            case "url" :
                openitem_txt = "Open";
                break;
            default :
                openitem_txt = "Download";
                break;
        }

        // create the menus
        this.contextmenu = new Ext.menu.Menu({
            id: 'rightclickmenu',
            items: [
            new Ext.menu.Item({
                id: 'ctxMnOpen',
                text: openitem_txt,
                icon: '/resources/ajaxhelper/icons/page_white.png',
                scope:this,
                handler: function() {
                    this.openItem(grid, i, e)
                }
            }),
            new Ext.menu.Item({
                id: 'ctxMnTag',
                text: 'Tag',
                icon: '/resources/ajaxhelper/icons/tag_blue.png',
                scope:this,
                handler: function() {
                    this.tagFsitem(grid, i, e)
                }
            }),
            new Ext.menu.Item({
                id: 'ctxMnView',
                text: 'Views',
                icon: '/resources/ajaxhelper/icons/camera.png',
                scope:this,
                handler: function() {
                    this.redirectViews(grid, i, e)
                }
            }),
            new Ext.menu.Item({
                id: 'ctxMnDelete',
                text: acs_lang_text.deletefs || 'Delete',
                icon: '/resources/ajaxhelper/icons/delete.png',
                scope:this,
                handler: function() {
                    this.delItem(grid,i,e)
                }
            }),
            new Ext.menu.Item({
                id: 'ctxMnRename',
                text: acs_lang_text.rename || 'Rename',
                icon: '/resources/ajaxhelper/icons/page_edit.png',
                scope:this,
                handler: function() {
                    this.renameItem(grid,i,e)
                }
            }),
            new Ext.menu.Item({
                id: 'ctxMnCopyLink',
                text: acs_lang_text.linkaddress || 'Copy Link Address',
                icon: '/resources/ajaxhelper/icons/page_copy.png',
                scope:this,
                handler: function() {
                    this.copyLink(grid,i,e)
                }
            }), 
            new Ext.menu.Item({
                id: 'ctxMnPerms',
                text: acs_lang_text.permissions || 'Permissions',
                icon: '/resources/ajaxhelper/icons/group_key.png',
                scope:this,
                handler: function() {
                    this.redirectPerms(grid,i,e)
                }
            }), 
            new Ext.menu.Item({
                id: 'ctxMnProp',
                text: acs_lang_text.properties || 'Properties',
                icon: '/resources/ajaxhelper/icons/page_edit.png',
                scope:this,
                handler: function() {
                    this.showRevisions(grid,i,e)
                }
            }), 
            new Ext.menu.Item({
                id: 'ctxMnArch',
                text: acs_lang_text.download_archive || 'Download archive',
                icon: '/resources/ajaxhelper/icons/arrow_down.png',
                scope:this,
                handler: function() {
                    this.downloadArchive(recordid)
                }
            }),
            new Ext.menu.Item({
                id: 'ctxMnShare',
                text: acs_lang_text.sharefolder || 'Share Folder',
                icon: '/resources/ajaxhelper/icons/group_link.png',
                scope:this,
                handler: function() {
                    this.showShareOptions(grid,i,e)
                }
            })  ]
        });

        // disable open/download, rename, copy link, permissions and revisions if more than one node item from the view is selected
        if (grid.getSelectionModel().getCount() > 1) {
            Ext.getCmp('ctxMnOpen').hide();
            Ext.getCmp('ctxMnTag').hide();
            Ext.getCmp('ctxMnView').hide();
            Ext.getCmp('ctxMnDelete').hide();
            Ext.getCmp('ctxMnRename').hide();
            Ext.getCmp('ctxMnCopyLink').hide();
            Ext.getCmp('ctxMnPerms').hide();
            Ext.getCmp('ctxMnProp').hide();
            Ext.getCmp('ctxMnArch').hide();
            Ext.getCmp('ctxMnShare').hide();
        } else {
            Ext.getCmp('ctxMnOpen').show();
            Ext.getCmp('ctxMnView').show();
            Ext.getCmp('ctxMnDelete').show();
            Ext.getCmp('ctxMnRename').show();
            Ext.getCmp('ctxMnCopyLink').show();
            Ext.getCmp('ctxMnPerms').show();
            switch (object_type) {
                case "folder" :
                    Ext.getCmp('ctxMnTag').hide();
                    Ext.getCmp('ctxMnProp').hide();
                    Ext.getCmp('ctxMnArch').show();
                    if (treepanel.getNodeById(recordid).attributes.attributes.type == "symlink") {
                        Ext.getCmp('ctxMnShare').hide();
                    } else {
                        Ext.getCmp('ctxMnShare').show();
                    }
                    break;
                case "url" :
                    Ext.getCmp('ctxMnTag').show();
                    Ext.getCmp('ctxMnProp').hide();
                    Ext.getCmp('ctxMnArch').hide();
                    Ext.getCmp('ctxMnShare').hide();
                    break;
                case "symlink":
                    Ext.getCmp('ctxMnRename').hide();
                    Ext.getCmp('ctxMnShare').hide();
                    break;
                default:
                    Ext.getCmp('ctxMnTag').show();
                    Ext.getCmp('ctxMnProp').show();
                    Ext.getCmp('ctxMnArch').hide();
                    Ext.getCmp('ctxMnShare').hide();
            }
        }

        // always disable if shared folders are not supported
        if(!this.share_folders_p) {
            Ext.getCmp('ctxMnShare').hide();
        }

        // always disable if views package is not supported
        if(!this.views_p) {
            Ext.getCmp('ctxMnView').hide();
        }

        if(record.get("write_p") != true) {
            Ext.getCmp('ctxMnTag').hide();
            Ext.getCmp('ctxMnShare').hide();
            Ext.getCmp('ctxMnRename').hide();
        }

        if(record.get("delete_p") != true) {
            Ext.getCmp('ctxMnDelete').hide();
        }

        if(record.get("admin_p") != true) {
            Ext.getCmp('ctxMnPerms').hide();
            Ext.getCmp('ctxMnProp').hide();
        }

        var coords = e.getXY();
        this.contextmenu.rowid = i;
        this.contextmenu.showAt([coords[0], coords[1]]);

    },

    // load content of folder in file pane
    // called from treepanel listener

    loadFoldercontents : function(node, e) {

        // currently selected folder
        this.currentfolder = node.id;

        // get filepanel
        var gridpanel = this.layout.findById('filepanel');

        // fetch the folder contents

        gridpanel.store.baseParams['folder_id'] = node.id;
        gridpanel.store.baseParams['package_id'] = this.config.package_id;
        // gridpanel.store.baseParams['tag_id'] = '';

        this.resetToolbar(node);

        gridpanel.store.on('load',function(store,records) {
            node.attributes.attributes.size = records.length+" items";
        },{single:true})

        // if the tree node is still loading, wait for it to expand before loading the grid
        if(node.loading) {
            node.on("expand", function() { this.store.load() }, gridpanel, {single:true});
        } else{
            gridpanel.store.load();
        }
    },

    // executes an action depending on the type of fs item
    // - folders : open the folder in the tree
    // - file : download the file
    // - url : open the url in a new window
    openItem : function(grid,i,e) {

        var treepanel = this.layout.findById('treepanel');
        var dm = grid.store;
        var record = dm.getAt(i);
        if(record.get("type") == "folder"|| record.get("type") == "symlink") {
            var node = treepanel.getNodeById(record.get("id"));
            if(!node.parentNode.isExpanded()) { node.parentNode.expand() }
            node.fireEvent("click",node);
            node.expand();
        } else {
            // this is a file, let the user download
            window.open(record.get("url"));
            window.focus();
        }

    },

    // deletes an fs item (folder, file or url)
    delItem : function(grid,i,e) {

        var err_msg_txt = acs_lang_text.confirm_delete || "Are you sure you want to delete ";
        var err_msg_txt2 = acs_lang_text.foldercontains || "This folder ";
        var error_msg_txt = acs_lang_text.delete_error || "Sorry,there was an error trying to delete this item.";

        var treepanel = this.layout.findById('treepanel');
        if(grid.id=="filepanel") { 
            var filepanel = grid;
            if(filepanel.getSelectionModel().getCount()<=1) {
                filepanel.getSelectionModel().selectRow(i);
            }
        } else { 
            var filepanel = this.layout.findById('filepanel');
        }
        var selectedRows = filepanel.getSelectionModel().getSelections();
        var delfromtree = true;

        // build the warning message, we want the delete to be intuitive
        // determine if we're deleting from  tree panel or from file panel

        if (selectedRows.length > 0) {

            delfromtree = false;

            // ** delete item from grid **
            if (selectedRows.length == 1) {
                var filetodel = selectedRows[0].get("title");
                if(selectedRows[0].get("type") === "folder") {
                    var msg = err_msg_txt2 + "contains <b>"+selectedRows[0].get("size")+"</b>.<br>"
                } else {
                    var msg = "";
                }
                var msg = msg + err_msg_txt+" <b>"+filetodel+"</b> ?";
                if(selectedRows[0].get("type") === "symlink") {
                    var object_id = selectedRows[0].get("symlink_id");
                } else {
                    var object_id = selectedRows[0].get("id");
                }
            } else {
                var msg = err_msg_txt + ": <br><br>";
                var object_id = [];
                for(var x=0; x<selectedRows.length; x++) {
                    msg = msg + "<b>" + selectedRows[x].get("title") + "</b> ";
                    if(selectedRows[x].get("type") === "folder") {
                        msg=msg+"("+selectedRows[x].get("size")+")";
                    }
                    msg=msg+"<br>";
                    if(selectedRows[x].get("type") === "symlink") {
                        object_id[x] = selectedRows[x].get("symlink_id");
                    } else {
                        object_id[x] = selectedRows[x].get("id");
                    }
                }
            }

            var params = {object_id : object_id }

        } else {

            delfromtree = true;

            // ** delete item from tree (tree only shows folders) **
            // we can't delete the root node
            var selectednode = treepanel.getSelectionModel().getSelectedNode();
            var object_id = selectednode.attributes["id"];
            var type = selectednode.attributes.attributes["type"];
            var symlink_id = selectednode.attributes.attributes["symlink_id"];
            var rootnode = treepanel.getRootNode();
            if(type == "symlink" ) {
                var params = {object_id : symlink_id }
            } else {
                var params = {object_id : object_id }
            }
            if(selectednode.attributes["id"] == rootnode.attributes["id"]) {
                Ext.Msg.alert(acs_lang_text.alert || "Alert",acs_lang_text.cant_del_root || "The root folder can not be deleted.");
                return;
            } else {
                // confirmation message
                if(typeof(selectednode.attributes.attributes["size"]) == "undefined") {
                    var msg = "";
                } else {
                    var msg = err_msg_txt2 + " contains <b>"+selectednode.attributes.attributes["size"]+"</b>.<br>";
                }
                msg = msg + err_msg_txt+' <b>'+selectednode.attributes["text"]+'</b>?';
            }

        }

        var success = function(response) {
            var resultobj = Ext.decode(response.responseText);
            if(resultobj.success) {
                if(delfromtree) {
                    var selectednode = treepanel.getSelectionModel().getSelectedNode();
                    var parentnode = selectednode.parentNode;
                    parentnode.fireEvent("click",parentnode);
                    parentnode.removeChild(selectednode);
                } else {
                    for(var x=0; x<selectedRows.length; x++) {
                        // hide the node from the json view
                        filepanel.store.remove(selectedRows[x]);
                        // if it's a node on the tree, remove it
                        var treenodeid = selectedRows[x].get("id");
                        var selectednode = treepanel.getNodeById(treenodeid);
                        if (selectednode) {
                            var parentnode = selectednode.parentNode;
                            parentnode.removeChild(selectednode);
                        }
                    }
                }
            } else {
                ext.msg.alert(acs_lang_text.error || "Error","sorry, we encountered an error.");
            }
        }

        var failure = function(o) {
            var resultObj = Ext.decode(o.responseText);
            Ext.Msg.alert(acs_lang_text.error || "Error",error_msg_txt + "<br><br><font color='red'>"+resultObj.error+"</font>");
        }

        var doDelete = function(choice) {
            if (choice === "yes") {
                this.fsCore.doAction('delete',success, failure, null,params);
            }
        }

        Ext.MessageBox.confirm(acs_lang_text.confirm || 'Confirm',msg,doDelete,this);

    },

    // creates a new folder in the db
    //  inserts a blank folder in the ui ready for user to enter name
    addFolder : function() {

        // get currently selected folder
        var te = this.te;
        var tree = this.layout.findById('treepanel');
        var currentTreeNode = tree.getSelectionModel().getSelectedNode();
        currentTreeNode.expand();

        // error message if this action fails
        var error_msg_txt = acs_lang_text.new_folder_error || "Sorry, there was an error trying to create your new folder.";

        // success function
        var success = function(response) {
            var resultObj = Ext.decode(response.responseText);
            if (resultObj.success) {
                // create a new blank node on the currently selected one
                var newnode = currentTreeNode.appendChild(new Ext.tree.TreeNode({text:resultObj.pretty_folder_name,id:resultObj.id,iconCls:"folder",singleClickExpand:true,attributes:{write_p:'t',size:'0 items',type:'folder',symlink_id:''}}));
                tree.getSelectionModel().select(newnode);
                newnode.loaded=true;
                newnode.fireEvent("click",newnode);
                setTimeout(function(){
                    te.editNode = newnode;
                    te.startEdit(newnode.ui.textNode);
                }, 10);
            } else {
                Ext.Msg.alert(acs_lang_text.error || "Error",error_msg_txt + "<br><br><font color='red'>"+resultObj.error+"</font>");
            }
        }

        // failure function
        var failure = function(response) {
            var resultObj = Ext.decode(response.responseText);
            Ext.Msg.alert(acs_lang_text.error || "Error",error_msg_txt + "<br><br><font color='red'>"+resultObj.error+"</font>");
        }

        // execute the ajax
        this.fsCore.doAction('addfolder',success, failure, null,{ folder_id: currentTreeNode.attributes["id"] });

    },

    createSwfObj : function() {

        var treepanel = this.layout.findById('treepanel');
        var currentfolder = this.currentfolder;

        if(this.swfu == null) {

            var ajaxfsobj = this;
            var package_id = String(this.config.package_id);
            var user_id = String(this.config.user_id);
            var folder_id = String(this.currentfolder);
            var max_file_size = String(this.config.max_file_size);

            var progress_target = 'fsuploadprogress';

            var fileQueued = function(fileObj) {
                var upload_txt = acs_lang_text.for_upload_to || "for upload to";
                var zip_txt = acs_lang_text.zip_extracted || "Zip File (Will be extracted after upload)";
                try {
                    var folderid = ajaxfsobj.currentfolder;
                    var foldername = treepanel.getNodeById(folderid).text;
                    var progress = new FileProgress(fileObj, progress_target);
                    progress.SetStatus( upload_txt + " <b>"+foldername+"</b><br>Title: <input type='text' onblur=\"fsInstance.swfu.removeFileParam('"+fileObj.id+"','filetitle');fsInstance.swfu.addFileParam('"+fileObj.id+"','filetitle',this.value)\">(optional)<br><input type='checkbox' id='zip"+fileObj.id+"' onclick=\"if(document.getElementById('zip"+fileObj.id+"').checked) { fsInstance.swfu.addFileParam('"+fileObj.id+"','unpack_p','1') } else { fsInstance.swfu.removeFileParam('"+fileObj.id+"','unpack_p') }\"> "+ zip_txt);
                    progress.ToggleCancel(true, this);
                    this.addFileParam(fileObj.id, "folder_id", folderid);
                } catch (ex) { 
                    Ext.Msg.alert(acs_lang_text.error || "Error",ex);
                }
            }

            var fileDialogStart = function() {
                // console.log('file dialog start')
            }

            var fileQueueError = function(file, errorCode, message) {
                // console.log('file queue error')
                try {
                    if (errorCode === SWFUpload.QUEUE_ERROR.QUEUE_LIMIT_EXCEEDED) {
                        alert("You have attempted to queue too many files.\n" + (message === 0 ? "You have reached the upload limit." : "You may select " + (message > 1 ? "up to " + message + " files." : "one file.")));
                        return;
                    }
            
                    var progress = new FileProgress(file, progress_target);
                    progress.setError();
                    progress.toggleCancel(false);
            
                    switch (errorCode) {
                    case SWFUpload.QUEUE_ERROR.FILE_EXCEEDS_SIZE_LIMIT:
                        progress.SetStatus("File is too big.");
                        Ext.Msg.alert(acs_lang_text.error || "Error","Error Code: File too big, File name: " + file.name + ", File size: " + file.size + ", Message: " + message);
                        break;
                    case SWFUpload.QUEUE_ERROR.ZERO_BYTE_FILE:
                        progress.SetStatus("Cannot upload Zero Byte files.");
                        Ext.Msg.alert(acs_lang_text.error || "Error","Error Code: Zero byte file, File name: " + file.name + ", File size: " + file.size + ", Message: " + message);
                        break;
                    case SWFUpload.QUEUE_ERROR.INVALID_FILETYPE:
                        progress.SetStatus("Invalid File Type.");
                        Ext.Msg.alert(acs_lang_text.error || "Error","Error Code: Invalid File Type, File name: " + file.name + ", File size: " + file.size + ", Message: " + message);
                        break;
                    case SWFUpload.QUEUE_ERROR.QUEUE_LIMIT_EXCEEDED:
                        Ext.Msg.alert(acs_lang_text.error || "Error","You have selected too many files.  " +  (message > 1 ? "You may only add " +  message + " more files" : "You cannot add any more files."));
                        break;
                    default:
                        if (file !== null) {
                            progress.SetStatus("Unhandled Error");
                        }
                        Ext.Msg.alert(acs_lang_text.error || "Error","Error Code: " + errorCode + ", File name: " + file.name + ", File size: " + file.size + ", Message: " + message);
                        break;
                    }
                } catch (ex) { 
                    Ext.Msg.alert(acs_lang_text.error || "Error",ex);
                }
            }

            var fileDialogComplete = function() {
                // console.log('file dialog complete')
            }

            var uploadStart = function (fileObj) {
                // console.log('upload start')
                var upload_txt = acs_lang_text.for_upload_to || "for upload to";
                var zip_txt = acs_lang_text.zip_extracted || "Zip File (Will be extracted after upload)";
                try {
                    var folderid = ajaxfsobj.currentfolder;
                    var foldername = treepanel.getNodeById(folderid).text;
                    var progress = new FileProgress(fileObj, progress_target);
                    progress.SetStatus( upload_txt + " "+foldername+"b><br>Title: <input type='text' onblur=\"fsInstance.swfu.removeFileParam('"+fileObj.id+"','filetitle');fsInstance.swfu.addFileParam('"+fileObj.id+"','filetitle',this.value)\">(optional)<br><input type='checkbox' id='zip"+fileObj.id+"' onclick=\"if(document.getElementById('zip"+fileObj.id+"').checked) { fsInstance.swfu.addFileParam('"+fileObj.id+"','unpack_p','1') } else { fsInstance.swfu.removeFileParam('"+fileObj.id+"','unpack_p') }\"> "+ zip_txt);
                    progress.ToggleCancel(true, this);
                    this.addFileParam(fileObj.id, "folder_id", folderid);
                } catch (ex) { 
                    Ext.Msg.alert(acs_lang_text.error || "Error",ex);
                }
            }

            var uploadProgress = function (fileObj, bytesLoaded, bytesTotal) {
                // console.log('upload progress')
                try {
                    var percent = Math.ceil((bytesLoaded / bytesTotal) * 100);
                    var progress = new FileProgress(fileObj, progress_target);
                    progress.SetProgress(percent);
                    progress.SetStatus(acs_lang_text.uploading || "Uploading...");
                } catch (ex) { 
                    Ext.Msg.alert(acs_lang_text.error || "Error",ex);
                }
            }

            var uploadQueueComplete = function() {
                // console.log('upload queue complete')
                var currentTreeNode = treepanel.getNodeById(ajaxfsobj.currentfolder);
                currentTreeNode.fireEvent("click",currentTreeNode);
            }

            var uploadError = function(file, errorCode, message) {
                // console.log('upload error')
                try {
                    var progress = new FileProgress(file, progress_target);
                    progress.setError();
                    progress.ToggleCancel(false);
            
                    switch (errorCode) {
                    case SWFUpload.UPLOAD_ERROR.HTTP_ERROR:
                        progress.SetStatus("Upload Error: " + message);
                        Ext.Msg.alert(acs_lang_text.error || "Error","Error Code: HTTP Error, File name: " + file.name + ", Message: " + message);
                        break;
                    case SWFUpload.UPLOAD_ERROR.MISSING_UPLOAD_URL:
                        progress.SetStatus("Configuration Error");
                        Ext.Msg.alert(acs_lang_text.error || "Error","Error Code: No backend file, File name: " + file.name + ", Message: " + message);
                        break;
                    case SWFUpload.UPLOAD_ERROR.UPLOAD_FAILED:
                        progress.SetStatus("Upload Failed.");
                        Ext.Msg.alert(acs_lang_text.error || "Error","Error Code: Upload Failed, File name: " + file.name + ", File size: " + file.size + ", Message: " + message);
                        break;
                    case SWFUpload.UPLOAD_ERROR.IO_ERROR:
                        progress.SetStatus("Server (IO) Error");
                        Ext.Msg.alert(acs_lang_text.error || "Error","Error Code: IO Error, File name: " + file.name + ", Message: " + message);
                        break;
                    case SWFUpload.UPLOAD_ERROR.SECURITY_ERROR:
                        progress.SetStatus("Security Error");
                        Ext.Msg.alert(acs_lang_text.error || "Error","Error Code: Security Error, File name: " + file.name + ", Message: " + message);
                        break;
                    case SWFUpload.UPLOAD_ERROR.UPLOAD_LIMIT_EXCEEDED:
                        progress.SetStatus("Upload limit exceeded.");
                        Ext.Msg.alert(acs_lang_text.error || "Error","Error Code: Upload Limit Exceeded, File name: " + file.name + ", File size: " + file.size + ", Message: " + message);
                        break;
                    case SWFUpload.UPLOAD_ERROR.SPECIFIED_FILE_ID_NOT_FOUND:
                        progress.SetStatus("File not found.");
                        Ext.Msg.alert(acs_lang_text.error || "Error","Error Code: The file was not found, File name: " + file.name + ", File size: " + file.size + ", Message: " + message);
                        break;
                    case SWFUpload.UPLOAD_ERROR.FILE_VALIDATION_FAILED:
                        progress.SetStatus("Failed Validation.  Upload skipped.");
                        Ext.Msg.alert(acs_lang_text.error || "Error","Error Code: File Validation Failed, File name: " + file.name + ", File size: " + file.size + ", Message: " + message);
                        break;
                    case SWFUpload.UPLOAD_ERROR.FILE_CANCELLED:
                        progress.SetStatus("Cancelled");
                        progress.SetCancelled();
                        break;
                    case SWFUpload.UPLOAD_ERROR.UPLOAD_STOPPED:
                        progress.SetStatus("Stopped");
                        break;
                    default:
                        progress.SetStatus("Unhandled Error: " + error_code);
                        Ext.Msg.alert(acs_lang_text.error || "Error","Error Code: " + errorCode + ", File name: " + file.name + ", File size: " + file.size + ", Message: " + message);
                        break;
                    }
                } catch (ex) { 
                    Ext.Msg.alert(acs_lang_text.error || "Error",ex);
                }
            }

            var uploadSuccess = function(fileObj,serverData) {
                // console.log('upload success')
                try {
                    var progress = new FileProgress(fileObj, progress_target);
                    progress.SetComplete();
                    progress.SetStatus(acs_lang_text.complete || "Complete.");
                    progress.ToggleCancel(false);
                } catch (ex) { 
                    Ext.Msg.alert(acs_lang_text.error || "Error",ex);
                }
            }

            this.swfu = new SWFUpload({
                debug: false,
                post_params: {user_id:user_id,package_id:package_id},
                file_types : "*.*",
                button_placeholder_id:"btnSwfUpload",
                button_image_url : "/resources/ajax-filestorage-ui/resources/FullyTransparent_65x29.png",
                button_text:'BROWSE',
                button_width: 61,
                button_height: 16,
                button_text_left_padding : 3, 
                button_text_top_padding : 0, 
                file_dialog_start_handler : fileDialogStart,
                file_queued_handler : fileQueued,
                file_queue_error_handler : fileQueueError,
                file_dialog_complete_handler : fileDialogComplete,
                upload_start_handler : uploadStart,
                upload_progress_handler : uploadProgress,
                upload_error_handler : uploadError,
                upload_success_handler : uploadSuccess,
                queue_complete_handler : uploadQueueComplete,
                upload_url: this.xmlhttpurl + "add-file-flash",
                flash_url : "/resources/ajax-filestorage-ui/swfupload/swfupload.swf"
            });

        }
    },

    addFile : function() {

        var mode = null;

        if(this.upldWindow == null) {

            if (!this.config.multi_file_upload || checkFlashVersion() < 10) {

                /*** Single File Upload *******/
                mode = 'single';

                var msg1=acs_lang_text.file_to_upload || "File to upload";
                var msg2=acs_lang_text.file_title || "Title";
                var msg3=acs_lang_text.file_description || "Description";
                var msg4=acs_lang_text.multiple_files || "Multiple Files";
                var msg5=acs_lang_text.multiple_files_msg || "This is a ZIPfile containing multiple files.";
                var modal = true;
                var title = acs_lang_text.uploadfile || "Upload a File";

                var uploadBody = new Ext.Panel({
                    id:'form_addfile',
                    align:'left',
                    frame:true,
                    html: "<form id=\"newfileform\" method=\"post\" enctype=\"multipart/form-data\"><input type=\"hidden\" name=\"package_id\" value=\""+this.config.package_id+"\"><input type=\"hidden\" name=\"folder_id\" value=\""+this.currentfolder+"\"><p>"+msg1+"<br /><input type=\"file\" name=\"upload_file\" id=\"upload_file\"></p><br><p>"+msg2+"<br /><input type=\"text\" name=\"filetitle\" id=\"filetitle\"></p><br><p>"+msg3+" :<br /><textarea name=\"filedescription\" id=\"filedescription\"></textarea></p><p>"+msg4+" :<br /><br /><input type=\"checkbox\" name=\"unpack_p\" value=\"t\" id=\"unpack_p\" /> "+msg5+"</p></form>"
                })

                var uploadBtns = [{
                        text: acs_lang_text.upload || 'Upload',
                        scope:this,
                        handler: this.uploadOneFile,
                        icon:"/resources/ajaxhelper/icons/arrow_up.png",
                        cls:"x-btn-text-icon"
                    },{
                        text: acs_lang_text.close || 'Close',
                        scope:this,
                        handler: function(){
                            this.upldWindow.hide();
                        }, icon:"/resources/ajaxhelper/icons/cross.png",
                        cls:"x-btn-text-icon"
                }]

            } else {

                /*** Multi File Upload *******/
                mode='multiple';

                var msg_txt = acs_lang_text.upload_intro || "Click <b>Upload</b> to select a file to upload to the selected folder on the tree.";
                var modal = false;
                var title = acs_lang_text.uploadfile ||"Upload Files";

                var uploadBody = new Ext.Panel({
                    id:'form_multi_addfile',
                    autoScroll:true,
                    frame:true,
                    html: "<div id=\"upldMsg\">"+msg_txt+"<hr></div><div class=\"flash\" id=\"fsuploadprogress\"></div>"
                });

                var uploadBtns = [{
                        text:'<span id=\"btnSwfUpload\"></span>'
                    }, {
                        text: acs_lang_text.upload || 'Upload',
                        scope:this,
                        handler: function() {
                            this.swfu.startUpload()
                        },
                        icon:"/resources/ajaxhelper/icons/arrow_up.png",
                        cls:"x-btn-text-icon"
                    }, {
                        text: 'Hide',
                        scope:this,
                        handler: function(){
                            this.upldWindow.hide();
                        },
                        icon:"/resources/ajaxhelper/icons/cross.png",
                        cls:"x-btn-text-icon"
                    }
                ]


            }

            this.upldWindow = new Ext.Window({
                id:'upload-win',
                layout:'fit',
                width:400,
                height:300,
                title:title,
                closeAction:'hide',
                modal:modal,
                plain:true,
                resizable:false,
                items: uploadBody,
                buttons: uploadBtns
            });

            if(mode=='multiple') {
                this.upldWindow.on('show',function() {
                    this.createSwfObj()
                },this,{single:true})
            }

        } else {
            if (!this.config.multi_file_upload || checkFlashVersion() < 10 ) {
                document.getElementById('newfileform').reset();
                document.getElementById('newfileform').folder_id.value = this.currentfolder;
            }
        }

        this.upldWindow.show('btnUploadFile');
    },

    uploadOneFile : function() {

        if(Ext.get("upload_file").getValue() != "" && Ext.get("filetitle").getValue() != "") {

            var treepanel = this.layout.findById('treepanel');

            var callback = {
                success: function() {
                }, upload: function() {
                    treepanel.getSelectionModel().getSelectedNode().loaded=false;
                    treepanel.getSelectionModel().getSelectedNode().fireEvent("click",treepanel.getSelectionModel().getSelectedNode());
                    this.upldWindow.body.unmask();
                    this.upldWindow.hide();
                }, failure: function() {
                    Ext.Msg.alert(acs_lang_text.error || "Error", acs_lang_text.upload_failed || "Upload failed, please try again later.");
                }, scope: this
            }

            var loading_msg = acs_lang_text.loading || "One moment. This may take a while depending on how large your upload is."
            this.upldWindow.body.mask("<img src='/resources/ajaxhelper/images/indicator.gif'><br>"+loading_msg);

            YAHOO.util.Connect.setForm("newfileform", true, true);

            var cObj = YAHOO.util.Connect.asyncRequest("POST", this.xmlhttpurl+"add-file", callback);
            
        } else {

            Ext.Msg.alert(acs_lang_text.alert || "Alert", acs_lang_text.file_required || "<b>Title</b> and <b>File to upload</b> are required.");

        }
    },

    // create add url dialog
    addUrl : function() {

        if (this.createurlWindow == null) {

            this.createurlWindow = new Ext.Window({
                id:'createurl-win',
                layout:'fit',
                width:400,
                height:180,
                title:'Create URL',
                closeAction:'hide',
                modal:true,
                plain:true,
                resizable:false,
                items: new Ext.FormPanel({
                    id:'form_create_url',
                    align:'left',
                    autoScroll:true,
                    closable:true,
                    layout:'form',
                    defaults: {width: 230},
                    frame:true,
                    buttonAlign:'left',
                    items: [
                        {xtype:'textfield',fieldLabel: 'Title',allowBlank:false,name:'fstitle',tabIndex:1},
                        {xtype:'textfield',fieldLabel: 'URL',allowBlank:false,name:'fsurl',tabIndex:2,validator:isURL,value:'http://'},
                        {xtype:'textfield',fieldLabel: 'Description',name:'fsdescription',tabIndex:3}
                    ]
                }), buttons:  [{
                        text:'Submit',
                        scope:this,
                        handler: function() {

                            var createurlform = this.createurlWindow.findById('form_create_url').getForm();

                            if(createurlform.isValid()) {

                                var success = function(form,action) {
                                    if(action.result) {
                                        var treepanel = this.layout.findById('treepanel');
                                        treepanel.getSelectionModel().getSelectedNode().fireEvent("click",treepanel.getSelectionModel().getSelectedNode());
                                        this.createurlWindow.hide();
                                    } else {
                                        Ext.MessageBox.alert('Error','Sorry an error occured.<br>'+action.result.error);
                                    }
                                }

                                var failure = function(form,action) {
                                    if(action.result) {
                                        Ext.MessageBox.alert('Error',action.result.error);
                                    }
                                }

                                this.fsCore.formSubmit('createurl', createurlform, 'One moment ....', {package_id:this.config.package_id,folder_id:this.currentfolder}, true, success, failure, this)

                            }
                        },
                        icon:"/resources/ajaxhelper/icons/disk.png",
                        cls:"x-btn-text-icon"
                    },{
                        text: 'Close',
                        scope:this,
                        handler: function(){
                            this.createurlWindow.hide();
                        },
                        icon:"/resources/ajaxhelper/icons/cross.png",
                        cls:"x-btn-text-icon"
                }]
            });

        }

        this.createurlWindow.show();

    },

    // rename a file or folder in the right panel
    renameItem : function(panel,i,e) {

        var error_msg_txt = acs_lang_text.permission_denied_error || "Sorry, you do not have permission to rename this folder.";

        if(panel.id == "treepanel") {

            var node = panel.getSelectionModel().getSelectedNode();
            this.te.triggerEdit(node);

        } else {

            var filepanel = panel;
            var treepanel = this.layout.findById('treepanel');
            var node =  filepanel.store.getAt(i);
            var nodeurl = node.get("url");
            var nodetype = node.get("type");
            var nodeid = node.get("id");
            var nodesubtitle = node.get("filename");
    
            var successRename = function(response) {
                var err_msg_txt = acs_lang_text.an_error_occurred || "An error occurred";
                var err_msg_txt2 = acs_lang_text.reverted || "Your changes have been reverted";
                var resultObj = Ext.decode(response.responseText);
                if (!resultObj.success) {
                    Ext.Msg.alert(acs_lang_text.error || "Error",err_msg_txt + ": <br><br><font color='red'>"+resultObj.error+"</font><br><br>"+err_msg_txt2);
                } else {
    
                    if(nodetype=="folder") { treepanel.getNodeById(nodeid).setText(resultObj.newname) }
    
                    if(nodetype!="folder"&&nodesubtitle===" ") { 
                        nodesubtitle = node.get("title");
                        node.set("filename",nodesubtitle);
                    }
    
                    node.set("title",resultObj.newname);
                    node.commit();
                }
            };
    
            var handleRename = function(btn, text) {
            if(btn=='ok') {
    
                    if(text != '') {
    
                        if(text.length > 100) {
    
                            Ext.Msg.alert(acs_lang_text.alert || "Alert",acs_lang_text.limitto100 || "Please limit your name to 100 characters or less.");
                            return false;
    
                        } else {
    
                            var failure = function(response) {
                                var resultObj = Ext.decode(response.responseText);
                                Ext.Msg.alert(acs_lang_text.error || "Error",error_msg_txt + "<br><br><font color='red'>"+resultObj.error+"</font>");
                            } 

                            this.fsCore.doAction('rename',successRename, failure, null, { newname:text,object_id:nodeid,type:nodetype,url:nodeurl });
    
                        }
    
                    } else {
    
                        Ext.Msg.alert(acs_lang_text.alert || "Alert",acs_lang_text.enter_new_name || "Please enter a new name.");
                        return false;
    
                    }
    
                }
            };
    
            Ext.Msg.show({
                title: acs_lang_text.rename || 'Rename',
                prompt: true,
                msg: acs_lang_text.enter_new_name || 'Please enter a new name for ... ',
                value: node.get("title"),
                buttons: Ext.Msg.OKCANCEL,
                scope:this,
                fn: handleRename
            });
    
            var prompt_text_el = YAHOO.util.Dom.getElementsByClassName('ext-mb-input', 'input'); 
            prompt_text_el[0].select();

        }

    },

    // tag a file

    tagFsitem : function(grid,i,e) {

        var filepanel = grid;
        var node =  filepanel.store.getAt(i);
        var object_id = node.get("id");
        var taglist = node.get("tags");
        var package_id = this.config.package_id;
        var tagcloudpanel = this.layout.findById("tagcloudpanel");
        var xmlhttpurl = this.xmlhttpurl;
        var tagWindow = this.tagWindow;

        var success = function() {
            node.data.tags = Ext.get('fstags').getValue();
            node.commit();
            tagcloudpanel.load({url:xmlhttpurl+'get-tagcloud',params:{package_id:package_id}});
            this.tagWindow.hide();
        }

        var failure = function(response) {
            Ext.Msg.alert(acs_lang_text.error || "Error","Sorry, we encountered an error.");
        }

        var savetags = function() {
            this.fsCore.doAction('tag',success, failure, null,{ object_id:node.id,package_id:package_id,tags:Ext.get('fstags').getValue()},this);
        }

        if(tagWindow == null) {

            var tagformBody = new Ext.Panel({
                id:'form_addtag',
                autoScroll:true,
                frame:true,
                html: "<div style='text-align:left;width:330px' class='yui-skin-sam'><p>Enter or edit one or more tags. Use commas (,) to separate the tags:<br ><br><div class='yui-ac'><input type='text' name='fstags' id='fstags' size='60' autocomplete='off' value='"+taglist+"'><div id='oAutoCompContainer1' class='yui-ac-container'></div></div>"
            });
    
            var tagBtns = [{
                    text: 'Ok',
                    icon:"/resources/ajaxhelper/icons/disk.png",
                    cls:"x-btn-text-icon",
                    scope:this
                },{
                    text: 'Cancel',
                    icon:"/resources/ajaxhelper/icons/cross.png",
                    cls:"x-btn-text-icon",
                    scope:this,
                    handler: function() { 
                        this.tagWindow.hide() 
                    }
            }];

            this.tagWindow = new Ext.Window({
                id:'tag-win',
                layout:'fit',
                width:450,
                height:200,
                title:"Tags",
                closeAction:'hide',
                modal:true,
                plain:true,
                autoScroll:false,
                resizable:false,
                items: tagformBody,
                buttons: tagBtns
            });

        }

        this.tagWindow.show('undefined',function() {
            Ext.get('fstags').dom.value=taglist;
            this.tagWindow.buttons[0].setHandler(savetags,this);
            this.initTagAutoComplete()
        },this);
    },

    initTagAutoComplete : function() {
        var oAutoComp1DS = new YAHOO.util.LocalDataSource(oAutoCompArr);
        if(document.getElementById("fstags")) {
            var oAutoComp1 = new YAHOO.widget.AutoComplete('fstags','oAutoCompContainer1', oAutoComp1DS);
            oAutoComp1.animHoriz=false;
            oAutoComp1.animVert=false;
            oAutoComp1.queryDelay=0;
            oAutoComp1.maxResultsDisplayed=10;
            oAutoComp1.useIFrame=true;
            oAutoComp1.delimChar=",";
            oAutoComp1.allowBrowserAutocomplete=false;
            oAutoComp1.typeAhead=true;
            oAutoComp1.useShadow=true;
            oAutoComp1.prehighlightClassName='yui-ac-prehighlight';
            oAutoComp1.formatResult=function(oResultItem, sQuery) { 
                var sMarkup=oResultItem[0]; 
                return sMarkup;
            }
        }
    },

    // download archive function
    downloadArchive : function(object_id) {
        if(object_id) {
            top.location.href=this.config.package_url+"download-archive/?object_id="+object_id;
        }
    },

    showShareOptions : function(grid,i,e) {

        var filepanel = grid;
        var node =  filepanel.store.getAt(i);
        var object_id = node.get("id");
        var foldertitle = node.get("title");
        var treepanel = this.layout.findById('treepanel');
        var package_id = this.config.package_id;
        var xmlhttpurl = this.xmlhttpurl;
        var shareWindow = this.sharefolderWindow;

        var sharesuccess = function() {
            var selectednode = treepanel.getSelectionModel().getSelectedNode();
            selectednode.loaded = false;
            selectednode.collapse();
            selectednode.fireEvent("click",selectednode);
            selectednode.expand();
            shareWindow.hide();
        }

        var failure = function(response) {
            Ext.Msg.alert("Error","Sorry, we encountered an error. Please try again later.");
        } 

        var sharefolder = function() {

            var target_folder_id = this.communityCombo.getValue();

            this.fsCore.doAction('sharefolder',sharesuccess, failure, null,{target_folder_id:target_folder_id,folder_id:object_id});

        }

        if(shareWindow == null) {

            var communities = new Ext.data.JsonStore({
                url: xmlhttpurl+'list-communities',
                root: 'communities',
                fields: ['target_folder_id', 'instance_name']
            });

            this.communityCombo = new Ext.form.ComboBox({
                id:'communities_list',
                store: communities,
                displayField:'instance_name',
                typeAhead: true,
                fieldLabel:'Community',
                triggerAction: 'all',
                emptyText:'Select a community',
                hiddenName:'target_folder_id',
                valueField:'target_folder_id',
                forceSelection:true,
                handleHeight: 80,
                selectOnFocus:true
            });

            var shareFormBody = new Ext.form.FormPanel({
                id:'sharefolderform',
                title:'Select the community where you wish to share the <b>'+foldertitle+'</b> folder with.',
                frame:true,
                items : this.communityCombo
            });
    
            var shareBtns = [{
                    text: 'Ok',
                    icon:"/resources/ajaxhelper/icons/disk.png",
                    cls:"x-btn-text-icon",
                    scope:this,
                    handler:sharefolder
                },{
                    text: 'Cancel',
                    icon:"/resources/ajaxhelper/icons/cross.png",
                    cls:"x-btn-text-icon",
                    scope:this,
                    handler: function(){shareWindow.hide()}
            }];

            shareWindow = new Ext.Window({
                id:'share-win',
                layout:'fit',
                width:380,
                height:200,
                title:"Share Folder",
                closeAction:'hide',
                modal:true,
                plain:true,
                autoScroll:false,
                resizable:false,
                items: shareFormBody,
                buttons: shareBtns
            });

            this.sharefolderWindow = shareWindow;

        } else {

            this.sharefolderWindow.findById('sharefolderform').setTitle('Select the community where you wish to share the <b>'+foldertitle+'</b> folder with.');
            this.communityCombo.reset();

        }

        shareWindow.show();

    },
    // redirect to object views for a file
    redirectViews : function(panel,i,e) {

        if(panel.id == "filepanel") {

            var filepanel = panel;
            var node =  filepanel.store.getAt(i);
            var object_id = node.get("id");

        } else {

            var object_id = i

        }

        window.open(window.location.protocol+"//"+window.location.hostname+"/o/"+object_id+"/info");
        window.focus();
    },

    // redirect to permissions
    redirectPerms : function(panel,i,e) {

        if(panel.id == "filepanel") {

            var filepanel = panel;
            var node = filepanel.store.getAt(i);
            var object_id = node.get("id");

        } else {

            var object_id = i;

        }

        var newwindow = window.open(window.location.protocol+"//"+window.location.hostname+":"+window.location.port+this.config.package_url+"permissions?object_id="+object_id+"&return_url="+window.location.pathname+"?package_id="+this.config.package_id+"&folder_id="+this.currentfolder);
        newwindow.focus();

    },

    // redirect to subscribe to notifications
    redirectNotifs : function(panel,i,e) {

        if(panel.id == "filepanel") {

            var filepanel = panel;
            var node = filepanel.store.getAt(i);
            var object_id = node.get("id");
            var pretty_name = node.get("title");

        } else {

            var treepanel = panel;
            var node = treepanel.getSelectionModel().getSelectedNode();
            var object_id = node.attributes["id"];
            var pretty_name = node.text;
        }

        window.location.href=this.xmlhttpurl+"notif-toggle?pretty_name="+pretty_name+"&object_id="+object_id+"&return_url="+this.config.package_url+"?folder_id="+this.currentfolder;

    },

    // redirect to file properties
    redirectProperties : function(grid,i,e) {
        var filepanel = grid;
        var node =  filepanel.store.getAt(i);
        var object_id = node.get("id");
        var newwindow = window.open(window.location.protocol+"//"+window.location.hostname+":"+window.location.port+this.config.package_url+"file?file_id="+object_id);
        newwindow.focus();
    },

    // show revisions window
    showRevisions : function(grid,i,e) {

        var filepanel = grid;
        var node =  filepanel.store.getAt(i);
        filepanel.getSelectionModel().selectRow(i);
        var object_id = node.get("id");
        var fstitle = node.get("filename");
        var revWindow = this.revisionsWindow;

        if(revWindow== null) {

            revWindow = new Ext.Window({
                id:'rev-win',
                layout:'fit',
                width:550,
                height:300,
                closeAction:'hide',
                modal:true,
                plain:true,
                items: new Ext.TabPanel({
                    id:'rev-tabs',
                    items: [this.createRevGrid(),this.newRevForm()]
                })
            });

            this.revisionsWindow = revWindow;

        }
        
        revWindow.setTitle(fstitle+' - '+acs_lang_text.properties || 'Properties');

        var revgrid = revWindow.findById("revisionspanel");
        var revtab = revWindow.findById("rev-tabs");
        var revform = revWindow.findById("rev-form");
        var package_id = this.config.package_id;

        revgrid.store.on("load",function() {
            this.getSelectionModel().selectFirstRow();
        },revgrid);

        revgrid.on("activate",function() {
            this.store.baseParams['file_id']=object_id;
            this.store.baseParams['package_id']=package_id;
            this.store.load();
        },revgrid);

        revWindow.on("beforehide",function() {
            this.activate(1);
        },revtab);

        revWindow.on("show",function() {
            this.activate(0);
        },revtab);

        revWindow.show();

    },

    // create the grid that shows the revisions for a file
    createRevGrid : function() {

       var cols = [ {header: "", width: 30, sortable:false, dataIndex:'icon'},
                    {header: "Title", width: 180, sortable:false, dataIndex:'title'},
                    {header: "Author", sortable:false, dataIndex:'author'},
                    {header: "Size", sortable:false, dataIndex:'size'},
                    {header: "Last Modified", sortable:false, dataIndex:'lastmodified'}];

       var reader = new Ext.data.JsonReader(
                    {totalProperty: 'total', root: 'revisions', id: 'revision_id'}, [
                    {name:'revision_id', type: 'int'},
                    {name:'icon'},
                    {name:'title'},
                    {name:'author'},
                    {name:'type'},
                    {name:'size'},
                    {name:'url'},
                    {name:'lastmodified'}] );

        var proxy = new Ext.data.HttpProxy( {
                        url : this.xmlhttpurl+ 'get-filerevisions'
                    } );

        var colModel = new Ext.grid.ColumnModel(cols);

        var dataModel = new Ext.data.Store({proxy: proxy, reader: reader});

        var toolbar = [
            {
                text:"Download",
                tooltip:"Download this revision",
                icon:"/resources/ajaxhelper/icons/arrow_down.png",
                cls:"x-btn-text-icon",
                scope:this,
                handler: function() {
                    var grid = this.revisionsWindow.findById("revisionspanel");
                    var record = grid.getSelectionModel().getSelected();
                    window.open(record.get("url"));
                    window.focus();
                }
            }, {
                text:"Delete",
                tooltip:"Delete this revision",
                icon:"/resources/ajaxhelper/icons/delete.png",
                cls:"x-btn-text-icon",
                scope:this,
                handler: function() { 
                    var grid = this.revisionsWindow.findById("revisionspanel");
                    var sm = grid.getSelectionModel();
                    var record = sm.getSelected();
                    var version_id = record.get("revision_id");
                    var fstitle = record.get("title");
                    if(grid.store.getCount()==1) {
                        Ext.Msg.alert("Warning","Sorry, you can not delete the only revision for this file. You can delete the file instead");
                    } else {
                        Ext.Msg.confirm('Delete','Are you sure you want to delete this version of '+fstitle+' ? This action can not be reversed.',function(btn) {
                            if(btn=="yes") {
                                var success = function(o) {
                                    sm.selectPrevious();
                                    grid.store.remove(record);
                                }
                                var failure = function() {
                                    Ext.Msg.alert('Delete Error','Sorry an error occurred. Please try again later.')
                                }
                                this.fsCore.doAction('delete-revision',success, failure, null,{version_id:version_id});
                            }
                        },this)
                    }
                }
            }
        ];

        var gridpanel = new Ext.grid.GridPanel( {
            store: dataModel,
            cm: colModel,
            sm:new Ext.grid.RowSelectionModel({singleSelect:true}),
            id:'revisionspanel',
            title:"Revisions",
            loadMask:true,
            tbar:toolbar
        });

        return gridpanel;
    },

    // create the form to upload a new revision
    newRevForm : function() {
        var msg1 = "Please choose a file to upload";
        var panel = new Ext.Panel({
            id:'rev-form',
            align:'left',
            frame:true,
            title:'New Revision',
            html: "<form id=\"newrevfileform\" name=\"newrevfileform\" method=\"post\" enctype=\"multipart/form-data\"><input type=\"hidden\" name=\"package_id\" value=\""+this.config.package_id+"\"><input type=\"hidden\" name=\"file_id\" id=\"rev_file_id\" value=\"\"><input type=\"hidden\" name=\"title\" id=\"rev_file_title\" value=\"\"><p>"+msg1+"<br /><br /><input type=\"file\" name=\"upload_file\" size='35' id=\"rev_upload_file\"></p></form>",
            buttons: [ {
                text:"Upload New Revision",
                handler: function(button) {

                    if(Ext.get("rev_upload_file").dom.value=="") {

                        Ext.Msg.alert("Warning","Please choose a file to upload");

                    } else {
                        var grid = this.layout.findById('filepanel');
                        var selectedRow = grid.getSelectionModel().getSelected();
                        Ext.get("rev_file_id").dom.value = selectedRow.get("id");
                        Ext.get("rev_file_title").dom.value = selectedRow.get("title");

                        var callback = {
                            success: function() {
                            }, upload: function() {
                                this.revisionsWindow.findById("rev-tabs").activate(0);
                                Ext.get("newrevfileform").dom.reset();
                                this.revisionsWindow.findById("rev-form").body.unmask();
                                button.enable();
                            }, failure: function() {
                                Ext.Msg.alert(acs_lang_text.error || "Error", acs_lang_text.upload_failed || "Upload failed, please try again later.");
                                this.revisionsWindow.findById("rev-form").body.unmask();
                                button.enable();
                            }, scope: this
                        }
            
                        this.revisionsWindow.findById("rev-form").body.mask("<center><img src='/resources/ajaxhelper/images/indicator.gif'><br>Uploading new revision. Please wait</center>");
                        button.disable();
            
                        YAHOO.util.Connect.setForm("newrevfileform", true, true);
            
                        var cObj = YAHOO.util.Connect.asyncRequest("POST", this.xmlhttpurl+"add-filerevision", callback);
                    }
                }.createDelegate(this),
                icon:"/resources/ajaxhelper/icons/arrow_up.png",
                cls:"x-btn-text-icon"
            } ]
        });
        return panel;
    },

    // generates a url to the currently selected file storage item
    // if it's a file : download
    // if it's a folder : append folder_id to the current url
    copyLink : function(panel,i,e) {

        if(panel.id == "treepanel") {

            if(window.location.port!="") { var port = ":"+window.location.port } else { var port = "" }
            var copytext = window.location.protocol+"//"+window.location.hostname+port+this.config.package_url+"?package_id="+this.config.package_id+"&folder_id="+i;

        } else {

            var filepanel = panel;
            var node = filepanel.store.getAt(i);
            var nodetype = node.get("type");
            if (nodetype === "folder") {
                // generate the url to a folder
                var copytext = window.location.protocol+"//"+window.location.hostname+":"+window.location.port+this.config.package_url+"?package_id="+this.config.package_id+"&folder_id="+node.get("id");
            } else if (nodetype === "url") {
                var copytext = node.get("url");
            } else {
                var copytext = window.location.protocol+"//"+window.location.hostname+node.get("url");
            }
        }

        if(Ext.isIE) {
            window.clipboardData.setData("text",copytext);
        } else {
            var copyprompt = Ext.Msg.show({
                title: acs_lang_text.linkaddress || 'Copy Link Address',
                prompt: true,
                msg: acs_lang_text.copyhighlighted || 'Copy the highlighted text to your clipboard.',
                value: copytext,
                buttons: Ext.Msg.OK
            });
            var prompt_text_el = YAHOO.util.Dom.getElementsByClassName('ext-mb-input', 'input');
            prompt_text_el[0].select();
        }
    }

}