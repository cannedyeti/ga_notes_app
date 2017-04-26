$( document ).ready(function() {
    console.log( "ready!" );

    $(".comment-reply").hide();

    $(".reply-btn").click(function(e){
      e.preventDefault();
      $("#" + event.target.id + "_reply_form").toggle();
    });


    $('[data-toggle="tooltip"]').tooltip();

});
