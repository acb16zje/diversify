<template>
  <div class="modal-card">
    <header class="modal-card-head">
      <p class="modal-card-title">
        {{ name }}
      </p>
    </header>

    <section class="modal-card-body content">
      <b-loading :is-full-page="false" :active.sync="isLoading" />
      <p>
        Skills:
        <span v-if="skills.length === 0">
          No Skills
        </span>
      </p>
      <div class="tags are-medium">
        <span v-for="skill in skills" :key="skill.id" class="tag is-primary">
          {{ skill.name }}
        </span>
      </div>
      <p>
        Members: {{ memberCount }} / {{ teamSize }}
      </p>
    </section>
  </div>
</template>

<script>
import Rails from '@rails/ujs';

export default {
  props: {
    id: {
      type: Number,
      required: true,
    },
    projectId: {
      type: Number,
      required: true,
    },
  },
  data() {
    return {
      name: '',
      skills: [],
      teamSize: 0,
      memberCount: 0,
      isLoading: true,
    };
  },
  created() {
    Rails.ajax({
      url: `/projects/${this.projectId}/teams/${this.id}`,
      type: 'GET',
      success: (data) => {
        this.isLoading = false;
        this.name = data.name;
        this.skills = data.skills;
        this.teamSize = data.teamSize;
        this.memberCount = data.memberCount;
      },
    });
  },
};
</script>
