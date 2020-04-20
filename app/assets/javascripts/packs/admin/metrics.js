import '../application';
import Vue from 'vue/dist/vue.esm';
import Datepicker from '../../admin/metrics/Datepicker.vue';
import Chartkick from '../../admin/metrics/Chartkick.vue';
import SubscribersTable from '../../admin/metrics/SubscribersTable.vue';
import NewslettersTable from '../../admin/metrics/NewslettersTable.vue';

Vue.config.ignoredElements = [/^trix-|^action-text/];

new Vue({
  el: '#metrics-page',
  components: {
    Chartkick,
    Datepicker,
    SubscribersTable,
    NewslettersTable,
  },
  data: {
    dates: [],
    graphOptionSelected: null,
  },
  computed: {
    graphOption: {
      get() {
        if (this.graphOptionSelected) {
          return this.graphOptionSelected;
        }

        const graphSelect = document.getElementById('graph-select');
        return graphSelect ? graphSelect.options[0].value : null;
      },
      set(value) {
        this.graphOptionSelected = value;
      },
    },
  },
  methods: {
    setDates(dates) {
      this.dates = dates;
    },
  },
});

// Require these after the Vue instance
require('trix');
require('@rails/actiontext');
