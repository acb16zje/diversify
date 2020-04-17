<template>
  <div class="modal-card">
    <header class="modal-card-head">
      <p class="modal-card-title">
        {{ row.title }}
      </p>
    </header>

    <section class="modal-card-body content">
      <b-loading :is-full-page="false" :active.sync="isLoading" />
      <span v-html="content" /> <!-- eslint-disable-line vue/no-v-html -->
    </section>
  </div>
</template>

<script>
import Rails from '@rails/ujs';

export default {
  props: {
    row: {
      type: Object,
      required: true,
    },
  },
  data() {
    return {
      content: null,
      isLoading: true,
    };
  },
  created() {
    Rails.ajax({
      url: `/newsletters/${this.row.id}`,
      type: 'GET',
      success: (response) => {
        this.content = response.html;
        this.isLoading = false;
      },
    });
  },
};
</script>
