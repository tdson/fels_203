$(document).ready(function() {
  ONE_HUNDRED_PERCENT = 100;
  ONE_MINUTE_IN_SECOND = 60;
  INIT_SELECTED = 0;
  var lesson_time = $('#lesson_time').val();
  var total_words = $('.question').length;
  $('#selected').html(INIT_SELECTED);
  $('#total').html('/' + total_words);

  $('input').click(function() {
    count_checked = $('input:radio:checked').length;
    progress = count_checked / total_words * ONE_HUNDRED_PERCENT;
    $('#selected').html(count_checked);
    $('.progress-bar').css('width', progress + '%')
  });

  interval = setInterval(counter, 1000);
  var remaining_time = lesson_time * ONE_MINUTE_IN_SECOND - 1;
  function counter() {
    $('#counter').html(Math.floor(remaining_time / ONE_MINUTE_IN_SECOND) + ":" +
      (remaining_time % ONE_MINUTE_IN_SECOND));
    if(remaining_time == 0) {
      submit_form();
      clearInterval(interval)
    }
    remaining_time--;
  }

  function submit_form() {
    $('form').submit();
  }
});
