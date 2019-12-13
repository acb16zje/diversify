//= require application

$('form').on('ajax:success', (event, data) => {
  // event.preventDefault();
  // $.ajax({
  //   type: 'post',
  //   url: this.action,
  //   data: $(this).serialize(),
  //   success(response) {
  const notification = $('#notification');

  notification.addClass(data.class);
  notification.find('p').text(data.message);
  notification.toggleClass('is-hidden');
  setTimeout(() => {
    notification.toggleClass('is-hidden');
    notification.removeClass(data.class);
  }, 3000);
    
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
    dataType: 'json',
    type: 'post',
    async: false,
    contentType: 'application/json',
    data: JSON.stringify({
      time: endTime - startTime,
      location: window.location.pathname,
    }),
  });
}, false);
