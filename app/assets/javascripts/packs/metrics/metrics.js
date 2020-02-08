import '../application';
import Vue from 'vue/dist/vue.esm';
import Datepicker from '../../components/metrics/Datepicker.vue';
import Chartkick from '../../components/metrics/Chartkick.vue';

new Vue({
  el: '#metrics-page',
  components: {
    Chartkick,
    Datepicker,
  },
  data: {
    dates: [],
    graphOption: document.getElementById('graph-select').options[0].value,
  },
  methods: {
    setDates(dates) {
      this.dates = dates;
    },
  },
});
