<template>
  <div class="modal-card">
    <header class="modal-card-head">
      <p class="modal-card-title">
        Delete {{ name }}
      </p>
    </header>

    <p class="has-background-warning p-4">
      Unexpected bad things will happen if you don't read this!
    </p>

    <section class="modal-card-body">
      <div class="content">
        <p>
          This action <strong>cannot</strong> be undone.
          This will set the category of those projects that belongs to
          <strong>{{ name }}</strong> to <code>NULL</code>.
        </p>
      </div>

      <b-button
        class="block mx-auto"
        type="is-danger"
        :loading="isLoading"
        :disabled="isLoading"
        @click="deleteCategory"
      >
        I understand the consequences, delete this category
      </b-button>
    </section>
  </div>
</template>

<script>
import Rails from '@rails/ujs';
import { mapActions } from 'vuex';
import { dangerToast, successToast } from '../../../buefy/toast';

export default {
  props: {
    id: {
      type: Number,
      required: true,
    },
    name: {
      type: String,
      required: true,
    },
  },
  data() {
    return {
      isLoading: false,
    };
  },
  methods: {
    deleteCategory() {
      this.isLoading = true;

      Rails.ajax({
        url: `/admin/categories/${this.id}`,
        type: 'DELETE',
        success: () => {
          successToast('Category deleted');
          this.removeCategory(this.id);
          this.$parent.close();
        },
        error: () => {
          dangerToast('Failed to delete category');
        },
        complete: () => {
          this.isLoading = false;
        },
      });
    },
    ...mapActions('category', ['removeCategory']),
  },
};
</script>
