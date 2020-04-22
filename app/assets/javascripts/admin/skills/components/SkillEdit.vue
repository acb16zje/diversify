<template>
  <div class="modal-card">
    <header class="modal-card-head">
      <p class="modal-card-title">
        Edit {{ initName }}
      </p>
    </header>

    <section class="modal-card-body">
      <b-field label="Name" class="required">
        <b-input v-model="name" required @keyup.native.enter="editSkill" />
      </b-field>

      <b-field label="Category" class="required">
        <b-select v-model="category_id" required>
          <option
            v-for="category in categories"
            :key="category.id"
            :value="category.id"
          >
            {{ category.name }}
          </option>
        </b-select>
      </b-field>
    </section>

    <footer class="modal-card-foot">
      <b-button
        type="is-success"
        :loading="isLoading"
        :disabled="isLoading"
        @click="editSkill"
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
import Rails from '@rails/ujs';
import { mapActions, mapState } from 'vuex';
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
    initCategoryId: {
      type: Number,
      required: true,
    },
  },
  data() {
    return {
      name: this.initName,
      category_id: this.initCategoryId,
      isLoading: false,
    };
  },
  computed: {
    ...mapState('category', ['categories']),
  },
  methods: {
    editSkill() {
      this.isLoading = true;

      Rails.ajax({
        url: `/admin/skills/${this.id}`,
        type: 'PATCH',
        data: new URLSearchParams({
          'skill[name]': this.name,
          'skill[category_id]': this.category_id,
        }),
        success: () => {
          successToast('Skill updated');
          this.updateSkill({
            id: this.id,
            name: this.name,
            categoryName: this.categories.find((e) => e.id === this.category_id).name,
          });
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
    ...mapActions('skill', ['updateSkill']),
  },
};
</script>
