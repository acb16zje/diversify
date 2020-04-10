import consumer from './application';

function appendHtml(el, str) {
  const div = document.createElement('div');
  div.innerHTML = str;
  while (div.children.length > 0) {
    el.prepend(div.children[0]);
  }
}

consumer.subscriptions.create('NotificationChannel', {
  connected() {
    // Called when the subscription is ready for use on the server
    console.log('Connected');
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
    console.log('Disconnected');
  },

  received(data) {
    // Called when there's incoming data on the websocket for this channel
    const target = document.getElementById('notification');
    appendHtml(target, data.message);
    const noNotification = document.getElementById('no-notification');
    if (noNotification != null) {
      noNotification.parentNode.removeChild(noNotification);
    }
  },
});
