import '../../../stylesheets/metrics_page.scss';
import '../application';
import Rails from '@rails/ujs';
import Vue from 'vue/dist/vue.esm';
import Datepicker from '../../components/metrics/Datepicker.vue';

require('chartkick');
require('chart.js');

// Chartkick and Vue workaround
const scripts = document.getElementsByTagName('script');
[...scripts].forEach((script) => {
  if (script.type === 'text/javascript') {
    script.type = 'application/javascript';
  }
});

new Vue({
  el: '#app',
  components: {
    Datepicker,
  },
  data: {
    dates: [],
    graphOption: document.getElementById('graph-select').options[0].value,
  },
  watch: {
    dates() {
      this.updateGraphRequest();
    },
    graphOption() {
      this.updateGraphRequest();
    },
  },
  mounted() {
    // Chartkick and Vue workaround
    [...scripts].forEach((script) => {
      if (script.type === 'application/javascript') {
        eval(script.text);
      }
    });

    this.updateGraphRequest();
  },
  methods: {
    setDates(dates) {
      this.dates = dates;
    },
    updateGraphRequest() {
      const data = JSON.stringify({
        time: this.dates,
        graph_name: this.graphOption,
      });

      Rails.ajax({
        url: '/metrics/update_graph_time',
        type: 'POST',
        beforeSend(xhr, options) {
          xhr.setRequestHeader('Content-Type', 'application/json');
          options.data = data;
          return true;
        },
        success(response) {
          document.getElementById(response.id).innerHTML = response.html;

          // Chartkick and Vue workaround
          [...scripts].forEach((script) => {
            if (script.type === 'text/javascript') {
              eval(script.text);
            }
          });
        },
        error() {
          document.getElementById('graph-div').innerHTML = `
            <p>No Data</p>
          `;
        },
      });
    },
  },
});
