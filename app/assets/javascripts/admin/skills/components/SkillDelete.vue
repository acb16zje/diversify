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
          This will <strong>remove {{ name }}</strong>
          from all existing tasks and teams.
        </p>
      </div>

      <b-button
        class="block mx-auto"
        type="is-danger"
        :loading="isLoading"
        :disabled="isLoading"
        @click="deleteSkill"
      >
        I understand the consequences, delete this skill
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
    deleteSkill() {
      this.isLoading = true;

      Rails.ajax({
        url: `/admin/skills/${this.id}`,
        type: 'DELETE',
        success: () => {
          successToast('Skill deleted');
          this.removeSkill(this.id);
          this.$parent.close();
        },
        error: () => {
          dangerToast('Failed to delete skill');
        },
        complete: () => {
          this.isLoading = false;
        },
      });
    },
    ...mapActions('skill', ['removeSkill']),
  },
};
</script>
