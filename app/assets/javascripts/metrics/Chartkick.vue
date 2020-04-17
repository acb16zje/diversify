<template>
  <div :class="{box : graphOption !== 'Landing Page Feedback' }">
    <component :is="graphs[graphOption].component"
               :data="request"
               :title="graphOption"
               :dates="graphOption === 'Landing Page Feedback' ? dates : ''"
    />
  </div>
</template>

<script>
import Vue from 'vue/dist/vue.esm';
import Chartkick from 'vue-chartkick';
import Chart from 'chart.js';
import PieChart from './PieChart.vue';
import LineChart from './LineChart.vue';
import ColumnChart from './ColumnChart.vue';
import LandingPageFeedback from './LandingPageFeedback.vue';

Chartkick.options = {
  messages: {
    empty: 'No data',
  },
};

Vue.use(Chartkick.use(Chart));

export default {
  props: {
    dates: {
      type: [Array, String],
      required: true,
    },
    graphOption: {
      type: String,
      required: true,
    },
  },
  data() {
    return {
      graphs: {
        'Subscription Ratio': {
          component: PieChart,
          data: '/charts/subscription_ratio',
        },
        'Subscription by Date': {
          component: LineChart,
          data: '/charts/subscription_by_date',
        },
        'Landing Page Feedback': {
          component: LandingPageFeedback,
        },
        'Social Share Ratio': {
          component: PieChart,
          data: '/charts/social_share_ratio',
        },
        'Social Share by Date': {
          component: LineChart,
          data: '/charts/social_share_by_date',
        },
        'Referrers Ratio': {
          component: PieChart,
          data: '/charts/referrers_ratio',
        },
        'Referrers by Date': {
          component: LineChart,
          data: '/charts/referrers_by_date',
        },
        'Average Time Spent per Page': {
          component: ColumnChart,
          data: '/charts/average_time_spent_per_page',
        },
        'Number of Visits per Page': {
          component: ColumnChart,
          data: '/charts/number_of_visits_per_page',
        },
        'Newsletter Subscription by Date': {
          component: LineChart,
          data: '/charts/newsletter_subscription_by_date',
        },
        'Unsubscription by Newsletter': {
          component: ColumnChart,
          data: '/charts/unsubscription_by_newsletter',
        },
        'Unsubscription Reason': {
          component: PieChart,
          data: '/charts/unsubscription_reason',
        },
      },
    };
  },
  computed: {
    request() {
      return `
        ${this.graphs[this.graphOption].data}?chart[date]=${this.dates}
      `;
    },
  },
};
</script>
