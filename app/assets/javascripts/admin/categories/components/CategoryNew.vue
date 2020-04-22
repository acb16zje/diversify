<template>
  <div class="modal-card">
    <header class="modal-card-head">
      <p class="modal-card-title">
        New category
      </p>
    </header>

    <section class="modal-card-body">
      <b-field label="Name" class="required">
        <b-input v-model="name" required @keyup.native.enter="createCategory" />
      </b-field>
    </section>

    <footer class="modal-card-foot">
      <b-button
        type="is-success"
        :loading="isLoading"
        :disabled="isLoading"
        @click="createCategory"
      >
        Create category
      </b-button>

      <b-button
        :loading="isLoading"
        :disabled="isLoading"
        @click="$parent.close()"
      >
        Close
      </b-button>
    </footer>
  </div>
</template>

<script>
import Rails from '@rails/ujs';
import { mapActions } from 'vuex';
import { dangerToast, successToast } from '../../../buefy/toast';

export default {
  data() {
    return {
      name: '',
      isLoading: false,
    };
  },
  methods: {
    createCategory() {
      this.isLoading = true;

      Rails.ajax({
        url: '/admin/categories',
        type: 'POST',
        dataType: 'json',
        data: new URLSearchParams({ 'category[name]': this.name }),
        success: ({ category }) => {
          successToast('Category created');
          this.addCategory(category);
          this.$parent.close();
        },
        error: ({ message }) => {
          dangerToast(message);
        },
        complete: () => {
          this.isLoading = false;
        },
      });
    },
    ...mapActions('category', ['addCategory']),
  },
};
</script>
