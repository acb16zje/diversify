<template>
  <section class="section">
    <b-loading :active.sync="isLoading" :is-full-page="false" />
    <div class="timeline is-centered" v-html="events" /> <!-- eslint-disable-line vue/no-v-html -->
    <div v-if="finished" class="is-flex">
      <span class="tag is-medium is-primary">End of Timeline</span>
    </div>
    <div v-else>
      <b-button class="block mx-auto" :loading="isLoading" :disabled="isLoading" @click="query">
        Load More
      </b-button>
    </div>
  </section>
</template>

<script>
import Rails from '@rails/ujs';
import { dangerToast } from '../buefy/toast';

export default {
  data() {
    return {
      month: -1,
      events: '',
      finished: false,
      isLoading: false,
    };
  },
  created() {
    this.query();
  },
  methods: {
    query() {
      this.isLoading = true;
      Rails.ajax({
        url: `${window.location.pathname}/timeline`,
        type: 'GET',
        data: new URLSearchParams({
          month: this.month,
        }),
        success: (data) => {
          if (!('html' in data)) {
            this.finished = true;
          } else {
            this.events = this.events.concat(data.html);
            this.month += data.m + 1;
          }
          this.isLoading = false;
        },
        error: ({ message }) => {
          dangerToast(message);
        },
      });
    },
  },
};
</script>
