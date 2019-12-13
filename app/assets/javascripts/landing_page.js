//= require application

$('form').on('ajax:success', (event, data) => {
  if (data.hasOwnProperty('class')) {
    showNotification(data.class, data.message)
  } else {
    const container = $('#formContainer');
    container.html(data.html);
  }
});

/**
 * Ajax call to send time spent when user enters another page
 */
const startTime = performance.now();

// Track time
window.addEventListener('unload', () => {
  const endTime = performance.now();
  $.ajax({
    url: '/track_time',
    type: 'post',
    async: false,
    contentType: 'application/json',
    data: JSON.stringify({time: endTime - startTime, location: window.location.pathname})
  });
}, false);
