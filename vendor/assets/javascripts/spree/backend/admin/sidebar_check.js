$(document).ready(function() {

    sidebar_item =["sidebar-product","sidebar-promotions","sidebar-configuration", "sidebar-autoservice"];

    $.each(sidebar_item, function (index, value) {

        if ($.cookie(value) == 'true') {
            $('#'+ value).collapse('show');
        } else {
            $('#'+ value).collapse('hide');
        }

    });

    $(".sidebar-menu-item").click(function(){

        sidebar_item_id = $(this).find(".nav-stacked").attr('id');
        aria = $(this).find('a[aria-expanded]').attr('aria-expanded');

        $.each(sidebar_item, function (index, value) {
            $.cookie(value, 'false', { path: '/admin' });
        });

        if ((aria == 'true') && (sidebar_item_id !== 'undefined')) {
            $.cookie(sidebar_item_id, 'true', { path: '/admin' });
            console.log(aria +'='+ sidebar_item_id +'='+$.cookie(sidebar_item_id));
        }
    });

});