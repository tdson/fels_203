$(document).ready(function(){
  $('#words-data-table').DataTable({
    'order': [[1, 'asc']],
    'pageLength': 20,
    'bPaginate': false,
    'bFilter': false
  });

  $('#category-selectbox').change(function() {
    $('#category_id').val($(this).val());
    $.get($('#admin_search').attr('action'),
      $('#admin_search').serialize(), null, 'script');
  });

  $('form').on('change', 'input[type=checkbox]', function() {
    $('.option_checkbox').not(this).prop('checked', false);
  });
});

MAX_OPTIONS = 6;
function remove_field(link) {
  $(link).prev('input[type=hidden]').val(true);
  $(link).prev().prev().remove();
  $(link).closest('.option').css('padding-bottom', "0");
  $(link).remove();
}

function add_field(link, association, content) {
  numberOfAnswerField = $('.option').length;
  if (numberOfAnswerField >= MAX_OPTIONS) {
    return;
  }
  var new_id = new Date().getTime();
  var regexp = new RegExp('new_' + association, 'g');
  $(link).parent().before(content.replace(regexp, new_id));
}
