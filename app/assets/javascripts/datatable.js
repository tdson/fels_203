$(document).ready(function(){
  $('#categories-data-table').DataTable({
    'order': [[4, 'asc']],
    'pageLength': 20,
    'bPaginate': false,
    'bFilter': false
  });
});
