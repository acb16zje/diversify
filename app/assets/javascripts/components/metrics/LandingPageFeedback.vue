<template>
  <div class="columns">
    <div class="column is-one-third">
      <div class="box has-equal-height">
        <pie-chart :data="data ? data[0] : []" :title="'Satisfaction'" />
      </div>
    </div>

    <div class="column is-one-third">
      <div class="box has-equal-height">
        <pie-chart :data="data ? data[1] : []" :title="'Channel'" />
      </div>
    </div>

    <div class="column is-one-third">
      <div class="box has-equal-height">
        <pie-chart :data="data ? data[2] : []" :title="'Interest'" />
      </div>
    </div>
  </div>
</template>

<script>
import Rails from '@rails/ujs';
import PieChart from './PieChart.vue';

export default {
  components: { PieChart },
  props: {
    dates: {
      type: [Array, String],
      required: true,
    },
  },
  data() {
    return {
      data: null,
    };
  },
  watch: {
    dates: {
      immediate: true,
      handler() {
        Rails.ajax({
          url: '/charts/landing_page_feedback',
          type: 'GET',
          data: new URLSearchParams({ 'chart[date]': this.dates }),
          success: (response) => {
            this.data = response.data;
          },
        });
      },
    },
  },
};
</script>
