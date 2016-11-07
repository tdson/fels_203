$(document).ready(function(){
  SHOW_TIME = 7000;
  FADE_TIME = 500;
  $('.alert-auto-hide').fadeTo(SHOW_TIME, FADE_TIME)
    .slideUp(FADE_TIME, function(){
    $('.alert-auto-hide').slideUp(FADE_TIME);
  });
});
