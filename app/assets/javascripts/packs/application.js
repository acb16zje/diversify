// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb

import '../../stylesheets/application.scss';
import Vue from 'vue/dist/vue.esm';
import Vuex from 'vuex';
import Buefy from 'buefy';
import Icon from '../buefy/Icon.vue';
import NotificationDropdown from '../notifications/NotificationDropdown.vue';
import Toast from '../buefy/Toast.vue';
import { dangerToast } from '../buefy/toast';

require('@rails/ujs').start();
require('@iconify/iconify/dist/iconify');

Vue.use(Vuex);
Vue.use(Buefy, { defaultIconComponent: Icon });

Vue.mixin({
  components: {
    Toast,
    NotificationDropdown,
  },
  methods: {
    ajaxError({ detail: [{ message }, status] }) {
      if (message === null || message === undefined) {
        dangerToast(status);
      } else {
        dangerToast(message.length === 0 ? status : message);
      }
    },
  },
});
