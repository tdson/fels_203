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
  })
});
