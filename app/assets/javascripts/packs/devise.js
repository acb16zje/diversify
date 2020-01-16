import '../../stylesheets/devise.scss';
import './application';
import Vue from 'vue/dist/vue.esm';
import Toast from '../components/buefy/Toast.vue';
import { dangerToast } from '../components/buefy/toast';

new Vue({
  el: '#app',
  data: {
    showNavbar: false,
  },
  components: {
    Toast
  },
  methods: {
    ajaxSuccess(event) {
      const form = event.target;
      form.outerHTML = `
        <p class="subtitle is-5 has-text-centered">${event.detail[0].message}</p>
      `;
    },
    ajaxError(event) {
      const messages = event.detail[0].errors;
      messages.forEach((message) => {
        dangerToast(message);
      });
    },
  },
});
