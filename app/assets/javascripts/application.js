//= require jquery
//= require jquery_ujs
//= require plugins/iconify

// Check for click events on the navbar burger icon
$('.navbar-burger').click(() => {
  // Toggle the "is-active" class on both the "navbar-burger" and the "navbar-menu"
  $('.navbar-burger').toggleClass('is-active');
  $('.navbar-menu').toggleClass('is-active');
});

function hideNotification($wrapper, $notification, css) {
  setTimeout(() => {
    $wrapper.addClass('is-hidden');
    $notification.removeClass(css);
  }, 2500);
}

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
