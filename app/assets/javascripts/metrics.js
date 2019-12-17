//= require application
//= require chartkick
//= require Chart.bundle
//= require modal

/**
 * AJAX function to update graph
 * Send the selected date and graph and return with partial html
 */
function updateGraphRequest(selectedDates, graph) {
  $.ajax({
    url: '/metrics/update_graph_time',
    dataType: 'json',
    type: 'post',
    contentType: 'application/json',
    data: JSON.stringify({ time: selectedDates, graph_name: graph }),
    success(result) {
      $(result.title).html(result.html);
    },
    error() {
      $('#graph-div').html('<p>No Data</p>');
    },
  });
}

/**
 * Function to update graph
 */
function changeIndexGraph() {
  const graph = document.getElementById('graph-select').value;
  const date = document.querySelector('.single-calendar')
    ._flatpickr.selectedDates;
  updateGraphRequest(date, graph);
}

/**
 * Function to setup datatable
 * @param {*} setting boolean to set configuration
 */
function tableOptions(setting) {
  return {
    responsive: true,
    dom: 'B<\'clear\'>lfrtip',
    language: {
      searchPlaceholder: 'Search',
      search: '',
    },
    order: [[1, 'desc']],
    columns: setting ? [null, null] : [
      null,
      null,
      { searchable: false, orderable: false }],
  };
}

/**
 * Initialise Flatpickr (date picker)
 */
function initFlatpickr() {
  // initalise timepicker
  const singleCalendars = flatpickr('.single-calendar', {
    mode: 'range',
    dateFormat: 'd/m/Y',
    maxDate: 'today',
  });

  if (!Array.isArray(singleCalendars) || singleCalendars.length > 0) {
    singleCalendars.config.onChange.push((selectedDates, dateStr, instance) => {
      const graph = document.getElementById('graph-select').value;
      updateGraphRequest(selectedDates, graph);
    });
  }

  $('#date-clear').click(() => singleCalendars.clear());
}

$(document).ready(function() {
  initFlatpickr();

  if ($('#graph-select').length > 0) {
    changeIndexGraph();
  }

  // initialise datatable
  $('#newsletterTable').DataTable(tableOptions(true));

  const subscriberTable = $('#subscriberTable').DataTable(tableOptions(false));

  //Display notification on newsletter ajax success
  $('#newsletterSendForm').on('ajax:success', (event, data) => {
    if (data.message) {
      showNotification(data.class, data.message);
    }
  });

  //Refreshes datatable on data delete
  $('.delete_sub').on('ajax:success', (event) => {
    showNotification('is-success', 'Email Unsubscribed!');

    subscriberTable.row($(event.target).closest('tr')).remove().draw();
  });

  if (document.body.contains(document.getElementById('notification'))) {
    hideNotification($('#notification'), $('#notification > .notification'), 'is-success');
  }
});
