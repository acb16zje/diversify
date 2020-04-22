<template>
  <div class="modal-card">
    <header class="modal-card-head">
      <p class="modal-card-title">
        New skill
      </p>
    </header>

    <section class="modal-card-body">
      <b-field label="Name" class="required">
        <b-input v-model="name" required @keyup.native.enter="createSkill" />
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
        @click="createSkill"
      >
        Create skill
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
  data() {
    return {
      name: '',
      category_id: '',
      isLoading: false,
    };
  },
  computed: {
    ...mapState('category', ['categories']),
  },
  methods: {
    createSkill() {
      this.isLoading = true;

      Rails.ajax({
        url: '/admin/skills',
        type: 'POST',
        dataType: 'json',
        data: new URLSearchParams({
          'skill[name]': this.name,
          'skill[category_id]': this.category_id,
        }),
        success: ({ skill }) => {
          successToast('Skill added');
          this.addSkill(skill);
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
    ...mapActions('skill', ['addSkill']),
  },
};
</script>
