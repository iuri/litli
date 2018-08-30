ad_page_contract {
    @author Gustaf Neumann

    @creation-date Jan 04, 2017
} {
    {ck_package:word,notnull ""}
    {version:word,notnull ""}
}

::richtext::ckeditor4::download -ck_package $ck_package -version $version
ad_returnredirect .
