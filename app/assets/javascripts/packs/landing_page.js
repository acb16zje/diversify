import '../../stylesheets/landing_page.scss';
import './application';
import Rails from '@rails/ujs';
import Vue from 'vue/dist/vue.esm';
import { dangerToast } from '../components/buefy/toast';

new Vue({
  el: '#app',
  data: {
    showNavbar: false,
  },
  mounted() {
    const startTime = performance.now();

    // Send time spent when user enters another page
    window.onunload = () => {
      const data = new FormData();
      data.append('time', `${performance.now() - startTime}`);
      data.append('pathname', window.location.pathname);
      data.append(Rails.csrfParam(), Rails.csrfToken());
      navigator.sendBeacon('/track_time', data);
    };

    // Newsletter page
    if (document.getElementById('newsletter')) {
      // Sends a function whenever a iframe is focused
      window.onblur = () => {
        if (document.activeElement instanceof HTMLIFrameElement) {
          this.trackSocial(document.activeElement.dataset.value);
        }
      };

      // Resets focus when user moves from social share button
      window.onmouseover = () => window.focus();
      window.ontouchend = () => window.focus();
    }
  },
  methods: {
    trackSocial(type) {
      Rails.ajax({
        url: '/track_social',
        type: 'POST',
        data: new URLSearchParams({ type }),
      });
    },
    ajaxSuccess(event) {
      const form = event.target;
      form.outerHTML = `
        <p class="subtitle is-5">${event.detail[0].message}</p>
      `;
    },
    ajaxError(event) {
      console.log(event)
      dangerToast(event.detail[0].message);
    },
  },
});
