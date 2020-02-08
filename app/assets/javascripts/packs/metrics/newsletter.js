import '../application';
import Vue from 'vue/dist/vue.esm';
import SubscribersTable from '../../components/metrics/SubscribersTable.vue';
import NewslettersTable from '../../components/metrics/NewslettersTable.vue';
import Toast from '../../components/buefy/Toast.vue';
import { dangerToast } from '../../components/buefy/toast';

Vue.config.ignoredElements = [/^trix-|^action-text/];

new Vue({
  el: '#metrics-page',
  components: {
    SubscribersTable,
    NewslettersTable,
    Toast,
  },
  methods: {
    sendError(event) {
      dangerToast(event.detail[0].message);
    },
  },
});

// Require these after the Vue instance
require('trix');
require('@rails/actiontext');
