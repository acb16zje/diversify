import '../../stylesheets/devise.scss';
import './application';
import Vue from 'vue/dist/vue.esm';
import { dangerToast } from '../components/buefy/toast';

new Vue({
  el: '#app',
  methods: {
    ajaxError(event) {
      const messages = event.detail[0].errors;
      messages.forEach((message) => {
        dangerToast(message);
      });
    },
  },
});
