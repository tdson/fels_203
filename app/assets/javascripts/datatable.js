$(document).ready(function(){
  $('#data-table').DataTable({
    'order': [[5, 'asc']],
    'pageLength': 20,
    'bPaginate': false,
    'bFilter': false
  });
});
