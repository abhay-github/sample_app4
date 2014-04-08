$(function(){
	$('textarea#micropost_content').maxlength({
        alwaysShow: true
    });

    $("a.reply").click(function(){
    	var uname = $(this).data('username');
    	txtarea = $('textarea#micropost_content');
    	
    	txtarea.focus();
    	txtarea.val('@' + uname);
    })

    $("#showMsg").click(function(){
        $.get("messages",{} , null, "script");
    })

    $("#showMcrpst").click(function(){
        $.get('/',{} , null, "script");
    })
});
