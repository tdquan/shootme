$(document).on('ready', function(){
  $(".alert").fadeTo(2000, 500).slideUp(500, function(){
    $(".alert").slideUp(500);
  });
  $(".notice").fadeTo(2000, 500).slideUp(500, function(){
    $(".notice").slideUp(500);
  });
});
