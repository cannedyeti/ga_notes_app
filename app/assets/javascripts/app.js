$( document ).ready(function() {
    console.log( "ready!" );

    $(".comment-reply").hide();

    $(".reply-btn").click(function(){
      $("#" + event.target.id + "_reply_form").toggle();
    });
});
