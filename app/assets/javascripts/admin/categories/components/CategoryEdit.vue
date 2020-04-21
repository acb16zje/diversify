<template>
  <div class="modal-card">
    <header class="modal-card-head">
      <p class="modal-card-title">
        Edit {{ initName }}
      </p>
    </header>

    <section class="modal-card-body">
      <b-field label="Name">
        <b-input v-model="name" required @keyup.native.enter="editCategory" />
      </b-field>
    </section>

    <footer class="modal-card-foot">
      <b-button
        type="is-success"
        :loading="isLoading"
        :disabled="isLoading"
        @click="editCategory"
      >
        Save changes
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
import { mapActions } from 'vuex';
import Rails from '@rails/ujs';
import { dangerToast, successToast } from '../../../buefy/toast';

export default {
  props: {
    id: {
      type: Number,
      required: true,
    },
    initName: {
      type: String,
      required: true,
    },
  },
  data() {
    return {
      name: this.initName,
      isLoading: false,
    };
  },
  methods: {
    editCategory() {
      this.isLoading = true;

      Rails.ajax({
        url: `/admin/categories/${this.id}`,
        type: 'PATCH',
        data: new URLSearchParams({ 'category[name]': this.name }),
        success: () => {
          successToast('Category updated');
          this.updateCategory({ id: this.id, name: this.name });
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
    ...mapActions('category', ['updateCategory']),
  },
};
</script>
