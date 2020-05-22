<template>
  <div class="modal-card">
    <header class="modal-card-head">
      <p class="modal-card-title">
        Delete {{ name }}
      </p>
    </header>

    <section class="modal-card-body">
      <div class="content">
        <p>
          This will permanently remove <strong>{{ name }}</strong> from your profile.
          If you’d like to use it in the future, you will need to add it again.
        </p>
      </div>

      <b-button
        class="block mx-auto"
        type="is-danger"
        :loading="isLoading"
        :disabled="isLoading"
        @click="deleteSkill"
      >
        I understand, please delete this skill
      </b-button>
    </section>
  </div>
</template>

<script>
import Rails from '@rails/ujs';
import { mapMutations } from 'vuex';
import { successToast } from '../../buefy/toast';

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
        url: `/settings/skills?skill_id=${this.id}`,
        type: 'DELETE',
        success: () => {
          successToast('Skill deleted');
          this.removeUserSkill(this.id);
          this.$parent.close();
        },
        complete: () => {
          this.isLoading = false;
        },
      });
    },
    ...mapMutations('skill', ['removeUserSkill']),
  },
};
</script>
