//= require jquery
//= require jquery_ujs

// Check for click events on the navbar burger icon
$('.navbar-burger').click(() => {
  // Toggle the "is-active" class on both the "navbar-burger" and the "navbar-menu"
  $('.navbar-burger').toggleClass('is-active');
  $('.navbar-menu').toggleClass('is-active');
});

$('#newsletterSubForm').on('submit', function (event) {
  event.preventDefault();
  $.ajax({
    type: 'POST',
    url: this.action,
    data: $(this).serialize(),
    success(response) {
      const notification = $('#notification');

      notification.addClass(response.class);
      notification.find('p').text(response.message);
      notification.toggleClass('is-hidden');
      setTimeout(() => {
        notification.toggleClass('is-hidden');
        notification.removeClass(response.class);
      }, 3000);
    },
  });
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
