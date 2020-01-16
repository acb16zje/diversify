import '../../../stylesheets/metrics_page.scss';
import '../application';
import Vue from 'vue/dist/vue.esm';
import Datepicker from '../../components/metrics/Datepicker.vue';
import Chartkick from '../../components/metrics/Chartkick.vue';

new Vue({
  el: '#app',
  components: {
    Chartkick,
    Datepicker,
  },
  data: {
    showNavbar: false,
    dates: [],
    graphOption: document.getElementById('graph-select').options[0].value,
  },
  methods: {
    setDates(dates) {
      this.dates = dates;
    },
  },
});
