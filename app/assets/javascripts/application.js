//= require jquery
//= require jquery_ujs

'use strict';

// Facebook social share plugin
(function(d, s, id) {
  var js, fjs = d.getElementsByTagName(s)[0];
  if (d.getElementById(id)) return;
  js = d.createElement(s);
  js.id = id;
  js.src = 'https://connect.facebook.net/en_US/sdk.js#xfbml=1&version=v3.0';
  fjs.parentNode.insertBefore(js, fjs);
}(document, 'script', 'facebook-jssdk'));

// Check for click events on the navbar burger icon
$('.navbar-burger').click(function() {

  // Toggle the "is-active" class on both the "navbar-burger" and the "navbar-menu"
  $('.navbar-burger').toggleClass('is-active');
  $('.navbar-menu').toggleClass('is-active');
});

const openTab = (evt, tabName) => {
  $('.content-tab').each(function() {
    $(this).removeClass('show');
  });
  $('.tab').each(function() {
    $(this).removeClass('is-active');
  });
  $('#' + tabName).addClass('show');
  evt.currentTarget.className += ' is-active';
};

/**
 * Ajax call to send time spent when user enters another page
 */
const startTime = performance.now();

window.addEventListener('beforeunload', trackTime, false);

function trackTime(event) {
  const endTime = performance.now();
  $.ajax({
    url: '/track_time',
    dataType: 'json',
    type: 'post',
    contentType: 'application/json',
    data: JSON.stringify(
        {'time': endTime - startTime, 'location': window.location.pathname}),
    success: function() {
    },
    error: function(xhr, status, error) {
      console.log(error);
    },
  });
}

