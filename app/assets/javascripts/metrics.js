//= require application
//= require chartkick
//= require Chart.bundle
//= require plugins/jquery.dataTables
//= require plugins/dataTables.bulma
//= require plugins/flatpickr
//= require modal

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
      updateGraphRequest(selectedDates, dateStr, graph);
    });
  }

  $('#date-clear').click(() => singleCalendars.clear());
}

document.addEventListener('DOMContentLoaded', (event) => {
  initFlatpickr();

  // initialise datatable
  $('#newsletterTable').DataTable({
    responsive: true,
    dom: 'B<"clear">lfrtip',
    language: {
      searchPlaceholder: 'Search',
      search: '',
    },
    order: [[1, 'desc']],
    columns: [
      null,
      null,
    ],
  });

  $('#newsletterSubForm').on('ajax:success', (event, data) => {
    if (data.message) {
      $('#notification').addClass(data.class);
      $('#notification > p').text(data.message);
      $('#notification').toggleClass('is-hidden');
      hideNotification('#notification', data.class);
    }
  });

  if (document.body.contains(document.getElementById('flash'))) {
    hideNotification('#flash', 'is-success');
  }
});

/**
 * AJAX function to update graph
 * Send the selected date and graph and return with partial html
 */
function updateGraphRequest(selectedDates, dateStr, graph) {
  $.ajax({
    url: '/metrics/update_graph_time',
    dataType: 'json',
    type: 'post',
    contentType: 'application/json',
    data: JSON.stringify({time: selectedDates, graph_name: graph}),
    success(result) {
      $(result.title).html(result.html);
    },
    error(xhr, status, error) {
      $('#graph-div').html('<p>No Data</p>');
    },
  });
}

/**
 * Function to update graph
 */
function changeIndexGraph() {
  const graph = document.getElementById('graph-select').value;
  const date = document.querySelector(
      '.single-calendar')._flatpickr.selectedDates;
  updateGraphRequest(date, null, graph);
}

/**
 * Function to hide notification
 */
function hideNotification(id, classList) {
  setTimeout(() => {
    $(id).toggleClass('is-hidden');
    $(id).removeClass(classList);
  }, 3000);
}

$('#unsubscribeForm').submit(function(event) {
  event.preventDefault();
  $.ajax({
    type: 'POST',
    url: this.action,
    data: $(this).serialize(),
    success(response) {
      const notification = $('#notification');

      if (response.hasOwnProperty('class')) {
        console.log(response);
        notification.addClass(response.class);
        notification.find('p').text(response.message);
        notification.toggleClass('is-hidden');
        setTimeout(() => {
          notification.toggleClass('is-hidden');
          notification.removeClass(response.class);
        }, 3000);
      } else {
        console.log(response);
        const container = $('#formContainer');
        container.html(response.html);
      }
    },
  });
});
