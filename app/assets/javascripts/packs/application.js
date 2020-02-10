/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb

import '../../stylesheets/application.scss';
import Vue from 'vue/dist/vue.esm';
import Buefy from 'buefy';
import Icon from '../components/buefy/Icon.vue';
import Toast from '../components/buefy/Toast.vue';
import { dangerToast } from '../components/buefy/toast';

require('@rails/ujs').start();
require('@iconify/iconify/dist/iconify');

Vue.use(Buefy, { defaultIconComponent: Icon });

Vue.mixin({
  components: {
    Toast,
  },
  methods: {
    ajaxError({ detail: [response, status] }) {
      if (Array.isArray(response.message)) {
        response.message.forEach((message) => dangerToast(message));
      } else {
        dangerToast(response.message || status);
      }
    },
  },
});
