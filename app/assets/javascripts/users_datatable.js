$(document).ready(function(){
  var default_page_length = 50;
  $('#users-data-table').DataTable({
    'order': [[1, 'asc']],
    'pageLength': default_page_length,
    'bPaginate': false,
    'bFilter': false
  });
});
