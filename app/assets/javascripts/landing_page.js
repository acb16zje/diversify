//= require application


$('#newsletterSubForm').on('ajax:success', (event, data) => {
  if (data.hasOwnProperty('class')) {
    showNotification(data.class, data.message);
  } else {
    const container = $('#formContainer');
    container.html(data.html);
  }
});

$('#feedbackForm').on('ajax:success', function (event, data) {
  if (data.hasOwnProperty('class')) {
    showNotification(data.class, data.message);
    this.innerHTML = `
      <p class="subtitle is-5 has-text-centered">Thank you for your feedback</p>
    `;
  }
});

$('#feedbackForm').on('ajax:error', function (event, data) {
  console.log(data)
  if (data.responseJSON.hasOwnProperty('class')) {
    showNotification(data.responseJSON.class, data.responseJSON.message);
  }
});

$(document).ready(function() {
  var myConfObj = {
    iframeMouseOver : false
  }
  window.addEventListener('blur',function(){
    if(document.activeElement instanceof HTMLIFrameElement){
        $.ajax({
        url: '/track_social',
        type: 'post',
        contentType: 'application/json',
        data: JSON.stringify({
          value: document.activeElement.dataset.value
        }),
      });
    }
  });
  
  $(window).on('touchend mouseover',function(){
    window.focus()
  })
})

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
    data: JSON.stringify({
      time: endTime - startTime,
      pathname: window.location.pathname,
    }),
  });
}, false);
