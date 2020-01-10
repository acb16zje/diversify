import '../../stylesheets/landing_page.scss';
import './application';
import Vue from 'vue/dist/vue.esm';
import { dangerToast } from '../components/buefy/toast';

new Vue({
  el: '#app',
  data: {
    showNavbar: false,
  },
  methods: {
    ajaxError(event) {
        const messages = event.detail[0].errors
        messages.forEach(function(message) {
          dangerToast(message);
        })
      },
      
    }
});