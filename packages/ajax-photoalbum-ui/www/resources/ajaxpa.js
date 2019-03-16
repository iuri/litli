/*

    Ajax Photo Album UI
    @author Hamilton Chua (ham@solutiongrove.com)
    @creation-date 2007-11-18

*/

Ext.namespace('paCore');
Ext.namespace('ajaxpa');
Ext.BLANK_IMAGE_URL = '/resources/ajaxhelper/ext2/resources/images/default/s.gif';

/******** Photo Album Core Functions ***********/

paCore = function(package_id,xmlhttpurl,packageurl) {
    this.package_id = package_id;
    this.xmlhttpurl = xmlhttpurl;
    this.packageurl = packageurl;
}

paCore.prototype = {

    createTreeloader : function() {
        var treeloader = new Ext.tree.TreeLoader({ 
            dataUrl:this.xmlhttpurl+'load-treenodes',
            baseParams: { package_id:this.package_id }
        })
        return treeloader
    },

    createPhotoStore : function(scope) {
        var store = new Ext.data.JsonStore({
            url : scope.xmlhttpurl + 'get-photos',
            totalProperty: 'totalPhotos',
            root : 'photos',
            id:'photo_id',
            fields:[
                {name:'photo_id',type:'int'},
                {name:'view_image_id',type:'int'},
                {name:'thumb_photo_id',type:'int'},
                {name:'caption'},
                {name:'shortcaption'},
                {name:'path'},
                {name:'story'},
                {name:'fullimage_path'},
                {name:'shadowbox'}
            ]
        })
        return store;
    },

    // do a form submit for a given action
    formSubmit : function(action, extform, waitmsg, params, reset, success, failure, scope) {

        switch(action) {
            case 'addfolder':
                var url = this.packageurl+"folder-add"
            break;
            case 'editfolder':
                var url = this.packageurl+"folder-edit"
            break;
            case 'addalbum':
                var url = this.packageurl+"album-add"
            break;
            case 'editalbum':
                var url = this.packageurl+"album-edit"
            break;
            case 'editphoto':
                var url = this.packageurl+"photo-edit"
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
            case 'deletefolder':
                url = this.packageurl + 'folder-delete';
            break;
            case 'deletealbum':
                url = this.packageurl + 'album-delete';
            break;
            case 'deletephoto':
                url = this.packageurl + 'photo-delete';
            break;
            case 'getonephoto':
                url = this.xmlhttpurl + 'get-onephoto';
            break;
            case 'getnextobjid':
                url = this.xmlhttpurl + 'nextobjid';
            break;
            case 'movephoto':
                url = this.xmlhttpurl + 'move-photos';
            break;
            case 'movenode':
                url = this.xmlhttpurl + 'move-node';
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

/******** Create a DragZone instance for our JsonView *************/

ImageDragZone = function(view, config){
    this.view = view;
    ImageDragZone.superclass.constructor.call(this, view.getEl(), config);
};
Ext.extend(ImageDragZone, Ext.dd.DragZone, {
    // We don't want to register our image elements, so let's 
    // override the default registry lookup to fetch the image 
    // from the event instead
    getDragData : function(e){
        var target = e.getTarget('.thumb-wrap');
        if(target){
            var view = this.view;
            if(e.ctrlKey == false) {
                if(!view.isSelected(target)){
                    view.onClick(e);
                }
            }
            var selNodes = view.getSelectedNodes();
            var dragData = {
                nodes: selNodes
            };

            if(selNodes.length == 1){
                dragData.ddel = target.firstChild;
                dragData.single = true;
            }else{
                var div = document.createElement('div'); // create the multi element drag "ghost"
                div.className = 'multi-proxy';
                for(var i = 0, len = selNodes.length; i < len; i++){
                    var proxy_node = selNodes[i].firstChild.cloneNode(true);
                    Ext.get(proxy_node).setSize(50,50,false);
                    div.appendChild(proxy_node); // image nodes only
                    if((i+1) % 3 == 0){
                        div.appendChild(document.createElement('br'));
                    }
                }
                var count = document.createElement('div'); // selected image count
                count.innerHTML = i + ' images selected';
                Ext.get(count).setStyle('clear','both');
                div.appendChild(count);
                
                dragData.ddel = div;
                dragData.multi = true;
            }
            return dragData;
        }
        return false;
    },

    // this method is called by the TreeDropZone after a node drop
    // to get the new tree node (there are also other way, but this is easiest)
    getTreeNode : function(){
        var treeNodes = [];
        var nodeData = this.view.getRecords(this.dragData.nodes);
        for(var i = 0, len = nodeData.length; i < len; i++){
            var data = nodeData[i].data;
            treeNodes.push(new Ext.tree.TreeNode({
                text: data.name,
                icon: '../view/'+data.url,
                data: data,
                leaf:true,
                cls: 'image-node'
            }));
        }
        return treeNodes;
    },
    
    // the default action is to "highlight" after a bad drop
    // but since an image can't be highlighted, let's frame it 
    afterRepair:function(){
        for(var i = 0, len = this.dragData.nodes.length; i < len; i++){
            Ext.fly(this.dragData.nodes[i]).frame('#8db2e3', 1);
        }
        this.dragging = false;    
    },
    
    // override the default repairXY with one offset for the margins and padding
    getRepairXY : function(e){
        if(!this.dragData.multi){
            var xy = Ext.Element.fly(this.dragData.ddel).getXY();
            xy[0]+=3;xy[1]+=3;
            return xy;
        }
        return false;
    }
});


/***  ajaxpa class ****************/

ajaxpa = function(configObj) {

    // ****** properties ********

    this.config = null;
    this.layout = null;
    this.xmlhttpurl = '/ajaxpa/xmlhttp/';
    this.shadowbox_gallery = [];

    this.genericErrorFn = function() {
        Ext.Msg.alert('Error','Sorry, an error occurred. Please try again later.');
    }

    this.restore_window = function() {
        window.focus();
        this.refreshTreenode();
    }


    // ****** initialize ********

    this.initObj = function() {

        // prevent users from dropping stuff into this page
        //  this will prevent users from accidentally loading images when trying to drag and drop images for upload
        if(!Ext.isIE) { window.addEventListener('dragdrop', function(event) { event.stopPropagation() }, false) }
        if(Ext.isSafari) { window.addEventListener('dragover', function(event) { event.returnValue=false; }, false) }

        if(configObj) { 
            this.config = configObj;
            if(this.config.xmlhttpurl) {
                this.xmlhttpurl = this.config.xmlhttpurl;
            }
        }


        if (this.config.user_id != 0) {

            this.thumbTemplate = new Ext.XTemplate(
                '<tpl for=".">',
                '<div class="thumb-wrap" id="wrap{photo_id}">',
                '<div class="thumb" id="thumb{photo_id}" style="width:150px;height:110px;background:url({path}) no-repeat center center" ',
                '<tpl if="story">',
                'ext:qtip="{story}"',
                '</tpl>',
                '></div>',
                '<div id="caption-{photo_id}" class="img_caption" ext:qtip="{caption}">{shortcaption}</div>',
                '<div id="tools-{photo_id}" class="img_tools" style="visibility:hidden">',
                '<img id="view-{photo_id}" ext:qtip="View Photo" class="img_view" src="/resources/ajaxhelper/icons/magnifier.png" border=0 />&nbsp;',
                '<img id="downoad-{photo_id}" ext:qtip="Download Photo" class="img_download" src="/resources/ajaxhelper/icons/arrow_down.png" border=0 />&nbsp;',
                '<img id="edit-{photo_id}" ext:qtip="Edit Properties" class="img_edit" src="/resources/ajaxhelper/icons/image_edit.png" border=0 />&nbsp;',
                '<img id="delete-{photo_id}" ext:qtip="Delete" class="img_delete"src="/resources/ajaxhelper/icons/cross.png" border=0 />',
                '</div></div>',
                '</tpl>',
                '<div class="x-clear"></div>'
            )
    
        } else {

            this.thumbTemplate = new Ext.XTemplate(
                '<tpl for=".">',
                '<div class="thumb-wrap" id="wrap{photo_id}">',
                '<div class="thumb" id="thumb{photo_id}" style="width:150px;height:110px;background:url({path}) no-repeat center center" ',
                '<tpl if="story">',
                'ext:qtip="{story}"',
                '</tpl>',
                '></div>',
                '<div id="caption-{photo_id}" class="img_caption" ext:qtip="{caption}">{shortcaption}</div>',
                '<div id="tools-{photo_id}" ext:qtip="View Photo" class="img_tools" style="visibility:hidden;text-align:right">',
                '<img id="view-{photo_id}" ext:qtip="Download Photo" class="img_download" src="/resources/ajaxhelper/icons/magnifier.png" border=0 />',
                '</div></div>',
                '</tpl>',
                '<div class="x-clear"></div>'
            )

        }

        // instantiate core object with access to back-end functions
        this.paCore = new paCore(this.config.package_id, this.xmlhttpurl, this.config.package_url);

        this.photoStore = this.paCore.createPhotoStore(this);

        this.photoStore.on('load',function(store,records) {
            this.shadowbox_gallery = [];
            for (var x=0; x<records.length; x++) {
                this.shadowbox_gallery.push(records[x].get('shadowbox'));
            }
        },this);

        // initialize tooltips
        Ext.QuickTips.init();

        // initialize shadowbox
        Shadowbox.init({
            handleOversize:'drag',
            skipSetup:true
        });

        this.initLayout();
    }

    Ext.onReady(this.initObj,this,true);

}

ajaxpa.prototype = {

    // create the layout ui for ajaxpa

    initLayout : function() {

        /*  Load the UI in document.body if a layoutdiv is not provided */

        var layoutitems = [this.createCenter(),this.createNav()]

        if (this.config != null && this.config.layoutdiv) { 

            Ext.get(this.config.layoutdiv).setHeight(500,false);
            Ext.get(this.config.layoutdiv).update("");

            this.layout = new Ext.Panel({
                id:"pa-ui",
                layout:'border',
                applyTo:this.config.layoutdiv,
                monitorResize:true,
                items: layoutitems
            })

        } else {

            this.layout = new Ext.Viewport({
                id:"pa-ui",
                layout:'border',
                items: layoutitems
            });

        }

        var dragZone = new ImageDragZone(Ext.getCmp('pa-thumbsview-data'), {containerScroll:true,ddGroup: 'photosDD'});
    },

    // check permissions on current node (whether album or folder),
    //  return 1 if user is allowed 0 for not allowed
    checkPerms : function(type) {
        var currentTreenode = Ext.getCmp('pa-nav').getSelectionModel().getSelectedNode();
        if(type == "read") {
            return currentTreenode.attributes.attributes.read_p;
        } else {
            return currentTreenode.attributes.attributes.write_p;
        }
    },

    // create the tree navigation

    createNav : function() {

        var rootnode = new Ext.tree.AsyncTreeNode({text:this.config.rootfolder_name, expanded:true, id:this.config.rootfolder_id, attributes:{"type":"folder","read_p":this.config.root_read_p,"write_p":this.config.root_write_p}});


        var loader = this.paCore.createTreeloader();

        var newmenu = new Ext.menu.Menu({
            id:'newmenu',
            items:[
                {id:"menu_newfolder",text:acs_lang_text.folder || 'Folder',icon: '/resources/ajaxhelper/icons/folder.png', cls : 'x-btn-text-icon', handler:this.addTreenode.createDelegate(this,['folder']) },
                {id:"menu_newalbum",text:acs_lang_text.album || 'Album',icon: '/resources/ajaxhelper/icons/folder_picture.png', cls : 'x-btn-text-icon', handler:this.addTreenode.createDelegate(this,['album']) },
                {id:"menu_newphoto",text:acs_lang_text.photo || 'Photo',icon: '/resources/ajaxhelper/icons/picture.png', cls : 'x-btn-text-icon', handler:this.newPhoto, scope:this }
            ]
        });

        var panel = new Ext.tree.TreePanel({
            id:'pa-nav',
            region:'east',
            title:acs_lang_text.foldersandalbums || 'Folders & Albums',
            split:true,
            width: 250,
            monitorResize: true,
            minSize: 175,
            maxSize: 400,
            autoScroll:true,
            ddAppendOnly:true,
            animate:true,
            enableDD:true,
            ddGroup:'photosDD',
            collapsible:true,
            collapseMode:'mini',
            hideCollapseTool:true,
            containerScroll: true,
            tbar: [
                {text: acs_lang_text.newitem || 'New', icon: '/resources/ajaxhelper/icons/add.png', cls : 'x-btn-text-icon', menu:newmenu},
                {text: acs_lang_text.edititem || 'Edit', icon: '/resources/ajaxhelper/icons/page_white_edit.png', cls : 'x-btn-text-icon', handler:this.editTreenode, scope:this},
                {text: acs_lang_text.deleteitem || 'Delete', icon: '/resources/ajaxhelper/icons/delete.png', cls : 'x-btn-text-icon', handler:this.delTreenode, scope:this}
            ],
            loader: loader,
            root: rootnode,
            listeners:{
                "nodedragover":{
                    scope:this,
                    fn:function(e) {

                        // check if user has write permissions on the node
                        if(e.target.attributes.attributes.write_p==0) {
                            e.cancel=true;
                        }

                        // dragging a tree node

                        if(e.source.tree) {

                            // do not allow dropping of treenodes to albums
                            // an album can only have photos

                            if(e.target.attributes.attributes.type=="album") {
                                e.cancel=true;
                            }

                        }

                        // dragging a dataview item

                        if(e.source.view) {

                            // do not allow dropping to folders
                            // photos can only be dropped into albums

                            if(e.target.attributes.attributes.type=="folder") {
                                e.cancel=true;
                            }

                        }

                    }
                 },
                "nodedrop":{
                    scope:this,
                    fn:function(e) {

                        var params = {target_folder_id:e.target.id,item_id:e.data.node.id,type:e.data.node.attributes.attributes.type}
                        this.paCore.doAction('movenode',function() { },function() { },null,params,this);

                    }
                },
                "beforenodedrop":{
                    scope:this,
                    fn:function(e) {

                        // dragging a tree node

                        if(e.source.tree) {

                            // do not allow dropping of treenodes to albums
                            // an album can only have photos

                            if(e.target.attributes.attributes.type=="album") {
                                e.cancel=true;
                            }

                        }

                        // dragging a dataview item

                        if(e.source.view) {

                            e.cancel=true;

                            if(e.target.attributes.attributes.type=="album") {

                                e.dropStatus=true;

                                // NOTE : we need to handle the move here
                                // because nodedrop does not fire if you drop a photo

                                var image_ids = [];

                                for(var x=0;x<e.data.nodes.length;x++) {
                                    image_ids.push(e.data.nodes[x].id.substring(4,e.data.nodes[x].id.length));
                                }

                                var params = {target_album_id:e.target.id,image_ids:image_ids}

                                var success = function() {
                                    // reload the dataview
                                    this.photoStore.reload();
                                }

                                var failure = this.genericErrorFn;

                                this.paCore.doAction('movephoto',success,failure,null,params,this);
                            }

                        }
                    }
                }
            }

        });

        rootnode.on("expand",function() { panel.fireEvent("click",rootnode) } ,this,{single:true});

        panel.on("click",this.loadPhotos,this)
        panel.on("render",function() {
            if(this.config.user == 0) {
                panel.getTopToolbar().hide();
            }
        },this)

        newmenu.on("beforeshow",function() {
            var selectednode = panel.getSelectionModel().getSelectedNode();
            var type = selectednode.attributes.attributes.type;
            if(type == 'folder') {
                newmenu.items.items[0].enable();
                newmenu.items.items[1].enable();
                newmenu.items.items[2].disable();
            } else {
                newmenu.items.items[0].disable();
                newmenu.items.items[1].disable();
                newmenu.items.items[2].enable();
            }
        });

        return panel;

    },

    // create the photos dataview

    createCenter : function() {

        var tbar = [
                {text: acs_lang_text.collection || 'Add a collection of photos to this album' , icon: '/resources/ajaxhelper/icons/add.png', cls : 'x-btn-text-icon', handler:function() {

                    if(!this.checkPerms('write')) {
                        Ext.MessageBox.alert('Permission Denied','Sorry you do not have permission to perform this action.')
                        return;
                    }
                
                    var extwindow = this.createOrGetWindow('pa-win-newcollection');
                    var formname = 'new_photo_collection_form';
                    var currentform = Ext.getCmp(formname);
            
                    var successFn = function(o) {
            
                        Ext.getCmp('new_photo_collection_formid').setValue('photos_upload');
            
                        var album_id = this.getSelectedTreeNodeId();
            
                        Ext.getCmp('new_photo_collection_albumid').setValue(album_id);
                        Ext.getCmp('new_photo_collection_photoid').setValue(o.responseText);
            
                        // set the return_url
                        Ext.getCmp('new_photo_collection_returnurl').setValue(this.xmlhttpurl+'formok');
            
                        extwindow.show();
                    };
            
                    var submitFn = function() {
                        if (currentform.getForm().isValid()) {
                            currentform.getForm().submit({
                                url:this.config.package_url+'photos-add-2',
                                waitMsg:'Uploading photo...',
                                reset:true,
                                scope:this,
                                success: function(form,action) {
                                    if(action.result) {
                                        // reload center panel
                                        this.photoStore.reload();
                                        // hide the window
                                        extwindow.close();
            
                                    } else {
                                        Ext.MessageBox.alert('Error','Sorry an error occured. Make sure you have filled up all required fields.')
                                    }
                                },
                                failure: function(form,action) {
                                    if(action.result) {
                                        Ext.MessageBox.alert('Error',action.result.info) 
                                    } else { 
                                        Ext.MessageBox.alert('Error','Error occurred. Try again later') 
                                    } 
                                }
                            })
                        }
                    };
            
            
                    currentform.getForm().reset();
            
                    // change url to folder_edit
                    currentform.buttons[0].setHandler(submitFn,this);
                    currentform.buttons[0].setText('Upload');
            
                    // use ajax to get retrieve info about the album or folder
                    this.paCore.doAction('getnextobjid',successFn,this.genericErrorFn,null,null,this);

                }, scope:this}
            ]

        tbar.push({text:'Download selected Photos', tooltip:'Download selected photos. Press CTRL and then click on the photos you want to select',icon: '/resources/ajaxhelper/icons/arrow_down.png', cls : 'x-btn-text-icon', handler:function() {

            var selectednodes = Ext.getCmp('pa-thumbsview-data').getSelectedNodes();
    
            if(selectednodes.length<1) {
    
                Ext.Msg.alert('Error','Please select one or more photos to download');
    
            } else {
    
                var photoid_arr=[];

                for(var x=0;x<selectednodes.length;x++) {
                    photoid_arr.push(selectednodes[x].id.substring(4));
                }
    
                window.location.href='/ajaxpa/batchdownload/?photo_ids='+photoid_arr;
    
            }
        }, scope:this})

        var thumbspanel = new Ext.Panel({
            id:'pa-thumbsview',
            layout:'fit',
            plain:true,
            titlebar:false,
            tbar:tbar, bbar:new Ext.PagingToolbar({
                pageSize: parseInt(this.config.pagesize),
                displayInfo:true,
                emptyMsg:'No photos found',
                store:this.photoStore}),
            listeners: {
                'render': {
                    fn:function(panel) { 
                        panel.body.addListener('click',function(panel,e) {
                            var id_arr = e.id.split('-');
                            var id = id_arr[1];
                            switch (e.className) {
                                case "img_view":
                                    var record = this.photoStore.getById(id);
                                    var n = this.photoStore.indexOf(record);
                                    Shadowbox.open(this.shadowbox_gallery);
                                    Shadowbox.change(n);
                                break;
                                case "img_edit":
                                    this.editPhoto(id);
                                break;
                                case "img_delete":
                                    this.delPhoto(id);
                                break;
                                case "img_download":
                                    var record = this.photoStore.getById(id);
                                    window.location.href='/ajaxpa/download/'+record.get('view_image_id');
                                break;
                            }
                        },this)
                    },scope:this
                }
            }, items: new Ext.DataView({
                id:'pa-thumbsview-data',
                store:this.photoStore,
                tpl:this.thumbTemplate,
                style:'overflow:auto',
                overClass:'x-view-over',
                multiSelect:true,
                itemSelector:'div.thumb-wrap',
                loadingText:'<div class="largetext">Fetching photos . . .</div>',
                emptyText: '<div class="largetext">No photos found</div>',
                plugins: new Ext.DataView.DragSelector({dragSafe:true}),
                prepareData: function(data){
                    data.caption = Ext.util.Format.ellipsis(data.caption, 20);
                    return data;
                }, listeners: {
                    'mouseenter': {
                        fn:function(view,index,node,e) {
                            var id = Ext.get(node).id.substring(4,Ext.get(node).id.length);
                            Ext.get('tools-'+id).show();
                        },scope:this
                    }, 'mouseleave' : {
                        fn:function(view,index,node,e) {
                            var id = Ext.get(node).id.substring(4,Ext.get(node).id.length);
                            Ext.get('tools-'+id).hide();
                        },scope:this
                    }, 'dblclick' : {
                        fn:function(view,index,node,e) {
                            var id = Ext.get(node).id.substring(4,Ext.get(node).id.length);
                            var record = this.photoStore.getById(id);
                            var n = this.photoStore.indexOf(record);
                            Shadowbox.open(this.shadowbox_gallery);
                            Shadowbox.change(n);
                        },scope:this
                    }
                }
            })
        });

        var panel = new Ext.Panel({
            id:'pa-card',
            layout:'card',
            region:'center',
            activeItem:0,
            items: [
                {xtype:'panel',html:'<div class="largetext">Click on an album to view photos</div>'},
                thumbspanel
            ]
        });

        return panel;
    },

    // if the tree item is an album, load the photos

    loadPhotos : function(node,e) {

        // the current album we are in
        if(node.attributes.attributes.type == "album") {

            Ext.getCmp('pa-card').layout.setActiveItem(1);
            this.photoStore.baseParams={album_id:node.id,package_id:this.config.package_id};
            this.photoStore.load({params:{start:0,limit:parseInt(this.config.pagesize)}});

        } else {
            Ext.getCmp('pa-card').layout.setActiveItem(0);
        }

    },

    // reload the currently selected node

    refreshTreenode : function() {

        var currentTreenode = Ext.getCmp('pa-nav').getSelectionModel().getSelectedNode();
        currentTreenode.fireEvent("click",currentTreenode);

    },
    
    // delete a node from the tree
    
    delTreenode : function() {

        if(!this.checkPerms('write')) {
            Ext.MessageBox.alert('Permission Denied','Sorry you do not have permission to perform this action.')
            return;
        }
        
        var treepanel = Ext.getCmp('pa-nav');
        var currentTreenode = treepanel.getSelectionModel().getSelectedNode();
        var treenodeType = currentTreenode.attributes.attributes.type;

        if (treepanel.getRootNode().id == currentTreenode.id) {

            Ext.Msg.alert('Error','Sorry, you can not delete the root folder');

        } else {
    
            if (treenodeType === "folder") {
                var action = 'deletefolder';
                var params = { confirmed_p:'t', folder_id:currentTreenode.id, return_url:this.xmlhttpurl+'formok'};
            } 
    
            if (treenodeType === "album") {
                var action = 'deletealbum';
                var params = { confirmed_p:'t', album_id:currentTreenode.id, return_url:this.xmlhttpurl+'formok'};
            }

            var success = function(o) {
                var parentnode = currentTreenode.parentNode;
                parentnode.fireEvent("click",parentnode);
                parentnode.removeChild(currentTreenode);
            }

            var failure = this.genericErrorFn;
    
            if (action) {
                Ext.MessageBox.confirm('Delete','Are you sure you want to delete <b>'+currentTreenode.text+'</b> ?',function(choice) {
                    if (choice === "yes") {
                        this.paCore.doAction(action,success,failure,null,params,this);
                    }
                },this)
            }

        }
    },

    // add a folder or album to the tree

    addTreenode : function(nodetype) {

        if(!this.checkPerms('write')) {
            Ext.MessageBox.alert('Permission Denied','Sorry you do not have permission to perform this action.')
            return;
        }

        if(nodetype === "folder") {
            var windowid = 'pa-win-newfolder';
            var formname = 'new_folder_form';
            var formaction = 'addfolder';
            var windowtitle = acs_lang_text.newfolder || 'New Folder';
            var successFn = function(o) {

                Ext.getCmp('new_folder_formid').setValue('folder_add');
            
                // get the parent_id of this new folder
                // parent_id is the id of the currently selected node in the tree
                var parent_id = this.getSelectedTreeNodeId();

                // set the parent_id hidden field
                Ext.getCmp('new_folder_parentid').setValue(parent_id);
                
                // set the folder_id hidden field
                Ext.getCmp('new_folder_folderid').setValue(o.responseText);

                // set the return_url
                Ext.getCmp('new_folder_returnurl').setValue(this.xmlhttpurl+'load-onenode?type=folder&node_id='+o.responseText);
                
                // show the window
                extwindow.show();
                
            }
            var waitMsg = 'Creating folder';
        }

        if(nodetype === "album") {
            var windowid = 'pa-win-newalbum';
            var formname = 'new_album_form';
            var formaction = 'addalbum';
            var windowtitle = acs_lang_text.newalbum || 'New Album';
            var successFn=function(o) {
    
                Ext.getCmp('new_album_formid').setValue('album_add');
            
                // get the parent_id of this new folder
                // parent_id is the id of the currently selected node in the tree
                var parent_id = this.getSelectedTreeNodeId();
    
                // set the parent_id hidden field
                Ext.getCmp('new_album_parentid').setValue(parent_id);
                
                // set the folder_id hidden field
                Ext.getCmp('new_album_albumid').setValue(o.responseText);
    
                // set the return_url
                Ext.getCmp('new_album_returnurl').setValue(this.xmlhttpurl+'load-onenode?type=album&node_id='+o.responseText);
                
                // show the window
                extwindow.show();
                
            }
            var waitMsg = 'Creating album';
        }

        var extwindow = this.createOrGetWindow(windowid);
        var currentform = Ext.getCmp(formname);

        var success =function(form,action) { 
            if(action.result) {
        
                if(action.result.info != "null") {
                    // create and select the new tree node
                    this.addTreenodeEl(action.result.info);
                } else {
                    Ext.MessageBox.alert('Error','Sorry an error occured. Please try again later.')
                }
        
                // hide the window
                extwindow.hide();
        
            } else {
                Ext.MessageBox.alert('Error','Sorry an error occured. Make sure you have filled up all required fields.')
            }
        }

        var failure = function(form,action) { 
                if(action.result) {
                    Ext.MessageBox.alert('Error',action.result.info) 
                } else { 
                    Ext.MessageBox.alert('Error','Error occurred. Try again later') 
                } 
        }

        var submitFn=function() {
            this.paCore.formSubmit(formaction, currentform.getForm(), waitMsg, null, true, success, failure, this)
        }


        if(extwindow) {

            extwindow.setTitle(windowtitle);

            currentform.buttons[0].setHandler(submitFn,this)
            currentform.buttons[0].setText('Create');

            // use ajax to get a new object_id, before we show the window
            this.paCore.doAction('getnextobjid',successFn,this.genericErrorFn,null,null,this);

        }

    },
    
    // add a node with the given json object properties to the tree
    
    addTreenodeEl : function(configobj) {
        var treepanel =Ext.getCmp('pa-nav');
        var currentTreeNode = treepanel.getSelectionModel().getSelectedNode();
        var nodespec = new Ext.tree.TreeNode(configobj);
        var newnode = currentTreeNode.appendChild(nodespec);
        treepanel.getSelectionModel().select(newnode);
        newnode.loaded=true;
        newnode.fireEvent("click",newnode);
    },

    // window to edit folder info

    editTreenode : function() {

        if(!this.checkPerms('write')) {
            Ext.MessageBox.alert('Permission Denied','Sorry you do not have permission to perform this action.')
            return;
        }

        var currentTreenode = Ext.getCmp('pa-nav').getSelectionModel().getSelectedNode();

        if (currentTreenode) {

            var treenodeType = currentTreenode.attributes.attributes.type;
            var treenodeId = currentTreenode.id;
    
            if (treenodeType === "folder") {
    
                var windowid = 'pa-win-newfolder';
                var formname = 'new_folder_form';
                var windowtitle = acs_lang_text.editfolder || 'Edit Folder';
                var formaction = 'editfolder';
                var successFn = function(o) {
                    var resultObj = Ext.decode(o.responseText);
                    if(resultObj.success) {
                        Ext.getCmp('new_folder_formid').setValue('folder_edit');
                        Ext.getCmp('new_folder_folderid').setValue(resultObj.info.id);
                        Ext.getCmp('new_folder_name').setValue(resultObj.info.text);
                        Ext.getCmp('new_folder_desc').setValue(resultObj.info.qtip);
                        Ext.getCmp('new_folder_returnurl').setValue(this.xmlhttpurl+'load-onenode?type=folder&node_id='+resultObj.info.id);
                        extwindow.show();
                    }
                }
                var waitMsg = 'Updating folder ...';
            }

            if (treenodeType === "album") {

                var windowid = 'pa-win-newalbum';
                var formname = 'new_album_form';
                var windowtitle = acs_lang_text.editalbum || 'Edit Album';
                var formaction = 'editalbum';
                var successFn = function(o) {
                    var resultObj = Ext.decode(o.responseText);
                    if(resultObj.success) {
                        Ext.getCmp('new_album_formid').setValue('edit_album');
                        Ext.getCmp('new_album_albumid').setValue(resultObj.info.id);
                        Ext.getCmp('new_album_name').setValue(resultObj.info.text);
                        Ext.getCmp('new_album_desc').setValue(resultObj.info.qtip);
                        Ext.getCmp('new_album_story').setValue(resultObj.info.attributes.story);
                        Ext.getCmp('new_album_photographer').setValue(resultObj.info.attributes.photographer);
                        Ext.getCmp('new_album_revisionid').setValue(resultObj.info.attributes.revision_id);
                        Ext.getCmp('new_album_prevrevisionid').setValue(resultObj.info.attributes.previous_revision);
                        Ext.getCmp('new_album_returnurl').setValue(this.xmlhttpurl+'load-onenode?type=album&node_id='+resultObj.info.id);
                        extwindow.show();
                    }
                }
                var waitMsg = 'Updating album ...';
            }

            var extwindow = this.createOrGetWindow(windowid);
            var currentform = Ext.getCmp(formname);

            var success = function(form,action) { 
                if(action.result) {

                    if(action.result.info != "null") {
                        // create and select the new tree node
                        this.editTreenodeEl(action.result.info);
                    } else {
                        Ext.MessageBox.alert('Error','Sorry an error occured updating. Please try again later.')
                    }

                    // hide the window
                    extwindow.hide();

                } else {
                    Ext.MessageBox.alert('Error','Sorry an error occured. Make sure you have filled up all required fields.')
                }
            }

            var failure = function(form,action) { 
                if(action.result) {
                    Ext.MessageBox.alert('Error',action.result.info) 
                } else { 
                    Ext.MessageBox.alert('Error','Error occurred. Try again later') 
                } 
            }

            var submitFn=function() {
                this.paCore.formSubmit(formaction, currentform.getForm(), waitMsg, null, true, success, failure, this)
            }

            if(extwindow) {
    
                // change window title to edit
                extwindow.setTitle(windowtitle);

                // change url to folder_edit
                currentform.buttons[0].setHandler(submitFn,this);
                currentform.buttons[0].setText('Update');
        
                // use ajax to get retrieve info about the album or folder
                Ext.Ajax.request({
                    url: this.config.xmlhttpurl + 'load-onenode',
                    params: {type:treenodeType,node_id:treenodeId,mode:'edit'},
                    success: successFn, failure: this.genericErrorFn ,scope: this
                });
    
            }

        } else {
            Ext.Msg.alert('Error','Please select a folder or album');
        }

    },

    // edit the node

    editTreenodeEl : function(configobj) {
        var currentTreeNode = Ext.getCmp('pa-nav').getSelectionModel().getSelectedNode();
        currentTreeNode.setText(configobj.text);
        currentTreeNode.ui.getTextEl().setAttributeNS('ext','qtip',configobj.qtip);
    },
    
    // return the id of the selected treenode
    
    getSelectedTreeNodeId : function() {
        var id = Ext.getCmp('pa-nav').getSelectionModel().getSelectedNode().id;
        return id
    },

    // create or get a reference to a popup window

    createOrGetWindow : function(windowid) {

        var extwindow = Ext.getCmp(windowid);

        if(!extwindow) {

            switch (windowid) {

                case "pa-win-newcollection":

                    extwindow = new Ext.Window({
                        id:'pa-win-newphotocollection',
                        title:acs_lang_text.collection || 'Add a collection of photos to this album',
                        width:290,
                        height:140,
                        autoScroll:true,
                        modal:true,
                        draggable:false,
                        resizable:false,
                        items:[
                            {id:'new_photo_collection_form',
                                xtype:'form',
                                titlebar:false,
                                plain:true,
                                autoHeight:true,
                                bodyStyle:{'padding':'5px'},
                                labelAlign:'top',
                                method:'post',
                                fileUpload:true,
                                items:[
                                    {id:'new_photo_collection_formid',xtype:'hidden',name:'form:id',value:'photos_upload'},
                                    {id:'new_photo_collection_formode',xtype:'hidden',name:'form:mode',value:'edit'},
                                    {id:'new_photo_collection_returnurl',xtype:'hidden',name:'return_url',value:''},
                                    {id:'new_photo_collection_photoid',xtype:'hidden',name:'photo_id',value:''},
                                    {id:'new_photo_collection_albumid',xtype:'hidden',name:'album_id',value:''},
                                    {id:'new_photo_collection_file',
                                        xtype:'fileuploadfield',
                                        name:'upload_file',
                                        fieldLabel:'Choose a tar or zip file to upload',
                                        allowBlank:false,
                                        anchor:'95%',
                                        buttonCfg: {
                                            text: '',
                                            iconCls: 'upload-icon'
                                        }
                                    }],
                                buttons: [{
                                    text: 'Upload',
                                    name:'formbutton:ok',
                                    scope:this,
                                    icon:'/resources/ajaxhelper/icons/accept.png',
                                    cls:'x-btn-text-icon'
                                }, {
                                    text: 'Close',
                                    handler: function(){
                                        Ext.getCmp('new_photo_collection_form').getForm().reset();
                                        Ext.getCmp('pa-win-newphotocollection').close();
                                    },scope:this,
                                    icon:'/resources/ajaxhelper/icons/cross.png',
                                    cls:'x-btn-text-icon'
                            }]}
                            ]
                        })

                break;

                case "pa-win-newphoto" :

                    extwindow = new Ext.Window({
                        id:'pa-win-newphoto',
                        title:acs_lang_text.uploadphoto || 'Upload a New Photo',
                        width:290,
                        height:360,
                        autoScroll:true,
                        closeAction:'hide',
                        modal:true,
                        draggable:false,
                        resizable:false,
                        items:[
                            {id:'new_photo_form',
                                xtype:'form',
                                titlebar:false,
                                plain:true,
                                autoHeight:true,
                                bodyStyle:{'padding':'5px'},
                                labelAlign:'top',
                                method:'post',
                                fileUpload:true,
                                items:[
                                    {id:'new_photo_formid',xtype:'hidden',name:'form:id',value:'photo_upload'},
                                    {id:'new_photo_formode',xtype:'hidden',name:'form:mode',value:'edit'},
                                    {id:'new_photo_returnurl',xtype:'hidden',name:'return_url',value:''},
                                    {id:'new_photo_photoid',xtype:'hidden',name:'photo_id',value:''},
                                    {id:'new_photo_albumid',xtype:'hidden',name:'album_id',value:''},
                                    {id:'new_photo_file',
                                        xtype:'fileuploadfield',
                                        name:'upload_file',
                                        fieldLabel:'Photo',
                                        allowBlank:false,
                                        emptyText:'Choose a photo to upload',
                                        anchor:'95%',
                                        buttonCfg: {
                                            text: '',
                                            iconCls: 'upload-icon'
                                        }
                                    },
                                    {id:'new_photo_caption',xtype:'textfield',name:'caption',fieldLabel:'Caption',width:220},
                                    {id:'new_photo_desc',xtype:'textarea',name:'description',fieldLabel:'Description',width:220},
                                    {id:'new_photo_story',xtype:'textarea',name:'story',fieldLabel:'Story',width:220}],
                                buttons: [{
                                    text: 'Upload',
                                    name:'formbutton:ok',
                                    scope:this,
                                    icon:'/resources/ajaxhelper/icons/accept.png',
                                    cls:'x-btn-text-icon'
                                }, {
                                    text: 'Close',
                                    handler: function(){
                                        Ext.getCmp('new_photo_form').getForm().reset();
                                        Ext.getCmp('pa-win-newphoto').hide();
                                    },scope:this,
                                    icon:'/resources/ajaxhelper/icons/cross.png',
                                    cls:'x-btn-text-icon'
                                }]}
                        ]
                    });

                break;

                case "pa-win-editphoto" :

                    extwindow = new Ext.Window({
                        id:'pa-win-editphoto',
                        title:acs_lang_text.editphoto || 'Edit Photo Attributes',
                        width:290,
                        height:360,
                        autoScroll:true,
                        closeAction:'hide',
                        modal:true,
                        draggable:false,
                        resizable:false,
                        listeners:{
                            "show":{
                                scope:this,
                                fn:function() {
                                    Ext.getCmp('edit_photo_title').focus(false,10);
                                }
                            }
                        },
                        items:[
                            {id:'edit_photo_form',
                                xtype:'form',
                                titlebar:false,
                                plain:true,
                                autoHeight:true,
                                bodyStyle:{'padding':'5px'},
                                labelAlign:'top',
                                method:'post',
                                items:[
                                    {id:'edit_photo_formid',xtype:'hidden',name:'form:id',value:'edit_photo'},
                                    {id:'edit_photo_formode',xtype:'hidden',name:'form:mode',value:'edit'},
                                    {id:'edit_photo_returnurl',xtype:'hidden',name:'return_url',value:''},
                                    {id:'edit_photo_photoid',xtype:'hidden',name:'photo_id',value:''},
                                    {id:'edit_photo_revisionid',xtype:'hidden',name:'revision_id',value:''},
                                    {id:'edit_photo_prevrevisionid',xtype:'hidden',name:'previous_revision',value:''},
                                    {id:'edit_photo_title',xtype:'textfield',name:'title',fieldLabel:'Title',width:220},
                                    {id:'edit_photo_caption',xtype:'textfield',name:'caption',fieldLabel:'Caption',width:220},
                                    {id:'edit_photo_desc',xtype:'textarea',name:'description',fieldLabel:'Description',width:220},
                                    {id:'edit_photo_story',xtype:'textarea',name:'story',fieldLabel:'Story',width:220}],
                                buttons: [{
                                    text: 'Update',
                                    name:'formbutton:ok',
                                    scope:this,
                                    icon:'/resources/ajaxhelper/icons/accept.png',
                                    cls:'x-btn-text-icon'
                                }, {
                                    text: 'Close',
                                    handler: function(){
                                        Ext.getCmp('edit_photo_form').getForm().reset();
                                        Ext.getCmp('pa-win-editphoto').hide();
                                    },scope:this,
                                    icon:'/resources/ajaxhelper/icons/cross.png',
                                    cls:'x-btn-text-icon'
                                }]}
                        ]
                    });

                break;
    
                case "pa-win-newfolder":

                    extwindow = new Ext.Window({
                        id:'pa-win-newfolder',
                        title: acs_lang_text.newfolder || 'New Folder',
                        width:290,
                        height:220,
                        autoScroll:true,
                        closeAction:'hide',
                        modal:true,
                        draggable:false,
                        resizable:false,
                        items:[
                            {id:'new_folder_form',
                                xtype:'form',
                                titlebar:false,
                                plain:true,
                                autoHeight:true,
                                bodyStyle:{'padding':'5px'},
                                labelAlign:'top',
                                method:'post',
                                items:[
                                    {id:'new_folder_name',xtype:'textfield',name:'label',fieldLabel:'Folder Name',width:220,allowBlank:false},
                                    {id:'new_folder_desc',xtype:'textarea',name:'description',fieldLabel:'Folder Description',width:220},
                                    {id:'new_folder_formid',xtype:'hidden',name:'form:id',value:'folder_add'},
                                    {id:'new_folder_formode',xtype:'hidden',name:'form:mode',value:'edit'},
                                    {id:'new_folder_returnurl',xtype:'hidden',name:'return_url',value:''},
                                    {id:'new_folder_folderid',xtype:'hidden',name:'folder_id',value:''},
                                    {id:'new_folder_parentid',xtype:'hidden',name:'parent_id',value:''}],
                                buttons: [{
                                    text: 'Create Folder',
                                    name:'formbutton:ok',
                                    scope:this,
                                    icon:'/resources/ajaxhelper/icons/accept.png',
                                    cls:'x-btn-text-icon'
                                }, {
                                    text: 'Close',
                                    handler: function(){
                                        Ext.getCmp('new_folder_form').getForm().reset();
                                        Ext.getCmp('pa-win-newfolder').hide();
                                    },scope:this,
                                    icon:'/resources/ajaxhelper/icons/cross.png',
                                    cls:'x-btn-text-icon'
                                }]}
                        ],listeners:{
                            "show":{
                                scope:this,
                                fn:function() {
                                    Ext.getCmp('new_folder_name').focus(false,10);
                                }
                            }
                        }
                    });
    
                break;

                case "pa-win-newalbum":

                    extwindow = new Ext.Window({
                        id:'pa-win-newalbum',
                        title:acs_lang_text.newalbum || 'New Abum',
                        width:290,
                        autoHeight:true,
                        autoScroll:true,
                        closeAction:'hide',
                        modal:true,
                        draggable:false,
                        resizable:false,
                        listeners:{
                        "show":{
                                scope:this,
                                fn:function() {
                                    Ext.getCmp('new_album_name').focus(false,10);
                                }
                            }
                        }, items:[
                            {id:'new_album_form',
                                xtype:'form',
                                titlebar:false,
                                plain:true,
                                autoHeight:true,
                                bodyStyle:{'padding':'5px'},
                                labelAlign:'top',
                                method:'post',
                                items:[
                                    {id:'new_album_name',xtype:'textfield',name:'title',fieldLabel:'Album Name',width:220,allowBlank:false},
                                    {id:'new_album_photographer',xtype:'textfield',name:'photographer',fieldLabel:'Photographer',width:220},
                                    {id:'new_album_desc',xtype:'textarea',name:'description',fieldLabel:'Description',width:220},
                                    {id:'new_album_story',xtype:'textarea',name:'story',fieldLabel:'Album Story',width:220},
                                    {id:'new_album_formid',xtype:'hidden',name:'form:id',value:'album_add'},
                                    {id:'new_album_formmode',xtype:'hidden',name:'form:mode',value:'edit'},
                                    {id:'new_album_returnurl',xtype:'hidden',name:'return_url',value:''},
                                    {id:'new_album_albumid',xtype:'hidden',name:'album_id',value:''},
                                    {id:'new_album_revisionid',xtype:'hidden',name:'revision_id',value:''},
                                    {id:'new_album_prevrevisionid',xtype:'hidden',name:'previous_revision',value:''},
                                    {id:'new_album_parentid',xtype:'hidden',name:'parent_id',value:''}],
                                buttons: [{
                                    text: 'Create Album',
                                    name:'formbutton:ok',
                                    scope:this,
                                    icon:'/resources/ajaxhelper/icons/accept.png',
                                    cls:'x-btn-text-icon'
                                }, {
                                    text: 'Close',
                                    handler: function(){
                                    Ext.getCmp('new_album_form').getForm().reset();
                                        Ext.getCmp('pa-win-newalbum').hide();
                                    },scope:this,
                                    icon:'/resources/ajaxhelper/icons/cross.png',
                                    cls:'x-btn-text-icon'
                                }]
                            }
                        ]
                    });

                break;
    
            }
        }

        return extwindow;

    },

    // upload a new photo

    newPhoto : function() {

        if(!this.checkPerms('write')) {
            Ext.MessageBox.alert('Permission Denied','Sorry you do not have permission to perform this action.')
            return;
        }
    
        var extwindow = this.createOrGetWindow('pa-win-newphoto');
        var formname = 'new_photo_form';
        var currentform = Ext.getCmp(formname);

        var successFn = function(o) {

            Ext.getCmp('new_photo_formid').setValue('photo_upload');

            var album_id = this.getSelectedTreeNodeId();

            Ext.getCmp('new_photo_albumid').setValue(album_id);
            Ext.getCmp('new_photo_photoid').setValue(o.responseText);

            // set the return_url
            Ext.getCmp('new_photo_returnurl').setValue(this.xmlhttpurl+'formok');

            extwindow.show();
        };

        var submitFn = function() {
            if (currentform.getForm().isValid()) {
                currentform.getForm().submit({
                    url:this.config.package_url+'photo-add-2',
                    waitMsg:'Uploading photo...',
                    reset:true,
                    scope:this,
                    success: function(form,action) {
                        if(action.result) {
                            // reload center panel
                            this.photoStore.reload();
                            // hide the window
                            extwindow.hide();

                        } else {
                            Ext.MessageBox.alert('Error','Sorry an error occured. Make sure you have filled up all required fields.')
                        }
                    },
                    failure: function(form,action) {
                        if(action.result) {
                            Ext.MessageBox.alert('Error',action.result.info) 
                        } else { 
                            Ext.MessageBox.alert('Error','Error occurred. Try again later') 
                        } 
                    }
                })
            }
        };


        currentform.getForm().reset();

        // change url to folder_edit
        currentform.buttons[0].setHandler(submitFn,this);
        currentform.buttons[0].setText('Upload');

        // use ajax to get retrieve info about the album or folder
        this.paCore.doAction('getnextobjid',successFn,this.genericErrorFn,null,null,this);

    },

    // delete a photo

    delPhoto : function(id) {
        Ext.MessageBox.confirm('Delete','Are you sure you want to delete this photo?',function(choice) {
            if (choice === "yes") {
                var success=function(o) {this.photoStore.reload()};
                var failure=this.genericErrorFn;
                this.paCore.doAction('deletephoto',success,failure,null,{confirmed_p:'t',photo_id:id,return_url:this.xmlhttpurl+'formok'},this);
            }
        },this)
    },

    // edit photo attributes

    editPhoto : function(id) {

        var extwindow = this.createOrGetWindow('pa-win-editphoto');
        var formname = 'edit_photo_form';
        var currentform = Ext.getCmp(formname);

        var successFn = function(o) {

            var resultObj = Ext.decode(o.responseText);

            if(resultObj.success) {
                Ext.getCmp('edit_photo_formid').setValue('edit_photo');
                Ext.getCmp('edit_photo_returnurl').setValue(this.xmlhttpurl+'get-onephoto?photo_id='+resultObj.info.photo_id+'&package_id='+this.config.package_id+'&mode=display');
                Ext.getCmp('edit_photo_photoid').setValue(resultObj.info.photo_id);
                Ext.getCmp('edit_photo_revisionid').setValue(resultObj.info.revision_id);
                Ext.getCmp('edit_photo_prevrevisionid').setValue(resultObj.info.prevrevision_id);
                Ext.getCmp('edit_photo_title').setValue(resultObj.info.title);
                Ext.getCmp('edit_photo_caption').setValue(resultObj.info.caption);
                Ext.getCmp('edit_photo_desc').setValue(resultObj.info.description);
                Ext.getCmp('edit_photo_story').setValue(resultObj.info.story);
                extwindow.show();
            }
        }

        var submitFn = function() {

            if (currentform.getForm().isValid()) {

                var success = function(form,action) { 
                    if(action.result) {

                        if(action.result.info != "null") {
                            // updte the caption of the node
                            Ext.get('caption-'+action.result.info.photo_id).update(action.result.info.caption);
                            if(action.result.info.story && action.result.info.story != "") {
                                var newtip = document.createAttribute('ext:qtip');
                                newtip.value = action.result.info.story;
                                Ext.get('thumb'+action.result.info.photo_id).dom.attributes.setNamedItem(newtip);
                            }
                        } else {
                            Ext.MessageBox.alert('Error','Sorry an error occured trying to create your new folder. Please try again later.')
                        }

                        // hide the window
                        Ext.getCmp('pa-win-editphoto').hide();

                    } else {
                        Ext.MessageBox.alert('Error','Sorry an error occured. Make sure you have filled up all required fields.')
                    }
                }

                var failure = function(form,action) { 
                    if(action.result) {
                        Ext.MessageBox.alert('Error',action.result.info) 
                    } else { 
                        Ext.MessageBox.alert('Error','Error occurred. Try again later') 
                    } 
                }

                this.paCore.formSubmit('editphoto', currentfor.getForm(), 'Updating photo ....', null, true, success, failure, this)
            }
        };

        // change url to folder_edit
        currentform.buttons[0].setHandler(submitFn,this);
        currentform.buttons[0].setText('Update');

        // use ajax to get retrieve info about the album or folder
        this.paCore.doAction('getonephoto',successFn,this.genericErrorFn,null,{photo_id:id,package_id:this.config.package_id,mode:'edit'},this);

    }
}


