<template>
  <section class="section has-text-centered">
    <b-loading :active.sync="isLoading" :is-full-page="false" />
    <div class="timeline is-centered" v-html="events" /> <!-- eslint-disable-line vue/no-v-html -->
    <div v-if="finished" class="tag is-medium is-primary">
      End of Timeline
    </div>
    <b-button v-else :loading="isLoading" :disabled="isLoading" @click="query">
      Load More
    </b-button>
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
        data: new URLSearchParams({ month: this.month }),
        success: ({ html, m }) => {
          if (html === undefined) {
            this.finished = true;
          } else {
            this.events = this.events.concat(html);
            this.month += m + 1;
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
