import './application';
import Vue from 'vue/dist/vue.esm';

new Vue({
  el: '#auth',
  methods: {
    sendResetSuccess(event) {
      const form = event.target;
      form.parentNode.parentNode.innerHTML = `
        <p class="subtitle is-6">
          Check your email for a link to reset your password. If it doesn’t 
          appear within a few minutes, check your spam folder.
        </p>
        <a class="button is-info is-fullwidth" href="/users/sign_in">
          Return to sign in
        </a>
      `;
    },
  },
});
