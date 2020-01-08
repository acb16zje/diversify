import '../../../stylesheets/actiontext.scss';
import '../application';
import Vue from 'vue/dist/vue.esm';
import SubscribersTable from '../../components/metrics/SubscribersTable.vue';
import NewslettersTable from '../../components/metrics/NewslettersTable.vue';

new Vue({
  el: '#app',
  components: {
    SubscribersTable,
    NewslettersTable,
    Toast,
  },
});
