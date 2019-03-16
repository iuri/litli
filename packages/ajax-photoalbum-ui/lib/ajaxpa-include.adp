    <link rel="stylesheet" type="text/css" href="/resources/ajaxhelper/ext2/resources/css/ext-all.css">
    <if @theme@ not nil>
    <link rel="stylesheet" type="text/css" href="/resources/ajaxhelper/ext2/resources/css/xtheme-@theme@.css">
    </if>
    <link rel="stylesheet" type="text/css" href="/resources/ajax-photoalbum-ui/ajaxpa.css">

    <script type="text/javascript" src="/resources/ajaxhelper/ext2/adapter/ext/ext-base.js"></script>
    <script type="text/javascript" src="/resources/ajaxhelper/ext2/ext-all.js"></script>
    <script type="text/javascript" src="/resources/ajax-photoalbum-ui/data-view-plugins.js"></script>
    <script type="text/javascript" src="/resources/ajax-photoalbum-ui/FileUploadField.js"></script>
    <script type="text/javascript" src="/resources/ajax-photoalbum-ui/ajaxpa.js"></script>
    <script type="text/javascript" src="/resources/ajax-photoalbum-ui/shadowbox/adapter/shadowbox-ext.js"></script>
    <script type="text/javascript" src="/resources/ajax-photoalbum-ui/shadowbox/shadowbox.js"></script>
    <script type="text/javascript" src="/resources/ajax-photoalbum-ui/swfupload/swfupload.js"></script>
    <script type="text/javascript" src="/resources/ajax-photoalbum-ui/swfupload/swfupload.queue.js"></script>
    <script type="text/javascript" src="/resources/ajax-photoalbum-ui/swfupload/fileprogress.js"></script>

    <if @options@ defined>
    <script type="text/javascript">
    var acs_lang_text = {
        foldersalbums:"#ajax-photoalbum-ui.foldersandalbums#",
        newitem:"#ajax-photoalbum-ui.New#",
        edititem:"#ajax-photoalbum-ui.Edit#",
        deleteitem:"#ajax-photoalbum-ui.Delete#",
        folder:"#ajax-photoalbum-ui.Folder#",
        album:"#ajax-photoalbum-ui.Album#",
        photo:"#ajax-photoalbum-ui.Photo#",
        newalbum:"#photo-album.Add_a_new_album#",
        editalbum:"#photo-album._Edit#",
        newfolder:"#photo-album._Create_1#",
        editfolder:"#photo-album._Edit_1#",
        uploadphoto:"#photo-album.Upload_a_Photo#",
        editphoto:"#photo-album._Edit_2#",
        collection:"#photo-album.lt_Add_a_collection_of_p#"
    };
    Shadowbox.loadSkin('classic','/resources/ajax-photoalbum-ui/shadowbox/skin/');
    Shadowbox.loadLanguage('en', '/resources/ajax-photoalbum-ui/shadowbox/lang/');
    Shadowbox.loadPlayer(['img'], '/resources/ajax-photoalbum-ui/shadowbox/player/');
    var paInstance = new ajaxpa({@options;noquote@})
    </script>

    </if>