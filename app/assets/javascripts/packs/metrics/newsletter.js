import '../application';
import Vue from 'vue/dist/vue.esm';
import SubscribersTable from '../../metrics/SubscribersTable.vue';
import NewslettersTable from '../../metrics/NewslettersTable.vue';

Vue.config.ignoredElements = [/^trix-|^action-text/];

new Vue({
  el: '#metrics-page',
  components: {
    SubscribersTable,
    NewslettersTable,
  },
});

// Require these after the Vue instance
require('trix');
require('@rails/actiontext');
