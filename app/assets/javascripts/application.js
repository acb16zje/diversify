//= require jquery
//= require jquery_ujs

// Check for click events on the navbar burger icon
$('.navbar-burger').click(() => {
  // Toggle the "is-active" class on both the "navbar-burger" and the "navbar-menu"
  $('.navbar-burger').toggleClass('is-active');
  $('.navbar-menu').toggleClass('is-active');
});

/**
 * Function to hide notification
 * 
 * @param {*} $wrapper Wrapper div to fix notification position
 * @param {*} $notification Notification div holding the values
 * @param {*} css CSS classes to be removed
 */
function hideNotification($wrapper, $notification, css) {
  setTimeout(() => {
    $wrapper.addClass('is-hidden');
    $notification.removeClass(css);
  }, 2500);
}

/**
 * Function to show notification
 * 
 * @param {*} css CSS classes to be added
 * @param {*} message Message to be shown
 */
function showNotification(css, message) {
  const $wrapper = $('#notification');
  const $notification = $('> .notification', $wrapper);

  $notification.addClass(css);
  $('> p', $notification).text(message);
  $wrapper.removeClass('is-hidden');

  hideNotification($wrapper, $notification, css);
}

// Notification hide
(document.querySelectorAll('.notification .delete') || []).forEach(($delete) => {
  $notification = $delete.parentNode;
  $delete.addEventListener('click', () => {
    $notification.parentNode.classList.add('is-hidden');
  });
});
